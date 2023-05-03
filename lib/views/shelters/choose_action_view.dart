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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: FadeAnimation(2, Axis.horizontal, Text('Welcome back, ${AuthService.firebase().currentUser!.email}!', style: const TextStyle(height: 0, fontSize: 14))),
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
              )
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
                    return const CircularProgressIndicator();
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          )

          // body: SingleChildScrollView(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       FadeAnimation(1, Axis.horizontal,
          //         SizedBox(
          //           height: 550,
          //           child: PageView(
          //             controller: _controller,
          //             children: const [
          //               Page1(text: "Provide Shelter", animationURL: "assets/lottie/abstract_wave.json"),
          //               Page1(text: "Find the nearest shelter", animationURL: "assets/lottie/abstract_wave.json"),
          //               Page1(text: "Make a donation", animationURL: "assets/lottie/abstract_wave.json"),
          //             ],
          //           ),
          //         )
          //       ),
          //       SmoothPageIndicator(
          //         controller: _controller,
          //         count: 3,
          //         effect: const WormEffect(
          //           dotColor: Colors.grey,
          //           activeDotColor: Colors.white,
          //           dotHeight: 20,
          //           dotWidth: 20,
          //           spacing: 60,
          //         ),
          //       ),
          //     ],
          //   )
          // ),


        ),
      ]
    );
  }
}