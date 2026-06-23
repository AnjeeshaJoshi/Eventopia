import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models.dart';

const _uuid = Uuid();

class AppProvider extends ChangeNotifier {
  // ── Auth ──────────────────────────────────────────────────────────────────
  AppUser? _current;
  AppUser? get current => _current;
  bool get isLoggedIn => _current != null;

  // ── Collections ───────────────────────────────────────────────────────────
  final List<AppUser> _users = _seedUsers();
  final Map<String, String> _passwords = _seedPasswords();
  final List<AppEvent> _events = _seedEvents();
  final List<Booking> _bookings = [];
  final List<WaitlistEntry> _waitlist = [];
  final List<AppNotification> _notifications = [];

  List<AppUser> get users => List.unmodifiable(_users);
  List<AppEvent> get events => List.unmodifiable(_events);
  List<Booking> get bookings => List.unmodifiable(_bookings);
  List<WaitlistEntry> get waitlist => List.unmodifiable(_waitlist);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  // ── Register (attendees self-register; admin registers organisers) ─────────
  /// Returns null on success, error string on failure.
  String? register({
    required String name,
    required String email,
    required String phone,
    required String password,
    UserRole role = UserRole.attendee,
    String? organization,
  }) {
    if (_users.any((u) =>
    u.email.trim().toLowerCase() == email.trim().toLowerCase())) {
      return 'An account with this email already exists.';
    }
    final user = AppUser(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim().toLowerCase(),
      phone: phone.trim(),
      role: role,
      organization: organization?.trim(),
      mustChangePassword: role == UserRole.organizer,
    );
    _users.add(user);
    _passwords[user.email] = password;
    notifyListeners();
    return null;
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  /// Returns null on success, error string on failure.
  String? login(String email, String password) {
    final e = email.trim().toLowerCase();
    final stored = _passwords[e];
    if (stored == null || stored != password) {
      return 'Incorrect email or password.';
    }
    _current = _users.firstWhere((u) => u.email == e);
    notifyListeners();
    return null;
  }

  void logout() {
    _current = null;
    notifyListeners();
  }

  // ── Event CRUD ────────────────────────────────────────────────────────────
  AppEvent createEvent({
    required String title,
    required String description,
    required DateTime date,
    required TimeOfDay start,
    required TimeOfDay end,
    required List<TicketType> ticketTypes,
    List<PromoCode> promoCodes = const [],
  }) {
    final event = AppEvent(
      id: _uuid.v4(),
      title: title,
      description: description,
      date: date,
      start: start,
      end: end,
      organizerId: _current!.id,
      organizerName: _current!.name,
      status: EventStatus.upcoming,
      ticketTypes: ticketTypes,
      promoCodes: promoCodes,
    );
    _events.add(event);
    notifyListeners();
    return event;
  }

  // ── Booking ───────────────────────────────────────────────────────────────
  /// Returns the booking or null if unavailable.
  Booking? book({
    required String eventId,
    required TicketCategory category,
    required int quantity,
    String? promoCode,
  }) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx < 0) return null;
    final event = _events[idx];

    final typeIdx =
    event.ticketTypes.indexWhere((t) => t.category == category);
    if (typeIdx < 0) return null;
    final type = event.ticketTypes[typeIdx];
    if (type.remaining < quantity) return null;

    double subtotal = type.price * quantity;
    double discount = 0;
    String? usedPromo;

    if (promoCode != null) {
      try {
        final promo = event.promoCodes.firstWhere(
              (p) =>
          p.code.toUpperCase() == promoCode.toUpperCase() &&
              p.valid &&
              p.forCategories.contains(category),
        );
        discount = subtotal * (promo.discountPct / 100);
        usedPromo = promo.code;
      } catch (_) {}
    }

    type.sold += quantity;

    final booking = Booking(
      id: _uuid.v4(),
      eventId: eventId,
      eventTitle: event.title,
      attendeeId: _current!.id,
      attendeeName: _current!.name,
      category: category,
      quantity: quantity,
      subtotal: subtotal,
      discount: discount,
      promoCode: usedPromo,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
      qrData: 'EMS-${_uuid.v4()}',
    );
    _bookings.add(booking);
    
    addNotification(
      userId: _current!.id,
      title: 'Booking Confirmed!',
      message: 'You have successfully booked $quantity ticket(s) for ${event.title}.',
      type: NotificationType.booking,
    );

