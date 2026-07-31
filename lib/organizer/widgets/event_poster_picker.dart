import 'package:flutter/material.dart';

/// Built-in posters keep event artwork available without a paid file-hosting
/// service. Only the asset path is saved with the event document.
const eventPosterAssets = <String>[
  'assets/images/cultural.jpg',
  'assets/images/expo.jpg',
  'assets/images/fest.png',
  'assets/images/prom.jpg',
  'assets/images/workshop.jpg',
  'assets/images/career.jpg',
  'assets/images/hacathon.jpg',
  'assets/images/innovation.jpg',
];

Future<String?> showEventPosterPicker(
  BuildContext context, {
  String? selectedPoster,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => DraggableScrollableSheet(
      initialChildSize: .78,
      minChildSize: .45,
      maxChildSize: .95,
      expand: false,
      builder: (_, scrollController) => SafeArea(
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            const Text(
              'Choose an event poster',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: eventPosterAssets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
              ),
              itemBuilder: (_, index) {
                final poster = eventPosterAssets[index];
                final isSelected = poster == selectedPoster;
                return Semantics(
                  button: true,
                  selected: isSelected,
                  label: 'Select event poster ${index + 1}',
                  child: InkWell(
                    onTap: () => Navigator.pop(sheetContext, poster),
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(poster, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
