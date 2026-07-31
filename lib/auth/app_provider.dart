import 'package:flutter/foundation.dart';

/// Deprecated compatibility shell for the retired in-memory data layer.
///
/// The application now uses [AuthProvider], [EventProvider],
/// [BookingProvider], and [UserProvider], which persist data through the
/// Firebase services. This class remains only to avoid breaking stale imports
/// while the project is migrated fully.
@Deprecated('Use the focused Firebase-backed providers instead.')
class AppProvider extends ChangeNotifier {}
