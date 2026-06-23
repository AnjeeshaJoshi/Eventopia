import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class CreateEventSheet extends StatefulWidget {
  const CreateEventSheet();

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 18, minute: 0);

  // Ticket prices
  final _prices = {
    TicketCategory.vip: TextEditingController(text: '350'),
    TicketCategory.general: TextEditingController(text: '120'),
    TicketCategory.senior: TextEditingController(text: '70'),
    TicketCategory.child: TextEditingController(text: '40'),
  };
  final _caps = {
    TicketCategory.vip: TextEditingController(text: '50'),
    TicketCategory.general: TextEditingController(text: '300'),
    TicketCategory.senior: TextEditingController(text: '80'),
    TicketCategory.child: TextEditingController(text: '70'),
  };

  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _prices.values.forEach((c) => c.dispose());
    _caps.values.forEach((c) => c.dispose());
    super.dispose();
  }

  Future<void> _create() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final types = TicketCategory.values.map((cat) {
      return TicketType(
        id: DateTime.now().millisecondsSinceEpoch.toString() + cat.name,
        category: cat,
        price: double.tryParse(_prices[cat]!.text) ?? cat.defaultPrice,
        capacity: int.tryParse(_caps[cat]!.text) ?? 50,
      );
    }).toList();

    context.read<AppProvider>().createEvent(
          title: _title.text.trim(),
          description: _desc.text.trim(),
          date: _date,
          start: _start,
          end: _end,
          ticketTypes: types,
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
              const Text('Create New Event',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

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

              // Date & time pickers
              Row(
                children: [
                  Expanded(
                    child: GCard(
                      padding: const EdgeInsets.all(14),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                                  labelText: 'Price (MYR)',
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
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 20),

              GBtn(
                label: 'Create Event',
                onTap: _create,
                loading: _loading,
                icon: Icons.add_circle_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
