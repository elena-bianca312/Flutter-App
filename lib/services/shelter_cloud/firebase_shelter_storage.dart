import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/cloud/cloud_storage_exceptions.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_constants.dart';

class FirebaseCloudStorage {

  // Factory constructor and singleton pattern
  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared = FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() {
    return _shared;
  }

  // Get the shelter info collection from firebase
  final shelters = FirebaseFirestore.instance.collection('shelters');

  // Create new shelter function
 Future<CloudShelterInfo> createNewShelter({required String ownerUserId, required String userName}) async {
    final document = await shelters.add({
      ownerUserIdFieldName: ownerUserId,
      userNameFieldName: userName,
      titleFieldName: '',
      textFieldName: '',
      addressFieldName: '',
      photoURLFieldName: '',
    });
    final fetchedShelter = await document.get();
    return CloudShelterInfo(
      documentId: fetchedShelter.id,
      ownerUserId: ownerUserId,
      userName: userName,
      title: '',
      text: '',
      address: '',
      photoURL: '',
    );
  }

  // Map the shelters to a CloudShelterInfo object
  Future<Iterable<CloudShelterInfo>> getShelters({required String ownerUserId}) async {
    try {
      return await shelters.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .get().
      then(
        (value) => value.docs.map(
          (doc) => CloudShelterInfo.fromSnapshot(doc)),
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudShelterInfo>> allShelters() {
    final allShelters = shelters
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudShelterInfo.fromSnapshot(doc)));
    return allShelters;
  }

  Stream<Iterable<CloudShelterInfo>> allSheltersByUserID({required String ownerUserId}) {
    final allShelters = shelters
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudShelterInfo.fromSnapshot(doc)));
    return allShelters;
  }


  Future<void> updateShelter({
    required String documentId,
    String? title,
    String? address,
    String? photoURL,
    String? text,
  }) async {
    try {
      await shelters.doc(documentId).update({
        titleFieldName: title,
        addressFieldName: address,
        photoURLFieldName: photoURL,
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteShelter({required String documentId}) async {
    try {
      await shelters.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}