    notifyListeners();
    return booking;
  }

  // ── Cancel booking ────────────────────────────────────────────────────────
  bool cancelBooking(String bookingId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx < 0) return false;
    final b = _bookings[idx];
    final diff = DateTime.now().difference(b.createdAt);
    if (diff.inDays >= 7) return false; // past cancellation window
    final eventIdx = _events.indexWhere((e) => e.id == b.eventId);
    if (eventIdx >= 0) {
      final typeIdx = _events[eventIdx]
          .ticketTypes
          .indexWhere((t) => t.category == b.category);
      if (typeIdx >= 0) {
        _events[eventIdx].ticketTypes[typeIdx].sold -= b.quantity;
      }
    }
    _bookings.removeAt(idx);
    
    addNotification(
      userId: b.attendeeId,
      title: 'Booking Cancelled',
      message: 'Your booking for ${b.eventTitle} has been cancelled.',
      type: NotificationType.booking,
    );

    notifyListeners();
    return true;
  }

  // ── Waitlist ──────────────────────────────────────────────────────────────
  WaitlistEntry joinWaitlist(String eventId) {
    final pos =
        _waitlist.where((w) => w.eventId == eventId).length + 1;
    final entry = WaitlistEntry(
      id: _uuid.v4(),
      eventId: eventId,
      attendeeId: _current!.id,
      attendeeName: _current!.name,
      email: _current!.email,
      position: pos,
      joinedAt: DateTime.now(),
    );
    _waitlist.add(entry);
    
    final event = _events.firstWhere((e) => e.id == eventId);
    addNotification(
      userId: _current!.id,
      title: 'Joined Waitlist',
      message: 'You are now on the waitlist for ${event.title}. Position: $pos',
      type: NotificationType.waitlist,
    );

    notifyListeners();
    return entry;
  }

  bool isOnWaitlist(String eventId) =>
      _waitlist.any((w) =>
      w.eventId == eventId && w.attendeeId == _current?.id);

  // ── Check-in (QR scan) ────────────────────────────────────────────────────
  /// Returns booking title on success, null on failure.
  String? checkIn(String qrData) {
    final idx = _bookings.indexWhere((b) =>
    b.qrData == qrData &&
        b.status == BookingStatus.confirmed);
    if (idx < 0) return null;
    // In a real app mutate status; for demo we just return the name
    notifyListeners();
    return _bookings[idx].eventTitle;
  }

  // ── Conveniences ──────────────────────────────────────────────────────────
  List<Booking> get myBookings =>
      _bookings.where((b) => b.attendeeId == _current?.id).toList();

  List<AppEvent> get myEvents =>
      _events.where((e) => e.organizerId == _current?.id).toList();

  List<AppUser> get organizers =>
      _users.where((u) => u.role == UserRole.organizer).toList();

  List<AppUser> get attendeeUsers =>
      _users.where((u) => u.role == UserRole.attendee).toList();

  /// Simple revenue analytics for an event.
  Map<String, dynamic> analytics(String eventId) {
    final event = _events.firstWhere((e) => e.id == eventId);
    final bs =
    _bookings.where((b) => b.eventId == eventId).toList();
    final revenue = bs.fold<double>(0, (s, b) => s + b.total);
    final byCategory = <TicketCategory, int>{};
    for (final b in bs) {
      byCategory[b.category] =
          (byCategory[b.category] ?? 0) + b.quantity;
    }
    // Mock 7-day daily sales
    final now = DateTime.now();
    final daily = List.generate(
      7,
          (i) => DailySales(
        date: now.subtract(Duration(days: 6 - i)),
        revenue: (i + 1) * 680.0 + event.id.hashCode % 200,
        tickets: (i + 1) * 9,
      ),
    );
    return {
      'event': event,
      'totalRevenue': revenue,
      'ticketsSold': event.bookedSeats,
      'byCategory': byCategory,
      'daily': daily,
    };
  }

  // ── Notifications & Profile ────────────────────────────────────────────────
  List<AppNotification> getUserNotifications(String userId) {
    return _notifications.where((n) => n.userId == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  void markNotificationRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void addNotification({
    required String userId,
    required String title,
    required String message,
    NotificationType type = NotificationType.system,
  }) {
    _notifications.add(AppNotification(
      id: _uuid.v4(),
      userId: userId,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
    ));
    notifyListeners();
  }

  void updateProfile(String userId, String name, String phone) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx >= 0) {
      final old = _users[idx];
      _users[idx] = AppUser(
        id: old.id,
        name: name,
        email: old.email,
        phone: phone,
        role: old.role,
        organization: old.organization,
        mustChangePassword: old.mustChangePassword,
      );
      if (_current?.id == userId) {
        _current = _users[idx];
      }
      notifyListeners();
    }
  }

  void changePassword(String userId, String newPassword) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx >= 0) {
      final user = _users[idx];
      _passwords[user.email] = newPassword;
      _users[idx] = AppUser(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        organization: user.organization,
        mustChangePassword: false,
      );
      if (_current?.id == userId) {
        _current = _users[idx];
      }
      notifyListeners();
    }
  }
}

// ── Seed helpers ──────────────────────────────────────────────────────────────
Map<String, String> _seedPasswords() => {
  'admin@gmail.com': '123456',
  'binita@gmail.com': '123456',
  'kai@gmail.com': '123456',
  'mia@gmail.com': '123456',
};

