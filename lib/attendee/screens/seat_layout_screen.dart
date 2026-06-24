import 'package:flutter/material.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/booking_sheet.dart';

class SeatLayoutScreen extends StatefulWidget {
  final AppEvent event;

  const SeatLayoutScreen({super.key, required this.event});

  @override
  State<SeatLayoutScreen> createState() => _SeatLayoutScreenState();
}

class _SeatLayoutScreenState extends State<SeatLayoutScreen> {
  final Set<String> _selectedSeatIds = {};
  TicketCategory? _selectedCategory;

  void _toggleSeat(Seat seat) {
    if (seat.isBooked) return;

    setState(() {
      if (_selectedSeatIds.contains(seat.id)) {
        _selectedSeatIds.remove(seat.id);
        if (_selectedSeatIds.isEmpty) {
          _selectedCategory = null;
        }
      } else {
        if (_selectedCategory == null) {
          _selectedCategory = seat.category;
          _selectedSeatIds.add(seat.id);
        } else if (_selectedCategory == seat.category) {
          if (_selectedSeatIds.length < 10) {
            _selectedSeatIds.add(seat.id);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Maximum 10 seats allowed per booking.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only select seats from one category at a time.')),
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
    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        title: Text(widget.event.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Available', C.border),
                  const SizedBox(width: 16),
                  _buildLegendItem('Selected', C.violet),
                  const SizedBox(width: 16),
                  _buildLegendItem('Booked', Colors.grey.shade300),
                  const SizedBox(width: 16),
                  ...TicketCategory.values.map((c) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildLegendItem(c.label, c.color),
                  )),
                ],
              ),
            ),
          ),
          
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
                            child: const Text('STAGE', style: TextStyle(fontWeight: FontWeight.w700, color: C.t2, letterSpacing: 4)),
                          ),
                          const SizedBox(height: 60),

                          // Main Seating Grid
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Wing (Senior)
                              _buildWingSection(TicketCategory.senior, 'L_'),
                              
                              const SizedBox(width: 40),
                              
                              // Center Lower Foyer (General)
                              _buildCenterSection(TicketCategory.general, 'GF_'),

                              const SizedBox(width: 40),

                              // Right Wing (Child)
                              _buildWingSection(TicketCategory.child, 'R_'),
                            ],
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Control room separator
                          Container(width: 600, height: 2, color: C.border),
                          const SizedBox(height: 40),

                          // Balcony (VIP)
                          _buildCenterSection(TicketCategory.vip, 'B_'),
                          
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
                            child: const Text('CONTROL ROOM', style: TextStyle(fontWeight: FontWeight.w700, color: C.t2, letterSpacing: 4)),
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
                      '${_selectedSeatIds.length} seat(s) selected',
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
                  label: 'Continue',
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
              : (seat.isBooked ? Colors.grey.shade300 : baseColor.withOpacity(0.15)),
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
