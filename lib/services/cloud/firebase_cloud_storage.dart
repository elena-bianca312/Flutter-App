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
 Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // Map the notes to a CloudNote object
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .get().
      then(
        (value) => value.docs.map(
          (doc) => CloudNote.fromSnapshot(doc)),
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

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