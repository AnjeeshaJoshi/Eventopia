import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

export 'models/user_model.dart';
export 'models/event_model.dart';
export 'models/booking_model.dart';

enum UserRole { admin, organizer, attendee }

enum EventStatus { planned, pending, upcoming, ongoing, completed, cancelled, postponed }

enum TicketCategory { vip, general, senior, child }

enum BookingStatus { confirmed, cancelled, checkedIn, waitlisted }


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

  TicketType copyWith({
    String? id,
    TicketCategory? category,
    double? price,
    int? capacity,
    int? sold,
  }) {
    return TicketType(
      id: id ?? this.id,
      category: category ?? this.category,
      price: price ?? this.price,
      capacity: capacity ?? this.capacity,
      sold: sold ?? this.sold,
    );
  }
  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'] as String,
      category: TicketCategory.values.firstWhere(
            (e) => e.name == json['category'],
        orElse: () => TicketCategory.general,
      ),
      price: (json['price'] as num).toDouble(),
      capacity: json['capacity'] as int,
      sold: json['sold'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'price': price,
      'capacity': capacity,
      'sold': sold,
    };
  }
}

class Seat {
  final String id;
  final String row;
  final int number;
  final TicketCategory category;
  bool isBooked;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.category,
    this.isBooked = false,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'] as String,
      row: json['row'] as String,
      number: json['number'] as int,
      category: TicketCategory.values.firstWhere((e) => e.name == json['category'], orElse: () => TicketCategory.general),
      isBooked: json['isBooked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row': row,
      'number': number,
      'category': category.name,
      'isBooked': isBooked,
    };
  }
  Seat copyWith({
    String? id,
    String? row,
    int? number,
    TicketCategory? category,
    bool? isBooked,
  }) {
    return Seat(
      id: id ?? this.id,
      row: row ?? this.row,
      number: number ?? this.number,
      category: category ?? this.category,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}

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

  factory PromoCode.fromJson(Map<String, dynamic> json) {
    return PromoCode(
      code: json['code'] as String,
      discountPct: (json['discountPct'] as num).toDouble(),
      expiry: (json['expiry'] as Timestamp).toDate(),
      forCategories: (json['forCategories'] as List<dynamic>?)?.map((e) => TicketCategory.values.firstWhere((c) => c.name == e, orElse: () => TicketCategory.general)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discountPct': discountPct,
      'expiry': Timestamp.fromDate(expiry),
      'forCategories': forCategories.map((e) => e.name).toList(),
    };
  }
  PromoCode copyWith({
    String? code,
    double? discountPct,
    DateTime? expiry,
    List<TicketCategory>? forCategories,
  }) {
    return PromoCode(
      code: code ?? this.code,
      discountPct: discountPct ?? this.discountPct,
      expiry: expiry ?? this.expiry,
      forCategories: forCategories ?? this.forCategories,
    );
  }
}

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

  factory WaitlistEntry.fromJson(Map<String, dynamic> json) {
    return WaitlistEntry(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      attendeeId: json['attendeeId'] as String,
      attendeeName: json['attendeeName'] as String,
      email: json['email'] as String,
      position: json['position'] as int,
      joinedAt: (json['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'attendeeId': attendeeId,
      'attendeeName': attendeeName,
      'email': email,
      'position': position,
      'joinedAt': Timestamp.fromDate(joinedAt),
    };
  }
  WaitlistEntry copyWith({
    String? id,
    String? eventId,
    String? attendeeId,
    String? attendeeName,
    String? email,
    int? position,
    DateTime? joinedAt,
  }) {
    return WaitlistEntry(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      attendeeId: attendeeId ?? this.attendeeId,
      attendeeName: attendeeName ?? this.attendeeName,
      email: email ?? this.email,
      position: position ?? this.position,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class DailySales {
  final DateTime date;
  final double revenue;
  final int tickets;

  const DailySales(
      {required this.date, required this.revenue, required this.tickets});

  factory DailySales.fromJson(Map<String, dynamic> json) {
    return DailySales(
      date: (json['date'] as Timestamp).toDate(),
      revenue: (json['revenue'] as num).toDouble(),
      tickets: json['tickets'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': Timestamp.fromDate(date),
      'revenue': revenue,
      'tickets': tickets,
    };
  }
}

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

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      isRead: json['isRead'] as bool? ?? false,
      type: NotificationType.values.firstWhere((e) => e.name == json['type'], orElse: () => NotificationType.system),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'type': type.name,
    };
  }
  AppNotification copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}