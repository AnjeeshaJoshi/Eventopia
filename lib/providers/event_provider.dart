import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/firestore_service.dart';
import '../models/event_model.dart';
import '../models.dart';

class EventProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  EventProvider() {
    listenToEvents();
  }

  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _error;
  String? _warning;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  /// A non-fatal issue from the most recent operation, such as a poster that
  /// could not be uploaded. The event itself is still saved.
  String? get warning => _warning;

  List<EventModel> get pendingEvents =>
      _events.where((e) => e.status == EventStatus.pending).toList();

  List<EventModel> get upcomingEvents =>
      _events.where((e) => e.status == EventStatus.upcoming).toList();

  List<EventModel> getMyEvents(String organizerId) {
    return _events.where((e) => e.organizerId == organizerId).toList();
  }

  void clearError() {
    _error = null;
    _warning = null;
    notifyListeners();
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    _warning = null;
    notifyListeners();

    try {
      _events = await _firestoreService.getEvents();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void listenToEvents() {
    _firestoreService.eventsStream().listen((eventsList) {
      _events = eventsList;
      notifyListeners();
    }, onError: (e) {
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime date,
    required TimeOfDay start,
    required TimeOfDay end,
    required String organizerId,
    required String organizerName,
    required List<TicketType> ticketTypes,
    List<PromoCode> promoCodes = const [],
    List<Seat> seats = const [],
    String? imagePath,
    String category = '',
  }) async {
    _isLoading = true;
    _error = null;
    _warning = null;
    notifyListeners();

    try {
      final eventId = const Uuid().v4();
      // Event posters are bundled application assets, so saving an event does
      // not depend on Firebase Storage or a remote image upload.
      final imageUrl = imagePath?.startsWith('assets/') == true
          ? imagePath
          : null;

      final newEvent = EventModel(
        eventId: eventId,
        title: title,
        description: description,
        category: category,
        venue: location,
        latitude: latitude,
        longitude: longitude,
        date: date,
        start: start,
        end: end,
        organizerId: organizerId,
        organizerName: organizerName,
        status: EventStatus.pending,
        ticketTypes: ticketTypes,
        promoCodes: promoCodes,
        seats: seats.isEmpty ? _seatsForTicketTypes(ticketTypes) : seats,
        image: imageUrl,
        createdAt: DateTime.now(),
      );

      await _firestoreService.createEvent(newEvent);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editEvent({
    required String eventId,
    required String title,
    required String description,
    required String location,
    double? latitude,
    double? longitude,
    required DateTime date,
    required TimeOfDay start,
    required TimeOfDay end,
    required List<TicketType> ticketTypes,
    List<PromoCode>? promoCodes,
    String? imagePath,
    bool removeImage = false,
  }) async {
    _isLoading = true;
    _error = null;
    _warning = null;
    notifyListeners();

    try {
      final existing = _events.firstWhere((e) => e.eventId == eventId);
      String? imageUrl = removeImage ? null : existing.image;
      if (imagePath?.startsWith('assets/') == true) {
        imageUrl = imagePath;
      }

      final updatedEvent = EventModel(
        eventId: existing.eventId,
        title: title,
        description: description,
        venue: location,
        latitude: latitude ?? existing.latitude,
        longitude: longitude ?? existing.longitude,
        date: date,
        start: start,
        end: end,
        category: existing.category,
        organizerId: existing.organizerId,
        organizerName: existing.organizerName,
        status: existing.status,
        ticketTypes: ticketTypes,
        promoCodes: promoCodes ?? existing.promoCodes,
        seats: _seatsForTicketTypes(ticketTypes, existing.seats),
        image: imageUrl,
        createdAt: existing.createdAt,
      );

      await _firestoreService.updateEvent(updatedEvent);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firestoreService.deleteEvent(eventId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEventStatus(String eventId, EventStatus newStatus) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final existing = _events.firstWhere((e) => e.eventId == eventId);
      final updated = existing.copyWith(status: newStatus);

      await _firestoreService.updateEvent(updated);
      if (existing.status != newStatus) {
        final approved = newStatus == EventStatus.upcoming;
        await _firestoreService.createNotification(
          AppNotification(
            id: const Uuid().v4(),
            userId: existing.organizerId,
            title: approved ? 'Event Approved' : 'Event Status Updated',
            message: approved
                ? 'Your event "${existing.title}" has been approved by an admin.'
                : 'Your event "${existing.title}" is now ${newStatus.name}.',
            timestamp: DateTime.now(),
            type: NotificationType.system,
          ),
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> approveEvent(String eventId) => updateEventStatus(eventId, EventStatus.upcoming);
  Future<void> rejectEvent(String eventId) => updateEventStatus(eventId, EventStatus.cancelled);

  Map<String, dynamic> analytics(String eventId) {
    final event = _events.firstWhere((e) => e.eventId == eventId);

    double revenue = 0.0;
    final byCategory = <TicketCategory, int>{};
    int totalBookedSeats = 0;

    for (final t in event.ticketTypes) {
      if (t.sold > 0) {
        revenue += t.sold * t.price;
        byCategory[t.category] = t.sold;
        totalBookedSeats += t.sold;
      }
    }

    final now = DateTime.now();
    final daily = List.generate(
      7,
      (i) {
        if (revenue == 0) {
          return DailySales(
            date: now.subtract(Duration(days: 6 - i)),
            revenue: 0,
            tickets: 0,
          );
        }
        final weights = [0.05, 0.10, 0.15, 0.20, 0.30, 0.15, 0.05];
        return DailySales(
          date: now.subtract(Duration(days: 6 - i)),
          revenue: revenue * weights[i],
          tickets: (totalBookedSeats * weights[i]).round(),
        );
      },
    );

    return {
      'event': event,
      'totalRevenue': revenue,
      'ticketsSold': totalBookedSeats,
      'byCategory': byCategory,
      'daily': daily,
    };
  }

  /// Adds a seat map for new events and backfills legacy events that were
  /// created before seat selection was introduced.
  Future<EventModel> ensureSeats(EventModel event) async {
    final seats = _seatsForTicketTypes(event.ticketTypes, event.seats);
    if (seats.length == event.seats.length) return event;

    final updated = event.copyWith(seats: seats);
    await _firestoreService.updateEvent(updated);
    final index = _events.indexWhere((item) => item.eventId == event.eventId);
    if (index != -1) {
      _events[index] = updated;
      notifyListeners();
    }
    return updated;
  }

  List<Seat> _seatsForTicketTypes(
    List<TicketType> ticketTypes, [
    List<Seat> existingSeats = const [],
  ]) {
    final seats = List<Seat>.from(existingSeats);
    const prefixes = {
      TicketCategory.vip: 'B_',
      TicketCategory.general: 'GF_',
      TicketCategory.senior: 'L_',
      TicketCategory.child: 'R_',
    };

    for (final type in ticketTypes) {
      final current = seats.where((seat) => seat.category == type.category).length;
      for (var index = current; index < type.capacity; index++) {
        final row = String.fromCharCode(65 + (index ~/ 10));
        final number = (index % 10) + 1;
        seats.add(Seat(
          id: '${prefixes[type.category]}$row$number',
          row: row,
          number: number,
          category: type.category,
        ));
      }
    }
    return seats;
  }
}
