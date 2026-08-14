import 'package:ems_app/models.dart';
import 'package:ems_app/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

EventModel buildEvent({List<TicketType>? ticketTypes}) {
  return EventModel(
    eventId: 'event-1',
    title: 'Campus Festival',
    description: 'A test event',
    venue: 'HELP University',
    latitude: 3.1390,
    longitude: 101.6869,
    date: DateTime(2026, 8, 20),
    start: const TimeOfDay(hour: 10, minute: 0),
    end: const TimeOfDay(hour: 17, minute: 0),
    organizerId: 'organizer-1',
    organizerName: 'Test Organizer',
    status: EventStatus.upcoming,
    ticketTypes: ticketTypes ?? const [],
    createdAt: DateTime(2026, 8, 1),
  );
}
// Anjeesha - Admin and Attendee roles
void main() {
  group('Anjeesha: admin and attendee test cases', () {
    test('Admin can view correct total, booked, and available event seats', () {
      final event = buildEvent(
        ticketTypes: [
          TicketType(
            id: 'general',
            category: TicketCategory.general,
            price: 100,
            capacity: 100,
            sold: 35,
          ),
          TicketType(
            id: 'vip',
            category: TicketCategory.vip,
            price: 250,
            capacity: 20,
            sold: 10,
          ),],
      );
      expect(event.totalSeats, 120);
      expect(event.bookedSeats, 45);
      expect(event.availableSeats, 75);
    });

    test('Attendee is prevented from booking when an event is sold out', () {
      final event = buildEvent(
        ticketTypes: [
          TicketType(
            id: 'general',
            category: TicketCategory.general,
            price: 100,
            capacity: 50,
            sold: 50,
          ),
        ],
      );

      expect(event.isSoldOut, isTrue);
      expect(event.occupancyRate, 1.0);
    });
  });

  // Binita - Organizer role
  group('Binita: organizer test cases', () {
    test('Organizer can identify the lowest ticket price across categories', () {
      final event = buildEvent(
        ticketTypes: [
          TicketType(
            id: 'general',
            category: TicketCategory.general,
            price: 120,
            capacity: 80,
          ),
          TicketType(
            id: 'student',
            category: TicketCategory.child,
            price: 60,
            capacity: 30,
          ),
        ],
      );
      expect(event.lowestPrice, 60);
    });

    test('Organizer editing an event preserves its saved map coordinates', () {
      final copiedEvent = buildEvent().copyWith(title: 'Updated Festival');

      expect(copiedEvent.title, 'Updated Festival');
      expect(copiedEvent.latitude, 3.1390);
      expect(copiedEvent.longitude, 101.6869);
    });
  });
}
