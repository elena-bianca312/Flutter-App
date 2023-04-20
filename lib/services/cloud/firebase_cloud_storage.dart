import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/cloud/cloud_note.dart';
import 'package:myproject/services/cloud/cloud_storage_constants.dart';
import 'package:myproject/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {

  // Factory constructor and singleton pattern
  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() {
    return _shared;
  }

  // Get the notes collection from firebase
  final notes = FirebaseFirestore.instance.collection('notes');

  // Create new note function
  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      'ownerUserId': ownerUserId,
      'text': '',
    });
  }

  // Map the notes to a CloudNote object
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .get().
      then(
        (value) => value.docs.map(
          (doc) {
            return CloudNote(
              documentId: doc.id,
              ownerUserId: doc.data()[ownerUserIdFieldName] as String,
              text: doc.data()[textFieldName] as String,
              );
          },
        ),
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
    notes.snapshots().map((event) => event.docs
      .map((doc) => CloudNote.fromSnapshot(doc))
      .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote({required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}