import 'package:flutter/material.dart';

// ── Enums ────────────────────────────────────────────────────────────────────
enum UserRole { admin, organizer, attendee }

enum EventStatus { planned, pending, upcoming, ongoing, completed, cancelled, postponed }

enum TicketCategory { vip, general, senior, child }

enum BookingStatus { confirmed, cancelled, checkedIn, waitlisted }

// ── Extensions ───────────────────────────────────────────────────────────────
extension TicketCategoryX on TicketCategory {
  String get label {
    switch (this) {
      case TicketCategory.vip:     return 'VIP';
      case TicketCategory.general: return 'General Admission';
      case TicketCategory.senior:  return 'Senior Citizen';
      case TicketCategory.child:   return 'Child';
    }
  }

  Color get color {
    switch (this) {
      case TicketCategory.vip:     return const Color(0xFFFFC857);
      case TicketCategory.general: return const Color(0xFF38D9A9);
      case TicketCategory.senior:  return const Color(0xFF38BDF8);
      case TicketCategory.child:   return const Color(0xFFFC9D5C);
    }
  }

  String get section {
    switch (this) {
      case TicketCategory.vip:     return 'Balcony';
      case TicketCategory.general: return 'Lower Foyer';
      case TicketCategory.senior:  return 'Ground Floor – Left';
      case TicketCategory.child:   return 'Ground Floor – Right';
    }
  }

  double get defaultPrice {
    switch (this) {
      case TicketCategory.vip:     return 350.0;
      case TicketCategory.general: return 120.0;
      case TicketCategory.senior:  return 70.0;
      case TicketCategory.child:   return 40.0;
    }
  }
}

extension EventStatusX on EventStatus {
  String get label {
    switch (this) {
      case EventStatus.planned:    return 'Planned';
      case EventStatus.pending:    return 'Pending';
      case EventStatus.upcoming:   return 'Upcoming';
      case EventStatus.ongoing:    return 'Live';
      case EventStatus.completed:  return 'Ended';
      case EventStatus.cancelled:  return 'Cancelled';
      case EventStatus.postponed:  return 'Postponed';
    }
  }

  Color get color {
    switch (this) {
      case EventStatus.planned:    return const Color(0xFFAAAAAA);
      case EventStatus.pending:    return const Color(0xFFFB923C); // Orange for pending
      case EventStatus.upcoming:   return const Color(0xFF38BDF8);
      case EventStatus.ongoing:    return const Color(0xFF38D9A9);
      case EventStatus.completed:  return const Color(0xFF55556A);
      case EventStatus.cancelled:  return const Color(0xFFFC5C7C);
      case EventStatus.postponed:  return const Color(0xFFFACC15);
    }
  }
}

// ── User ─────────────────────────────────────────────────────────────────────
class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? organization;
  final bool mustChangePassword;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.organization,
    this.mustChangePassword = false,
  });
}

// ── TicketType ────────────────────────────────────────────────────────────────
class TicketType {
  final String id;
  final TicketCategory category;
  final double price;
  final int capacity;
  int sold;

  TicketType({
    required this.id,
    required this.category,
    required this.price,
    required this.capacity,
    this.sold = 0,
  });

  int get remaining => capacity - sold;
  bool get available => remaining > 0;
  double get occupancy => capacity > 0 ? sold / capacity : 0;
}

// ── PromoCode ─────────────────────────────────────────────────────────────────
class PromoCode {
  final String code;
  final double discountPct;
  final DateTime expiry;
  final List<TicketCategory> forCategories;

  const PromoCode({
    required this.code,
    required this.discountPct,
    required this.expiry,
    required this.forCategories,
  });

  bool get valid => expiry.isAfter(DateTime.now());
}

// ── Event ─────────────────────────────────────────────────────────────────────
class AppEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  final String organizerId;
  final String organizerName;
  final EventStatus status;
  final List<TicketType> ticketTypes;
  final List<PromoCode> promoCodes;
  final String? posterPath;

  AppEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.start,
    required this.end,
    required this.organizerId,
    required this.organizerName,
    required this.status,
    required this.ticketTypes,
    this.promoCodes = const [],
    this.posterPath,
  });

  int get totalSeats =>
      ticketTypes.fold(0, (s, t) => s + t.capacity);
  int get bookedSeats =>
      ticketTypes.fold(0, (s, t) => s + t.sold);
  int get availableSeats => totalSeats - bookedSeats;
  bool get isSoldOut => availableSeats <= 0;
  double get occupancyRate =>
      totalSeats > 0 ? bookedSeats / totalSeats : 0;

  double get lowestPrice =>
      ticketTypes.map((t) => t.price).reduce((a, b) => a < b ? a : b);
}

// ── Booking ───────────────────────────────────────────────────────────────────
class Booking {
  final String id;
  final String eventId;
  final String eventTitle;
  final String attendeeId;
  final String attendeeName;
  final TicketCategory category;
  final int quantity;
  final double subtotal;
  final double discount;
  final String? promoCode;
  final BookingStatus status;
  final DateTime createdAt;
  final String qrData;

  const Booking({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.attendeeId,
    required this.attendeeName,
    required this.category,
    required this.quantity,
    required this.subtotal,
    required this.discount,
    this.promoCode,
    required this.status,
    required this.createdAt,
    required this.qrData,
  });

  double get total => subtotal - discount;
}

// ── WaitlistEntry ─────────────────────────────────────────────────────────────
class WaitlistEntry {
  final String id;
  final String eventId;
  final String attendeeId;
  final String attendeeName;
  final String email;
  final int position;
  final DateTime joinedAt;

  const WaitlistEntry({
    required this.id,
    required this.eventId,
    required this.attendeeId,
    required this.attendeeName,
    required this.email,
    required this.position,
    required this.joinedAt,
  });
}

// ── DailySales ────────────────────────────────────────────────────────────────
class DailySales {
  final DateTime date;
  final double revenue;
  final int tickets;

  const DailySales(
      {required this.date, required this.revenue, required this.tickets});
}

// ── Notification ──────────────────────────────────────────────────────────────
enum NotificationType { booking, waitlist, reminder, system }

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.type = NotificationType.system,
  });
}