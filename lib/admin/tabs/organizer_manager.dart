import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/register_org_sheet.dart';

class OrganizerManager extends StatelessWidget {
  const OrganizerManager({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final orgs = p.organizers;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Organisers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: orgs.isEmpty
                ? const Center(
              child: Text(
                'No organisers yet. Add one above.',
                style: TextStyle(color: C.t2),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orgs.length,
              itemBuilder: (_, i) {
                final o = orgs[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: C.org.withOpacity(.15),
                          child: Text(
                            o.name[0],
                            style: const TextStyle(
                              color: C.org,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                o.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                o.email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: C.t2,
                                ),
                              ),
                              if (o.organization != null)
                                Text(
                                  o.organization!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: C.org,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: C.t3,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}