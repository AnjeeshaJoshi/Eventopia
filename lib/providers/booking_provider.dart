import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../services/firestore_service.dart';
import '../models/booking_model.dart';
import '../models/event_model.dart';
import '../models.dart';

class BookingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final _uuid = const Uuid();

  StreamSubscription<List<BookingModel>>? _bookingSubscription;
  StreamSubscription<List<AppNotification>>? _notificationSubscription;

  List<BookingModel> _bookings = [];
  List<AppNotification> _notifications = [];
  List<WaitlistEntry> _waitlist = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  List<AppNotification> get notifications => _notifications;
  List<WaitlistEntry> get waitlist => _waitlist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<BookingModel> getMyBookings(String userId) {
    return _bookings.where((b) => b.userId == userId).toList();
  }

  List<AppNotification> getUserNotifications(String userId) {
    return _notifications.where((n) => n.userId == userId).toList();
  }

  int unreadNotificationCount(String userId) => _notifications
      .where((notification) =>
          notification.userId == userId && !notification.isRead)
      .length;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> fetchBookings({String? userId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (userId != null) {
        _bookings = await _firestoreService.getBookingsByUser(userId);
      } else {
        _bookings = await _firestoreService.getBookings();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void listenToBookings({String? userId}) {
    _bookingSubscription?.cancel();
    _bookingSubscription = _firestoreService.bookingsStream(userId: userId).listen((bookingsList) {
      _bookings = bookingsList;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  void listenToNotifications(String userId) {
    _notificationSubscription?.cancel();
    _notificationSubscription = _firestoreService
        .notificationsStream(userId)
        .listen((notifications) {
      _notifications = notifications;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  /// Create a booking. Called from booking_sheet.dart with TicketCategory enum.
  Future<BookingModel?> createBooking({
    required String userId,
    required String attendeeName,
    required String eventId,
    required TicketCategory category,
    required int quantity,
    String? promoCode,
    List<String> seatIds = const [],
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // We need event data to compute price. Look it up or accept it as param.
      // For now, we accept the params that the screen computes.
      // The screen (booking_sheet.dart) already computes subtotal/discount,
      // but we need to get event info for eventTitle & price from Firestore.

      // Simple approach: get event from firestore
      final event = await _firestoreService.getEvent(eventId);
      if (event == null) throw Exception('Event not found');

      final ticketType = event.ticketTypes.firstWhere(
        (t) => t.category == category,
        orElse: () => throw Exception('Ticket type not found'),
      );

      int remaining = ticketType.capacity - ticketType.sold;
      if (remaining < quantity) throw Exception('Not enough tickets left');

      double price = ticketType.price;
      double subtotal = price * quantity;
      double discount = 0;
      String? usedPromo;

      if (promoCode != null && promoCode.isNotEmpty) {
        try {
          final promo = event.promoCodes.firstWhere(
            (p) => p.code.toUpperCase() == promoCode.toUpperCase() && p.valid,
          );
          discount = subtotal * (promo.discountPct / 100);
          usedPromo = promo.code;
        } catch (_) {
          // Invalid promo code, ignore
        }
      }

      final bookingId = _uuid.v4();
      // Store the document ID in the QR code so an organizer can read exactly
      // one booking document without an unrestricted collection query.
      final qrData = 'QR-$bookingId';

      final booking = BookingModel(
        bookingId: bookingId,
        eventId: event.eventId,
        eventTitle: event.title,
        userId: userId,
        attendeeName: attendeeName,
        category: category,
        quantity: quantity,
        subtotal: subtotal,
        discount: discount,
        promoCode: usedPromo,
        status: BookingStatus.confirmed,
        createdAt: DateTime.now(),
        qrData: qrData,
        seatIds: seatIds,
      );

      await _firestoreService.createBookingAndReserveTickets(booking);

// Add local notification
      await _firestoreService.createNotification(
        AppNotification(
          id: _uuid.v4(),
          userId: booking.userId,
          title: 'Booking Confirmed!',
          message: event.title,
          timestamp: DateTime.now(),
          type: NotificationType.booking,
        ),
      );
      // Let the event owner see sales as they happen, alongside the attendee's
      // confirmation above.
      await _firestoreService.createNotification(
        AppNotification(
          id: _uuid.v4(),
          userId: event.organizerId,
          title: 'New Booking',
          message: '$attendeeName • $quantity ticket(s) • ${event.title}',
          timestamp: DateTime.now(),
          type: NotificationType.booking,
        ),
      );

      _isLoading = false;
      notifyListeners();
      return booking;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final existing = _bookings.firstWhere((b) => b.bookingId == bookingId);
      final diff = DateTime.now().difference(existing.createdAt);
      if (diff.inDays >= 7) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _firestoreService.cancelBookingAndReleaseTickets(bookingId);
      final waitlist = await _firestoreService.getWaitlistForEvent(existing.eventId);
      for (final entry in waitlist) {
        await _firestoreService.createNotification(AppNotification(
          id: _uuid.v4(),
          userId: entry.attendeeId,
          title: 'Tickets Available',
          message: existing.eventTitle,
          timestamp: DateTime.now(),
          type: NotificationType.waitlist,
        ));
      }
      final idx = _bookings.indexWhere((b) => b.bookingId == bookingId);
      if (idx >= 0) {
        _bookings[idx] = _bookings[idx].copyWith(status: BookingStatus.cancelled);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> verifyTicket(String qrData, EventModel? event, String organizerId) async {
    try {
      final booking = await _firestoreService.getBookingByQrData(qrData);
      if (booking == null) return {'status': false, 'message': 'Invalid ticket'};

      if (event == null || event.eventId != booking.eventId) {
        return {'status': false, 'message': 'Event not found or mismatch'};
      }

      if (event.organizerId != organizerId) {
        return {'status': false, 'message': 'Ticket is for another organizer\'s event'};
      }

      if (booking.status == BookingStatus.checkedIn) {
        return {'status': false, 'message': 'Ticket already checked in'};
      } else if (booking.status == BookingStatus.cancelled) {
        return {'status': false, 'message': 'Ticket is cancelled.'};
      }

      // Update locally, and update in Firestore
      await _firestoreService.updateBookingStatus(booking.bookingId, 'checkedIn');
      final idx = _bookings.indexWhere((b) => b.bookingId == booking.bookingId);
      if (idx >= 0) {
        _bookings[idx] = _bookings[idx].copyWith(status: BookingStatus.checkedIn);
      }

      return {'status': true, 'message': 'Welcome! (${booking.attendeeName})'};
    } catch (e) {
      return {'status': false, 'message': 'Invalid Ticket'};
    }
  }

  Future<String?> checkIn(String qrData) async {
    try {
      final booking = await _firestoreService.getBookingByQrData(qrData);
      if (booking == null || booking.status != BookingStatus.confirmed) return null;
      await _firestoreService.updateBookingStatus(booking.bookingId, 'checkedIn');
      final idx = _bookings.indexWhere((b) => b.bookingId == booking.bookingId);
      if (idx >= 0) {
        _bookings[idx] = _bookings[idx].copyWith(status: BookingStatus.checkedIn);
      }
      notifyListeners();
      return booking.eventTitle;
    } catch (e) {
      return null;
    }
  }

  Future<WaitlistEntry?> joinWaitlist(
    String eventId, {
    required String userId,
    required String userName,
    required String email,
  }) async {
    try {
      final existingEntries = await _firestoreService.getWaitlistForEvent(eventId);
      if (existingEntries.any((entry) => entry.attendeeId == userId)) {
        return existingEntries.firstWhere((entry) => entry.attendeeId == userId);
      }
      final pos = existingEntries.length + 1;
      final entry = WaitlistEntry(
        id: _uuid.v4(),
        eventId: eventId,
        attendeeId: userId,
        attendeeName: userName,
        email: email,
        position: pos,
        joinedAt: DateTime.now(),
      );
      _waitlist.add(entry);
      await _firestoreService.createWaitlistEntry(entry);
      await _firestoreService.createNotification(AppNotification(
        id: _uuid.v4(),
        userId: userId,
        title: 'Joined Waitlist',
        message: 'Position $pos',
        timestamp: DateTime.now(),
        type: NotificationType.waitlist,
      ));

      notifyListeners();
      return entry;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  bool isOnWaitlist(String eventId, String userId) {
    return _waitlist.any((w) => w.eventId == eventId && w.attendeeId == userId);
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx].isRead = true;
      _firestoreService.markNotificationRead(id);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _bookingSubscription?.cancel();
    _notificationSubscription?.cancel();
    super.dispose();
  }
}