List<AppUser> _seedUsers() => [
  const AppUser(
    id: 'u-admin',
    name: 'Anjeesha Joshi',
    email: 'admin@gmail.com',
    phone: '9826354769',
    role: UserRole.admin,
  ),
  const AppUser(
    id: 'u-org-1',
    name: 'Binita Dulal',
    email: 'binita@gmail.com',
    phone: '9856245872',
    role: UserRole.organizer,
    organization: 'MusicWorks',
  ),
  const AppUser(
    id: 'u-org-2',
    name: 'Kai Tan',
    email: 'kai@gmail.com',
    phone: '9864578236',
    role: UserRole.organizer,
    organization: 'TechConf Asia',
  ),
  const AppUser(
    id: 'u-att-1',
    name: 'Mia Shrestha',
    email: 'mia@gmail.com',
    phone: '9802476532',
    role: UserRole.attendee,
  ),
];

List<AppEvent> _seedEvents() {
  final now = DateTime.now();
  return [
    AppEvent(
      id: 'evt-1',
      title: 'Harmony Live Concert',
      description:
      'A spectacular night of live music across jazz, R&B and pop genres with internationally acclaimed artists.',
      date: now.add(const Duration(days: 10)),
      start: const TimeOfDay(hour: 19, minute: 30),
      end: const TimeOfDay(hour: 23, minute: 0),
      organizerId: 'u-org-1',
      organizerName: 'Binita Dulal',
      status: EventStatus.upcoming,
      ticketTypes: [
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.vip,
            price: 450,
            capacity: 60,
            sold: 18),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.general,
            price: 150,
            capacity: 300,
            sold: 142),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.senior,
            price: 90,
            capacity: 80,
            sold: 24),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.child,
            price: 50,
            capacity: 60,
            sold: 11),
      ],
      promoCodes: [
        PromoCode(
          code: 'HARMONY25',
          discountPct: 25,
          expiry: now.add(const Duration(days: 8)),
          forCategories: [TicketCategory.general],
        ),
      ],
    ),
    AppEvent(
      id: 'evt-2',
      title: 'TechVision 2026 Conference',
      description:
      'Asia\'s premier technology conference. Keynotes, workshops and networking with leaders from Google, Microsoft and regional startups.',
      date: now.add(const Duration(days: 22)),
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 18, minute: 0),
      organizerId: 'u-org-2',
      organizerName: 'Kai Tan',
      status: EventStatus.upcoming,
      ticketTypes: [
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.vip,
            price: 299,
            capacity: 50,
            sold: 8),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.general,
            price: 99,
            capacity: 400,
            sold: 213),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.senior,
            price: 60,
            capacity: 60,
            sold: 14),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.child,
            price: 30,
            capacity: 40,
            sold: 5),
      ],
      promoCodes: [
        PromoCode(
          code: 'TECH50',
          discountPct: 50,
          expiry: now.add(const Duration(days: 15)),
          forCategories: [TicketCategory.general, TicketCategory.senior],
        ),
        PromoCode(
          code: 'VIPTECH',
          discountPct: 20,
          expiry: now.add(const Duration(days: 15)),
          forCategories: [TicketCategory.vip],
        ),
      ],
    ),
    AppEvent(
      id: 'evt-3',
      title: 'Flutter & Dart Workshop',
      description:
      'Hands-on full-day workshop. Build three real-world Flutter apps from scratch. Suitable for beginner to intermediate developers.',
      date: now.add(const Duration(days: 35)),
      start: const TimeOfDay(hour: 10, minute: 0),
      end: const TimeOfDay(hour: 17, minute: 0),
      organizerId: 'u-org-2',
      organizerName: 'Kai Tan',
      status: EventStatus.upcoming,
      ticketTypes: [
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.general,
            price: 199,
            capacity: 80,
            sold: 31),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.senior,
            price: 120,
            capacity: 20,
            sold: 4),
      ],
      promoCodes: [
        PromoCode(
          code: 'DEV40',
          discountPct: 40,
          expiry: now.add(const Duration(days: 25)),
          forCategories: [
            TicketCategory.general,
            TicketCategory.senior,
          ],
        ),
      ],
    ),
    AppEvent(
      id: 'evt-4',
      title: 'Jazz Night – Sold Out',
      description:
      'An intimate evening of smooth jazz in the auditorium balcony.',
      date: now.add(const Duration(days: 5)),
      start: const TimeOfDay(hour: 20, minute: 0),
      end: const TimeOfDay(hour: 23, minute: 30),
      organizerId: 'u-org-1',
      organizerName: 'Binita Dulal',
      status: EventStatus.upcoming,
      ticketTypes: [
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.vip,
            price: 500,
            capacity: 40,
            sold: 40),
        TicketType(
            id: _uuid.v4(),
            category: TicketCategory.general,
            price: 200,
            capacity: 100,
            sold: 100),
      ],
    ),
  ];
}