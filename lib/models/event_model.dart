import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ems_app/models.dart';

class EventModel {
  final String eventId;
  final String title;
  final String description;
  final String category;
  final String venue;
  final double? latitude;
  final double? longitude;
  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  final String organizerId;
  final String organizerName;
  final EventStatus status;
  final List<TicketType> ticketTypes;
  final List<PromoCode> promoCodes;
  final List<Seat> seats;
  final String? image;
  final DateTime createdAt;

  EventModel({
    required this.eventId,
    required this.title,
    required this.description,
    this.category = '',
    required this.venue,
    this.latitude,
    this.longitude,
    required this.date,
    required this.start,
    required this.end,
    required this.organizerId,
    required this.organizerName,
    required this.status,
    required this.ticketTypes,
    this.promoCodes = const [],
    this.seats = const [],
    this.image,
    required this.createdAt,
  });

  int get totalSeats => ticketTypes.fold(0, (s, t) => s + t.capacity);
  int get bookedSeats => ticketTypes.fold(0, (s, t) => s + t.sold);
  int get availableSeats => totalSeats - bookedSeats;
  bool get isSoldOut => availableSeats <= 0;
  double get occupancyRate => totalSeats > 0 ? bookedSeats / totalSeats : 0;
  double get lowestPrice => ticketTypes.isEmpty ? 0 : ticketTypes.map((t) => t.price).reduce((a, b) => a < b ? a : b);

  factory EventModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return EventModel(
      eventId: json['eventId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String? ?? '',
      venue: json['venue'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      start: parseTime(json['start'] as String),
      end: parseTime(json['end'] as String),
      organizerId: json['organizerId'] as String,
      organizerName: json['organizerName'] as String,
      status: EventStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => EventStatus.planned),
      ticketTypes: (json['ticketTypes'] as List<dynamic>?)?.map((e) => TicketType.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      promoCodes: (json['promoCodes'] as List<dynamic>?)?.map((e) => PromoCode.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      seats: (json['seats'] as List<dynamic>?)?.map((e) => Seat.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      image: json['image'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String formatTime(TimeOfDay time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return {
      'eventId': eventId,
      'title': title,
      'description': description,
      'category': category,
      'venue': venue,
      'latitude': latitude,
      'longitude': longitude,
      'date': Timestamp.fromDate(date),
      'start': formatTime(start),
      'end': formatTime(end),
      'organizerId': organizerId,
      'organizerName': organizerName,
      'status': status.name,
      'ticketTypes': ticketTypes.map((e) => e.toJson()).toList(),
      'promoCodes': promoCodes.map((e) => e.toJson()).toList(),
      'seats': seats.map((e) => e.toJson()).toList(),
      'image': image,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  EventModel copyWith({
    String? eventId,
    String? title,
    String? description,
    String? category,
    String? venue,
    double? latitude,
    double? longitude,
    DateTime? date,
    TimeOfDay? start,
    TimeOfDay? end,
    String? organizerId,
    String? organizerName,
    EventStatus? status,
    List<TicketType>? ticketTypes,
    List<PromoCode>? promoCodes,
    List<Seat>? seats,
    String? image,
    DateTime? createdAt,
  }) {
    return EventModel(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      venue: venue ?? this.venue,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      date: date ?? this.date,
      start: start ?? this.start,
      end: end ?? this.end,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      status: status ?? this.status,
      ticketTypes: ticketTypes ?? this.ticketTypes,
      promoCodes: promoCodes ?? this.promoCodes,
      seats: seats ?? this.seats,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
