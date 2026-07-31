import 'package:flutter/material.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/booking_sheet.dart';

class SeatLayoutScreen extends StatefulWidget {
  final EventModel event;

  const SeatLayoutScreen({super.key, required this.event});

  @override
  State<SeatLayoutScreen> createState() => _SeatLayoutScreenState();
}

class _SeatLayoutScreenState extends State<SeatLayoutScreen> {
  final Set<String> _selectedSeatIds = {};
  TicketCategory? _selectedCategory;

  void _toggleSeat(Seat seat) {
    if (seat.isBooked) return;
    if (seat.category != _selectedCategory) return;

    setState(() {
      if (_selectedSeatIds.contains(seat.id)) {
        _selectedSeatIds.remove(seat.id);
      } else {
        if (_selectedSeatIds.length < 10) {
          _selectedSeatIds.add(seat.id);
        } else {
          final l = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l.maxSeatsAllowed)),
          );
        }
      }
    });
  }

  double get _totalPrice {
    if (_selectedCategory == null) return 0;
    try {
      final type = widget.event.ticketTypes.firstWhere((t) => t.category == _selectedCategory);
      return type.price * _selectedSeatIds.length;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        title: Text(widget.event.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.chooseTicketCategoryFirst,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: C.t1,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: widget.event.ticketTypes
                        .where((ticket) => ticket.capacity > 0 && ticket.available)
                        .map((t) {
                      final isSelected = _selectedCategory == t.category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            '${t.category.label} (NPR ${t.price.toStringAsFixed(0)})',
                            style: TextStyle(
                              color: isSelected ? Colors.white : C.t1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: C.violet,
                          backgroundColor: C.card,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = t.category;
                              _selectedSeatIds.clear(); // Clear previously selected seats of another category
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem(
                    l.available,
                    _selectedCategory?.color ?? C.violet,
                  ),
                  const SizedBox(width: 16),
                  _buildLegendItem(l.selected, C.violet),
                  const SizedBox(width: 16),
                  _buildLegendItem(l.booked, Colors.grey.shade300),
                  if (_selectedCategory != null) ...[
                    const SizedBox(width: 16),
                    _buildLegendItem(_selectedCategory!.label, _selectedCategory!.color),
                  ],
                ],
              ),
            ),
          ),
          
          if (_selectedCategory == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_seat_rounded,
                      size: 80,
                      color: C.violet.withOpacity(0.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l.pleaseSelectCategory,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: C.t2,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                boundaryMargin: const EdgeInsets.all(100),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Stage
                            Container(
                              width: 300,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: C.card,
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(100)),
                                border: Border.all(color: C.border),
                              ),
                              child: Text(l.stageUpper.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, color: C.t2, letterSpacing: 4)),
                            ),
                            const SizedBox(height: 60),

                            // Main Seating Grid
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Wing (Senior)
                                if (_selectedCategory == TicketCategory.senior)
                                  _buildWingSection(TicketCategory.senior, 'L_'),
                                
                                const SizedBox(width: 40),
                                
                                // Center Lower Foyer (General)
                                if (_selectedCategory == TicketCategory.general)
                                  _buildCenterSection(TicketCategory.general, 'GF_'),

                                const SizedBox(width: 40),

                                // Right Wing (Child)
                                if (_selectedCategory == TicketCategory.child)
                                  _buildWingSection(TicketCategory.child, 'R_'),
                              ],
                            ),
                            
                            // Balcony (VIP)
                            if (_selectedCategory == TicketCategory.vip) ...[
                              const SizedBox(height: 40),
                              _buildCenterSection(TicketCategory.vip, 'B_'),
                            ],
                            
                            const SizedBox(height: 40),

                            Container(
                              width: 300,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: C.card,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: C.border),
                              ),
                              child: Text(l.controlRoomUpper.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w700, color: C.t2, letterSpacing: 4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: C.surface,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.seatsSelected(_selectedSeatIds.length.toString()),
                      style: const TextStyle(fontSize: 14, color: C.t2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NPR ${_totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: C.violet),
                    ),
                  ],
                ),
                GBtn(
                  label: l.continueAction,
                  width: 140,
                  onTap: _selectedSeatIds.isEmpty
                      ? null
                      : () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => BookingSheet(
                              event: widget.event,
                              preSelectedCategory: _selectedCategory,
                              preSelectedQuantity: _selectedSeatIds.length,
                              preSelectedSeatIds: _selectedSeatIds.toList(),
                            ),
                          ).then((val) {
                            if (val == true) {
                              Navigator.pop(context); // Close seat layout on successful booking
                            }
                          });
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: C.t2, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildCenterSection(TicketCategory cat, String prefix) {
    // Generate rows
    List<String> rowNames = widget.event.seats
        .where((s) => s.category == cat && s.id.startsWith(prefix))
        .map((s) => s.row)
        .toSet()
        .toList()
      ..sort();

    return Column(
      children: rowNames.map((row) {
        final rowSeats = widget.event.seats.where((s) => s.row == row && s.id.startsWith(prefix)).toList()
          ..sort((a, b) => a.number.compareTo(b.number));
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(row.padLeft(2, ' '), style: const TextStyle(fontSize: 10, color: C.t3, fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              ...rowSeats.map((s) => _buildSeatWidget(s)),
              const SizedBox(width: 12),
              Text(row.padRight(2, ' '), style: const TextStyle(fontSize: 10, color: C.t3, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWingSection(TicketCategory cat, String prefix) {
    List<String> rowNames = widget.event.seats
        .where((s) => s.category == cat && s.id.startsWith(prefix))
        .map((s) => s.row)
        .toSet()
        .toList()
      ..sort();

    return Column(
      children: rowNames.map((row) {
        final rowSeats = widget.event.seats.where((s) => s.row == row && s.id.startsWith(prefix)).toList()
          ..sort((a, b) => a.number.compareTo(b.number));
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(row.padLeft(2, ' '), style: const TextStyle(fontSize: 10, color: C.t3, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              ...rowSeats.map((s) => _buildSeatWidget(s)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeatWidget(Seat seat) {
    bool isSelected = _selectedSeatIds.contains(seat.id);
    Color baseColor = seat.category.color;
    
    if (seat.isBooked) baseColor = Colors.grey;
    
    return GestureDetector(
      onTap: () => _toggleSeat(seat),
      child: Container(
        width: 16,
        height: 16,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? C.violet
              : (seat.isBooked
                  ? Colors.grey.shade300
                  : baseColor.withOpacity(0.32)),
          border: Border.all(
            color: isSelected 
                ? C.violet 
                : (seat.isBooked ? Colors.grey.shade400 : baseColor),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
