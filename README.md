# eventopia

Your Campus,Your Events,Your Vibes

## Getting Started

Eventopia is a Flutter event-management app with role-based administration,
event booking, QR ticket check-in, poster media, payments, analytics, and
interactive event-location maps.

## Google Maps setup

1. In Google Cloud Console, enable **Maps SDK for Android** and create an
   Android-restricted API key for `com.example.eventopia`.
2. Add the key to `android/local.properties` (do not commit the key):

   ```properties
   MAPS_API_KEY=your_google_maps_api_key
   ```

3. Run `flutter pub get`, then launch the app. Organizers choose the venue by
   dropping a pin in Google Maps while creating or editing an event; attendees
   can open the event's interactive map and venue marker from the event details page.

## Assignment test cases

`test/event_model_test.dart` contains four Flutter test cases, organised as two
cases for each group-member placeholder. Replace “Member 1” and “Member 2” with
your names in both the test file and final report.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
