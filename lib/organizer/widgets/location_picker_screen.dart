import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../theme.dart';
import '../../widgets.dart';

/// The location and human-readable venue name selected by an organizer.
class EventLocationSelection {
  const EventLocationSelection({
    required this.coordinates,
    required this.name,
  });

  final LatLng coordinates;
  final String name;
}

/// Lets an organizer search for or tap a venue, then save both its name and pin.
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({
    super.key,
    this.initialLocation,
    this.initialLocationName,
  });

  final LatLng? initialLocation;
  final String? initialLocationName;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  static const _defaultLocation = LatLng(27.7172, 85.3240);
  final _searchController = TextEditingController();
  GoogleMapController? _mapController;
  late LatLng _selectedLocation;
  late String _selectedName;
  late bool _hasSelectedLocation;
  bool _isSearching = false;
  bool _isResolvingName = false;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? _defaultLocation;
    _hasSelectedLocation = widget.initialLocation != null;
    _selectedName = widget.initialLocationName?.trim().isNotEmpty == true
        ? widget.initialLocationName!.trim()
        : 'Tap the map or search for a venue';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _searchForLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || _isSearching) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSearching = true);
    try {
      final matches = await locationFromAddress(query);
      if (matches.isEmpty) throw StateError('No matching location');
      final match = matches.first;
      await _selectLocation(
        LatLng(match.latitude, match.longitude),
        fallbackName: query,
        moveCamera: true,
        keepFallbackName: true,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No matching location found. Try a more specific name.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _selectLocation(
    LatLng location, {
    String? fallbackName,
    bool moveCamera = false,
    bool keepFallbackName = false,
  }) async {
    setState(() {
      _selectedLocation = location;
      _hasSelectedLocation = true;
      _selectedName = fallbackName ?? 'Finding venue name…';
      _isResolvingName = true;
    });
    if (moveCamera) {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(location, 16),
      );
    }

    try {
      final places = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (!mounted || places.isEmpty) return;
      final place = places.first;
      final nameParts = [
        place.name,
        place.street,
        place.locality,
        place.administrativeArea,
        place.country,
      ]
          .whereType<String>()
          .map((part) => part.trim())
          .where((part) => part.isNotEmpty && !_isPlusCode(part))
          .toSet()
          .toList();
      final name = nameParts.join(', ');
      if (!keepFallbackName && name.isNotEmpty) {
        setState(() => _selectedName = name);
      }
    } catch (_) {
      // Keep the search text or the selected coordinates if reverse geocoding
      // is unavailable on the device.
    } finally {
      if (mounted) setState(() => _isResolvingName = false);
    }
  }

  bool _isPlusCode(String value) {
    return RegExp(r'^[23456789CFGHJMPQRVWX]{4,}\+').hasMatch(
      value.toUpperCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose event location'),
        backgroundColor: C.surface,
        foregroundColor: C.t1,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: widget.initialLocation == null ? 12 : 16,
            ),
            markers: _hasSelectedLocation
                ? {
                    Marker(
                      markerId: const MarkerId('event-location'),
                      position: _selectedLocation,
                      infoWindow: InfoWindow(title: _selectedName),
                    ),
                  }
                : const <Marker>{},
            onMapCreated: (controller) => _mapController = controller,
            onTap: (location) => _selectLocation(location),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchForLocation(),
                decoration: InputDecoration(
                  hintText: 'Search a place or address',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: AppLoadingIndicator(dotSize: 5),
                          ),
                        )
                      : IconButton(
                          tooltip: 'Search',
                          icon: const Icon(Icons.arrow_forward_rounded),
                          onPressed: _searchForLocation,
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: C.violet),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isResolvingName
                                ? 'Updating location…'
                                : 'Tap map to move the pin',
                            style: const TextStyle(color: C.t2, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: !_hasSelectedLocation || _isResolvingName
                          ? null
                          : () => Navigator.pop(
                                context,
                                EventLocationSelection(
                                  coordinates: _selectedLocation,
                                  name: _selectedName,
                                ),
                              ),
                      style: FilledButton.styleFrom(backgroundColor: C.violet),
                      child: const Text('Use'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
