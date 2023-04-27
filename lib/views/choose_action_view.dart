import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/enums/menu_action.dart';
import 'package:myproject/views/pages/page_1.dart';
import 'package:myproject/animation/fade_animation.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/cloud/cloud_note.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/notes/notes_list_view.dart';
import 'package:myproject/views/notes/notes_list_view2.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';
import 'package:myproject/utilities/dialogs/logout_dialog.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:myproject/services/cloud/firebase_cloud_storage.dart';

class ChooseActionView extends StatefulWidget {
  const ChooseActionView({super.key});

  @override
  State<ChooseActionView> createState() => _ChooseActionViewState();
}

class _ChooseActionViewState extends State<ChooseActionView> {

  final _controller = PageController();
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack (
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const FadeAnimation(2, Axis.horizontal, Text('Welcome, back!')),
            backgroundColor: Colors.transparent,
            actions: [
              FadeAnimation(2, Axis.vertical,
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
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
            stream: _notesService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    return NotesListPage(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(documentId: note.documentId);
                      },
                      onTap: (note) {
                        Navigator.of(context).pushNamed(createOrUpdateNoteRoute, arguments: note);
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