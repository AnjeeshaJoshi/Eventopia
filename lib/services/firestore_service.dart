import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_app/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }
  Future<void> updateUserModel(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  Stream<UserModel?> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }

  // Events
  Future<void> createEvent(EventModel event) async {
    await _db
        .collection('events')
        .doc(event.eventId)
        .set(event.toJson());
  }

  Future<EventModel?> getEvent(String id) async {
    final doc = await _db.collection('events').doc(id).get();
    if (doc.exists) {
      return EventModel.fromJson(doc.data()!);
    }
    return null;
  }
  Future<List<EventModel>> getEvents() async {
    final snapshot = await _db.collection('events').get();

    return snapshot.docs
        .map((doc) => EventModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateEvent(EventModel event) async {
    await _db
        .collection('events')
        .doc(event.eventId)
        .update(event.toJson());
  }

  Future<void> deleteEvent(String id) async {
    await _db.collection('events').doc(id).delete();
  }

  Stream<List<EventModel>> eventsStream() {
    return _db.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
    });
  }

  Future<List<EventModel>> getEventsByOrganizer(String organizerId) async {
    final snapshot = await _db.collection('events').where('organizerId', isEqualTo: organizerId).get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  // Bookings
  Future<String> createBooking(BookingModel booking) async {
    await _db.collection('bookings').doc(booking.bookingId).set(booking.toJson());
    return booking.bookingId;
  }

  /// Creates the ticket and reserves its inventory in one atomic operation.
  /// This prevents two attendees from both purchasing the final available seat.
  Future<void> createBookingAndReserveTickets(BookingModel booking) async {
    final eventRef = _db.collection('events').doc(booking.eventId);
    final bookingRef = _db.collection('bookings').doc(booking.bookingId);

    await _db.runTransaction((transaction) async {
      final eventSnapshot = await transaction.get(eventRef);
      if (!eventSnapshot.exists) throw StateError('Event not found.');

      final event = EventModel.fromJson(eventSnapshot.data()!);
      final ticketType = event.ticketTypes.firstWhere(
        (type) => type.category == booking.category,
        orElse: () => throw StateError('Ticket type not found.'),
      );
      if (ticketType.remaining < booking.quantity) {
        throw StateError('Not enough tickets left.');
      }

      final selectedSeats = event.seats
          .where((seat) => booking.seatIds.contains(seat.id))
          .toList();
      if (selectedSeats.length != booking.seatIds.length ||
          selectedSeats.any((seat) =>
              seat.isBooked || seat.category != booking.category)) {
        throw StateError('One or more selected seats are no longer available.');
      }

      final updatedTicketTypes = event.ticketTypes.map((type) {
        return type.category == booking.category
            ? type.copyWith(sold: type.sold + booking.quantity)
            : type;
      }).toList();
      final updatedSeats = event.seats.map((seat) {
        return booking.seatIds.contains(seat.id)
            ? seat.copyWith(isBooked: true)
            : seat;
      }).toList();

      transaction.set(bookingRef, booking.toJson());
      transaction.update(eventRef, {
        'ticketTypes': updatedTicketTypes.map((type) => type.toJson()).toList(),
        'seats': updatedSeats.map((seat) => seat.toJson()).toList(),
      });
    });
  }

  Future<BookingModel?> getBooking(String id) async {
    final doc = await _db.collection('bookings').doc(id).get();
    if (doc.exists) {
      return BookingModel.fromJson(doc.data()!);
    }
    return null;
  }
  Future<List<BookingModel>> getBookings() async {
    final snapshot = await _db.collection('bookings').get();
    return snapshot.docs
        .map((doc) => BookingModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateBooking(String id, Map<String, dynamic> data) async {
    await _db.collection('bookings').doc(id).update(data);
  }
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': status,
    });
  }

  /// Cancels a booking and releases its inventory atomically.
  Future<void> cancelBookingAndReleaseTickets(String bookingId) async {
    final bookingRef = _db.collection('bookings').doc(bookingId);
    await _db.runTransaction((transaction) async {
      final bookingSnapshot = await transaction.get(bookingRef);
      if (!bookingSnapshot.exists) throw StateError('Booking not found.');
      final booking = BookingModel.fromJson(bookingSnapshot.data()!);
      if (booking.status == BookingStatus.cancelled) return;

      final eventRef = _db.collection('events').doc(booking.eventId);
      final eventSnapshot = await transaction.get(eventRef);
      if (!eventSnapshot.exists) throw StateError('Event not found.');
      final event = EventModel.fromJson(eventSnapshot.data()!);

      final updatedTicketTypes = event.ticketTypes.map((type) {
        return type.category == booking.category
            ? type.copyWith(sold: (type.sold - booking.quantity).clamp(0, type.capacity).toInt())
            : type;
      }).toList();
      final updatedSeats = event.seats.map((seat) {
        return booking.seatIds.contains(seat.id)
            ? seat.copyWith(isBooked: false)
            : seat;
      }).toList();

      transaction.update(bookingRef, {'status': BookingStatus.cancelled.name});
      transaction.update(eventRef, {
        'ticketTypes': updatedTicketTypes.map((type) => type.toJson()).toList(),
        'seats': updatedSeats.map((seat) => seat.toJson()).toList(),
      });
    });
  }

  Future<void> deleteBooking(String id) async {
    await _db.collection('bookings').doc(id).delete();
  }

  Future<List<BookingModel>> getBookingsByUser(String userId) async {
    final snapshot = await _db.collection('bookings').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => BookingModel.fromJson(doc.data())).toList();
  }

  Future<List<BookingModel>> getBookingsByEvent(String eventId) async {
    final snapshot = await _db.collection('bookings').where('eventId', isEqualTo: eventId).get();
    return snapshot.docs.map((doc) => BookingModel.fromJson(doc.data())).toList();
  }

  Stream<List<BookingModel>> bookingsStream({String? userId}) {
    Query query = _db.collection('bookings');
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // Waitlist and in-app notifications
  Future<void> createWaitlistEntry(WaitlistEntry entry) => _db
      .collection('waitlists')
      .doc(entry.id)
      .set(entry.toJson());

  Future<List<WaitlistEntry>> getWaitlistForEvent(String eventId) async {
    final snapshot = await _db
        .collection('waitlists')
        .where('eventId', isEqualTo: eventId)
        .get();
    final entries = snapshot.docs
        .map((doc) => WaitlistEntry.fromJson(doc.data()))
        .toList();
    entries.sort((a, b) => a.position.compareTo(b.position));
    return entries;
  }

  Future<void> createNotification(AppNotification notification) => _db
      .collection('notifications')
      .doc(notification.id)
      .set(notification.toJson());

  Stream<List<AppNotification>> notificationsStream(String userId) => _db
      .collection('notifications')
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
    final notifications = snapshot.docs
        .map((doc) => AppNotification.fromJson(doc.data()))
        .toList();
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notifications;
  });

  Future<void> markNotificationRead(String notificationId) => _db
      .collection('notifications')
      .doc(notificationId)
      .update({'isRead': true});

  Future<BookingModel?> getBookingByQrData(String qrData) async {
    if (qrData.startsWith('QR-')) {
      final booking = await getBooking(qrData.substring(3));
      if (booking != null && booking.qrData == qrData) return booking;
    }

    // Supports legacy, short QR values for administrators. Newly-created
    // tickets use the document-ID lookup above.
    final snapshot = await _db
        .collection('bookings')
        .where('qrData', isEqualTo: qrData)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return BookingModel.fromJson(snapshot.docs.first.data());
  }
}
