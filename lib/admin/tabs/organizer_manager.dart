import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/user_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/register_org_sheet.dart';


class OrganizerManager extends StatefulWidget {
  const OrganizerManager({super.key});

  @override
  State<OrganizerManager> createState() =>
      _OrganizerManagerState();
}


class _OrganizerManagerState extends State<OrganizerManager> {
  String filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchUsers();
    });
  }

  List<UserModel> filteredUsers(List<UserModel> users) {
    if (filter == 'organisers') {
      return users
          .where((u) => u.role == UserRole.organizer)
          .toList();
    }

    if (filter == 'attendees') {
      return users
          .where((u) => u.role == UserRole.attendee)
          .toList();
    }

    return users
        .where((u) => u.role != UserRole.admin)
        .toList();
  }


  void confirmDelete(BuildContext context, UserModel user) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text(l.deleteUser),
            content: Text(
              l.areYouSureDeleteUser(user.name),
            ),

      actions: [

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),

        TextButton(
          onPressed: () async {
            try {
              await context.read<UserProvider>().deleteUser(user.uid);
              if (context.mounted) Navigator.pop(context);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())));
              }
            }
          },
          child: Text(
            l.delete,
            style: const TextStyle(color: Colors.red),
          ),
        )
      ],
    )
    ,
    );
  }


  void editUser(BuildContext context, UserModel user) {
    final l = AppLocalizations.of(context)!;
    final name =
    TextEditingController(text: user.name);

    final phone =
    TextEditingController(text: user.phone);

    final email =
    TextEditingController(text: user.email);

    final org =
    TextEditingController(
        text: user.organization ?? ""
    );


    showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: Text(l.editUser),


            content: SizedBox(
              width: 300,
              height: 260,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    AppField(
                      label: l.name,
                      controller: name,
                      prefix: Icons.person,
                    ),
                    const SizedBox(height: 6),
                    AppField(
                      label: l.emailAddress,
                      controller: email,
                      prefix: Icons.email,
                    ),
                    const SizedBox(height: 6),
                    AppField(
                      label: l.phone,
                      controller: phone,
                      prefix: Icons.phone,
                    ),

                    if (user.role == UserRole.organizer) ...[

                      const SizedBox(height: 6),

                      AppField(
                        label: l.organisation,
                        controller: org,
                        prefix: Icons.business,
                      ),
                    ],
                  ],
                ),
              ),
            ),


            actions: [

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.cancel),
              ),


              Container(
                decoration: BoxDecoration(
                  gradient: C.gPrimary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await context.read<UserProvider>().updateUser(
                        user.copyWith(
                          name: name.text,
                          phone: phone.text,
                          email: email.text,
                          organization:
                          user.role == UserRole.organizer ? org.text : null,
                        ),
                      );
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                  child: Text(l.save),
                ),
              )
            ],
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final users = filteredUsers(
        context
            .watch<UserProvider>()
            .users
    );


    return SafeArea(

      child: Column(

        children: [


          Padding(
            padding:
            const EdgeInsets.all(16),

            child: Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  l.users,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),


                IconButton(

                  icon:
                  const Icon(Icons.add),

                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,

                      builder: (_) =>
                      const RegisterOrgSheet(),

                    );
                  },

                )

              ],
            ),
          ),


          Wrap(

            spacing: 8,

            children: const ['all', 'organisers', 'attendees'].map((e) =>
                ChoiceChip(
                  label: Text(
                    e == 'all'
                        ? l.all
                        : e == 'organisers'
                            ? l.organisers
                            : l.attendees,
                    style: TextStyle(
                      color: filter == e ? C.rose : C.t1,
                      fontWeight:
                          filter == e ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  selected: filter == e,
                  showCheckmark: true,
                  checkmarkColor: C.rose,
                  selectedColor: C.rose.withOpacity(.10),
                  backgroundColor: C.surface,
                  side: BorderSide(
                    color: filter == e ? C.rose : C.border,
                    width: filter == e ? 1.4 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) {
                    setState(() {
                      filter = e;
                    });
                  },

                )).toList(),

          ),


          Expanded(

            child: ListView.builder(

              padding:
              const EdgeInsets.all(16),

              itemCount: users.length,


              itemBuilder: (_, i) {
                final u = users[i];


                return GCard(

                  child: Row(

                    children: [

                      CircleAvatar(
                        child:
                        Text(u.name[0]),
                      ),


                      const SizedBox(width: 12),


                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              u.name,
                              style:
                              const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            Text(
                              u.email,
                              style:
                              const TextStyle(
                                fontSize: 12,
                                color: C.t2,
                              ),
                            ),

                            Text(
                              u.role.name
                                  .toUpperCase(),
                              style:
                              const TextStyle(
                                fontSize: 11,
                                color: C.org,
                              ),
                            )

                          ],
                        ),
                      ),


                      Tooltip(
                        message: l.editUser,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            editUser(context, u);
                          },
                        ),
                      ),


                      Tooltip(
                        message: l.deleteUser,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            confirmDelete(context, u);
                          },
                        ),
                      )


                    ],
                  ),
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
