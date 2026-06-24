import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
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

  String filter = "All";


  List<AppUser> filteredUsers(List<AppUser> users){

    if(filter=="Organisers"){
      return users
          .where((u)=>u.role==UserRole.organizer)
          .toList();
    }

    if(filter=="Attendees"){
      return users
          .where((u)=>u.role==UserRole.attendee)
          .toList();
    }

    return users
        .where((u)=>u.role!=UserRole.admin)
        .toList();
  }



  void confirmDelete(BuildContext context, AppUser user){

    showDialog(
      context: context,
      builder:(_)=>AlertDialog(

        title:
        const Text("Delete User"),

        content:
        Text(
          "Are you sure you want to delete ${user.name}?",
        ),

        actions:[

          TextButton(
            onPressed:()=>Navigator.pop(context),
            child:
            const Text("Cancel"),
          ),

          TextButton(
            onPressed:(){

              context
                  .read<AppProvider>()
                  .deleteUser(user.id);

              Navigator.pop(context);

            },

            child:
            const Text(
              "Delete",
              style:
              TextStyle(color:Colors.red),
            ),
          )
        ],
      ),
    );
  }




  void editUser(BuildContext context, AppUser user){

    final name =
    TextEditingController(text:user.name);

    final phone =
    TextEditingController(text:user.phone);

    final email =
    TextEditingController(text:user.email);

    final org =
    TextEditingController(
        text:user.organization ?? ""
    );


    showDialog(
      context:context,
      builder:(_)=>AlertDialog(

        title:
        const Text("Edit User"),


        content: SizedBox(
          width: 300,
          height: 260,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                AppField(
                  label: "Name",
                  controller: name,
                  prefix: Icons.person,
                ),

                const SizedBox(height: 6),

                AppField(
                  label: "Email",
                  controller: email,
                  prefix: Icons.email,
                ),

                const SizedBox(height: 6),

                AppField(
                  label: "Phone",
                  controller: phone,
                  prefix: Icons.phone,
                ),

                if (user.role == UserRole.organizer) ...[

                  const SizedBox(height: 6),

                  AppField(
                    label: "Organisation",
                    controller: org,
                    prefix: Icons.business,
                  ),
                ],
              ],
            ),
          ),
        ),


        actions:[

          TextButton(
            onPressed:()=>Navigator.pop(context),
            child:
            const Text("Cancel"),
          ),


          ElevatedButton(
            onPressed:(){

              context
                  .read<AppProvider>()
                  .updateUser(
                id:user.id,
                name:name.text,
                phone:phone.text,
                email:email.text,
                organization:
                user.role==UserRole.organizer
                    ? org.text
                    : null,
              );


              Navigator.pop(context);

            },

            child:
            const Text("Save"),
          )
        ],
      ),
    );

  }





  @override
  Widget build(BuildContext context){

    final users =
    filteredUsers(
        context.watch<AppProvider>().users
    );


    return SafeArea(

      child:Column(

        children:[


          Padding(
            padding:
            const EdgeInsets.all(16),

            child:Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children:[

                const Text(
                  "Users",
                  style:
                  TextStyle(
                    fontSize:18,
                    fontWeight:FontWeight.w700,
                  ),
                ),


                IconButton(

                  icon:
                  const Icon(Icons.add),

                  onPressed:(){

                    showModalBottomSheet(
                      context:context,
                      isScrollControlled:true,
                      backgroundColor: Colors.transparent,

                      builder:(_)=>
                      const RegisterOrgSheet(),

                    );

                  },

                )

              ],
            ),
          ),



          Wrap(

            spacing:8,

            children:[

              "All",
              "Organisers",
              "Attendees"

            ].map((e)=>ChoiceChip(

              label:Text(e),

              selected:filter==e,

              onSelected:(_){

                setState((){
                  filter=e;
                });

              },

            )).toList(),

          ),



          Expanded(

            child:ListView.builder(

              padding:
              const EdgeInsets.all(16),

              itemCount:users.length,


              itemBuilder:(_,i){

                final u=users[i];


                return GCard(

                  child:Row(

                    children:[

                      CircleAvatar(
                        child:
                        Text(u.name[0]),
                      ),


                      const SizedBox(width:12),


                      Expanded(

                        child:Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children:[

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
                                fontSize:12,
                                color:C.t2,
                              ),
                            ),

                            Text(
                              u.role.name
                                  .toUpperCase(),
                              style:
                              const TextStyle(
                                fontSize:11,
                                color:C.org,
                              ),
                            )

                          ],
                        ),
                      ),


                      IconButton(
                        icon:
                        const Icon(Icons.edit),

                        onPressed:(){

                          editUser(context,u);

                        },
                      ),



                      IconButton(

                        icon:
                        const Icon(
                          Icons.delete_outline,
                          color:Colors.red,
                        ),

                        onPressed:(){

                          confirmDelete(
                              context,u);

                        },
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