import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_app/models.dart';

class BookingModel {
  final String bookingId;
  final String eventId;
  final String eventTitle;
  final String userId;
  final String attendeeName;
  final TicketCategory category;
  final int quantity;
  final double subtotal;
  final double discount;
  final String? promoCode;
  final BookingStatus status;
  final DateTime createdAt;
  final String qrData;
  final List<String> seatIds;

  const BookingModel({
    required this.bookingId,
    required this.eventId,
    required this.eventTitle,
    required this.userId,
    required this.attendeeName,
    required this.category,
    required this.quantity,
    required this.subtotal,
    required this.discount,
    this.promoCode,
    required this.status,
    required this.createdAt,
    required this.qrData,
    this.seatIds = const [],
  });

  double get total => subtotal - discount;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'] as String,
      eventId: json['eventId'] as String,
      eventTitle: json['eventTitle'] as String,
      userId: json['userId'] as String,
      attendeeName: json['attendeeName'] as String,
      category: TicketCategory.values.firstWhere((e) => e.name == json['category'], orElse: () => TicketCategory.general),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      promoCode: json['promoCode'] as String?,
      status: BookingStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => BookingStatus.confirmed),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      qrData: json['qrData'] as String,
      seatIds: (json['seatIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'userId': userId,
      'attendeeName': attendeeName,
      'category': category.name,
      'quantity': quantity,
      'subtotal': subtotal,
      'discount': discount,
      'promoCode': promoCode,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'qrData': qrData,
      'seatIds': seatIds,
    };
  }

  BookingModel copyWith({
    String? bookingId,
    String? eventId,
    String? eventTitle,
    String? userId,
    String? attendeeName,
    TicketCategory? category,
    int? quantity,
    double? subtotal,
    double? discount,
    String? promoCode,
    BookingStatus? status,
    DateTime? createdAt,
    String? qrData,
    List<String>? seatIds,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      userId: userId ?? this.userId,
      attendeeName: attendeeName ?? this.attendeeName,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      promoCode: promoCode ?? this.promoCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      qrData: qrData ?? this.qrData,
      seatIds: seatIds ?? this.seatIds,
    );
  }
}
