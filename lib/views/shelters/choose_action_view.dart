import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/enums/menu_action.dart';
import 'package:myproject/animation/fade_animation.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/shelter_view.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';
import 'package:myproject/utilities/dialogs/logout_dialog.dart';
import 'package:myproject/views/shelters/shelters_list_view.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';

class ChooseActionView extends StatefulWidget {
  const ChooseActionView({super.key});

  @override
  State<ChooseActionView> createState() => _ChooseActionViewState();
}

class _ChooseActionViewState extends State<ChooseActionView> {

  late final FirebaseShelterStorage _sheltersService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        const BackgroundImage(),
        Scaffold(
          // backgroundColor: Colors.black.withOpacity(0.9),
          backgroundColor: Colors.transparent,
          // backgroundColor: Colors.white,
          appBar: AppBar(
            title: const FadeAnimation(2, Axis.horizontal, Text('Welcome back!', style: TextStyle(height: 0, fontSize: 14))),
            backgroundColor: Colors.transparent,
            actions: [
              FadeAnimation(2, Axis.vertical,
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(addShelterRoute);
                  },
                  icon: const Icon(Icons.add),
                )
              ),
              FadeAnimation(2, Axis.vertical,
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(chatRoute);
                  },
                  icon: const Icon(Icons.message),
                )
              ),
              FadeAnimation(2, Axis.vertical,
                PopupMenuButton<MenuAction>(
                  onSelected: (action) async {
                    switch (action) {
                      case MenuAction.logout:
                        final shouldLogout = await showLogoutDialog(context);
                        if (shouldLogout) {
                          // ignore: use_build_context_synchronously
                          context.read<AuthBloc>().add(const AuthEventLogout());
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Logout'),
                    )
                  ],
                )
              ),
            ],
          ),

          body: StreamBuilder(
            stream: _sheltersService.allShelters(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allShelters = snapshot.data as Iterable<CloudShelterInfo>;
                    return SheltersListView(
                      shelters: allShelters,
                      onDeleteShelter: (shelter) async {
                        await _sheltersService.deleteShelter(documentId: shelter.documentId);
                      },
                      onTap: (shelter) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShelterView(
                              onLike: () async {
                                await _sheltersService.likeShelter(documentId: shelter.documentId, userId: AuthService.firebase().currentUser!.id);
                              },
                              onDislike: () async {
                                await _sheltersService.dislikeShelter(documentId: shelter.documentId, userId: AuthService.firebase().currentUser!.id);
                              },
                              onRemoveLike: () async {
                                await _sheltersService.removeLikeShelter(documentId: shelter.documentId, userId: AuthService.firebase().currentUser!.id);
                              },
                              onRemoveDislike: () async {
                                await _sheltersService.removeDislikeShelter(documentId: shelter.documentId, userId: AuthService.firebase().currentUser!.id);
                              },
                              shelter: shelter,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ),
      ]
    );
  }
}