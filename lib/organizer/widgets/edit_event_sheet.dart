import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class EditEventSheet extends StatefulWidget {
  final AppEvent event;

  const EditEventSheet({super.key, required this.event});

  @override
  State<EditEventSheet> createState() => _EditEventSheetState();
}

class _EditEventSheetState extends State<EditEventSheet> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _desc;
  late final TextEditingController _location;

  late final TextEditingController _promoCode;
  late final TextEditingController _promoDiscount;
  late DateTime _date;
  late TimeOfDay _start;
  late TimeOfDay _end;

  // Poster image
  String? _posterPath;

  late final Map<TicketCategory, TextEditingController> _prices;
  late final Map<TicketCategory, TextEditingController> _caps;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.event.title);
    _desc = TextEditingController(text: widget.event.description);
    _location = TextEditingController(text: widget.event.location);
    
    final existingPromo = widget.event.promoCodes.isNotEmpty ? widget.event.promoCodes.first : null;
    _promoCode = TextEditingController(text: existingPromo?.code ?? '');
    _promoDiscount = TextEditingController(text: existingPromo != null ? existingPromo.discountPct.toStringAsFixed(0) : '');
    
    _date = widget.event.date;
    _start = widget.event.start;
    _end = widget.event.end;
    _posterPath = widget.event.posterPath;

    _prices = {};
    _caps = {};
    for (var cat in TicketCategory.values) {
      final matches = widget.event.ticketTypes.where((t) => t.category == cat);
      final oldType = matches.isEmpty ? null : matches.first;
      _prices[cat] = TextEditingController(text: oldType?.price.toStringAsFixed(0) ?? cat.defaultPrice.toStringAsFixed(0));
      _caps[cat] = TextEditingController(text: oldType?.capacity.toString() ?? '50');
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _location.dispose();
    _promoCode.dispose();
    _promoDiscount.dispose();
    for (var c in _prices.values) { c.dispose(); }
    for (var c in _caps.values) { c.dispose(); }
    super.dispose();
  }

  Future<void> _pickPoster() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _posterPath = picked.path);
    }
  }

  Future<void> _update() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final types = TicketCategory.values.map((cat) {
      final matches = widget.event.ticketTypes.where((t) => t.category == cat);
      final oldType = matches.isEmpty ? null : matches.first;
      final price = double.tryParse(_prices[cat]!.text) ?? cat.defaultPrice;
      final cap = int.tryParse(_caps[cat]!.text) ?? 50;
      
      return TicketType(
        id: oldType?.id ?? (DateTime.now().millisecondsSinceEpoch.toString() + cat.name),
        category: cat,
        price: price,
        capacity: cap,
        sold: oldType?.sold ?? 0,
      );
    }).toList();

    final promoCodeStr = _promoCode.text.trim();
    final promoDiscountStr = _promoDiscount.text.trim();
    final promoCodes = <PromoCode>[];
    if (promoCodeStr.isNotEmpty && promoDiscountStr.isNotEmpty) {
      final discount = double.tryParse(promoDiscountStr) ?? 0;
      if (discount > 0) {
        promoCodes.add(PromoCode(
          code: promoCodeStr,
          discountPct: discount,
          expiry: _date,
          forCategories: TicketCategory.values,
        ));
      }
    }

    context.read<AppProvider>().editEvent(
          id: widget.event.id,
          title: _title.text.trim(),
          description: _desc.text.trim(),
          location: _location.text.trim(),
          date: _date,
          start: _start,
          end: _end,
          ticketTypes: types,
          posterPath: _posterPath,
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .9,
      minChildSize: .5,
      maxChildSize: .97,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Form(
          key: _form,
          child: ListView(
            controller: sc,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: C.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text('Edit Event',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              // ── Poster Image Picker ──────────────────────────────────
              const Text('Event Poster',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickPoster,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 160,
                  decoration: BoxDecoration(
                    color: C.violet.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _posterPath != null
                          ? C.violet.withOpacity(0.4)
                          : C.border,
                      width: _posterPath != null ? 1.5 : 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _posterPath != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(_posterPath!),
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _actionChip(
                                    icon: Icons.edit_rounded,
                                    label: 'Change',
                                    onTap: _pickPoster,
                                  ),
                                  const SizedBox(width: 6),
                                  _actionChip(
                                    icon: Icons.close_rounded,
                                    label: 'Remove',
                                    onTap: () =>
                                        setState(() => _posterPath = null),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_rounded,
                                size: 40,
                                color: C.violet.withOpacity(0.4)),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add event poster',
                              style: TextStyle(
                                fontSize: 13,
                                color: C.t3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Recommended: 1200 × 800 px',
                              style: TextStyle(fontSize: 10, color: C.t3.withOpacity(0.7)),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 14),

              AppField(
                label: 'Event Title',
                controller: _title,
                prefix: Icons.title_rounded,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              AppField(
                label: 'Description',
                controller: _desc,
                prefix: Icons.description_outlined,
                maxLines: 3,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              AppField(
                label: 'Location',
                controller: _location,
                prefix: Icons.location_on_outlined,
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 14),

              // Date & time pickers
              Row(
                children: [
                  Expanded(
                    child: GCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () async {
                        final prov = context.read<AppProvider>();
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          selectableDayPredicate: (day) {
                            return !prov.events.any((e) =>
                                e.id != widget.event.id && // exclude current event
                                e.status == EventStatus.ongoing &&
                                e.date.year == day.year &&
                                e.date.month == day.month &&
                                e.date.day == day.day);
                          },
                        );
                        if (d != null) setState(() => _date = d);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date',
                              style: TextStyle(fontSize: 11, color: C.t3)),
                          const SizedBox(height: 4),
                          Text(DateFormat('MMM d, y').format(_date),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () async {
                        final t = await showTimePicker(
                            context: context, initialTime: _start);
                        if (t != null) setState(() => _start = t);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start',
                              style: TextStyle(fontSize: 11, color: C.t3)),
                          const SizedBox(height: 4),
                          Text(_start.format(context),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () async {
                        final t = await showTimePicker(
                            context: context, initialTime: _end);
                        if (t != null) setState(() => _end = t);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('End',
                              style: TextStyle(fontSize: 11, color: C.t3)),
                          const SizedBox(height: 4),
                          Text(_end.format(context),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Text('Ticket Categories',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              ...TicketCategory.values.map((cat) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cat.color.withOpacity(.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cat.color.withOpacity(.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: cat.color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(cat.label,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: cat.color)),
                            const Spacer(),
                            Text(cat.section,
                                style:
                                    const TextStyle(fontSize: 10, color: C.t3)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _prices[cat],
                                keyboardType: TextInputType.number,
                                style:
                                    const TextStyle(fontSize: 13, color: C.t1),
                                decoration: InputDecoration(
                                  labelText: 'Price (NPR)',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: C.border)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: C.border)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _caps[cat],
                                keyboardType: TextInputType.number,
                                style:
                                    const TextStyle(fontSize: 13, color: C.t1),
                                decoration: InputDecoration(
                                  labelText: 'Capacity',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: C.border)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: C.border)),
                                ),
                                validator: (v) {
                                  final cap = int.tryParse(v ?? '') ?? 0;
                                  final matches = widget.event.ticketTypes.where((t) => t.category == cat);
                                  final oldSold = matches.isEmpty ? 0 : matches.first.sold;
                                  if (cap < oldSold) return 'Min $oldSold';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 20),
              const Text('Promo Code (Optional)',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppField(
                      label: 'Code (e.g. SAVE20)',
                      controller: _promoCode,
                      prefix: Icons.local_offer_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: AppField(
                      label: 'Discount %',
                      controller: _promoDiscount,
                      keyboard: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
              child: GBtn(
                label: 'Save Changes',
                onTap: _update,
                loading: _loading,
                icon: Icons.save_rounded,
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
