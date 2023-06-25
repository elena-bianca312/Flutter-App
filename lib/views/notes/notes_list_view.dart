import 'package:flutter/material.dart';
import 'package:myproject/services/cloud/cloud_note.dart';
import 'package:myproject/utilities/dialogs/delete_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {

  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh (
      color: Colors.blue[100],
        height: 80,
        backgroundColor: Colors.white,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                child: ListTile(
                  onTap: () => onTap(note),
                  title: Text(note.text, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final shouldDelete = await showDeleteDialog(context);
                      if (shouldDelete) {
                        onDeleteNote(note);
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}