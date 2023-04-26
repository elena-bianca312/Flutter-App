import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/enums/menu_action.dart';
import 'package:myproject/services/cloud/cloud_note.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/notes/notes_list_view.dart';
import 'package:myproject/services/auth/bloc/auth_bloc.dart';
import 'package:myproject/services/auth/bloc/auth_event.dart';
import 'package:myproject/utilities/dialogs/logout_dialog.dart';
import 'package:myproject/services/cloud/firebase_cloud_storage.dart';


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
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
                return NotesListView(
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
    );
  }
}
