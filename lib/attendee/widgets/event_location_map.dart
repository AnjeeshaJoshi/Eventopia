import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/event_model.dart';
import '../../theme.dart';

class EventLocationMap extends StatefulWidget {
  const EventLocationMap({super.key, required this.event});

  final EventModel event;

  @override
  State<EventLocationMap> createState() => _EventLocationMapState();
}

class _EventLocationMapState extends State<EventLocationMap> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latitude = widget.event.latitude;
    final longitude = widget.event.longitude;
    if (latitude == null || longitude == null) return const SizedBox.shrink();

    final venue = LatLng(latitude, longitude);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event location',
          style: TextStyle(color: C.t1, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 220,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: venue, zoom: 15),
              markers: {
                Marker(
                  markerId: MarkerId(widget.event.eventId),
                  position: venue,
                  infoWindow: InfoWindow(
                    title: widget.event.title,
                    snippet: widget.event.venue,
                  ),
                ),
              },
              mapToolbarEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onMapCreated: (controller) {
                _controller = controller;
                controller.animateCamera(CameraUpdate.newLatLngZoom(venue, 15));
              },
            ),
          ),
        ),
      ],
    );
  }
}
