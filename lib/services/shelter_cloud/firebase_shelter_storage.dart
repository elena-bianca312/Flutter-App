import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_constants.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_exceptions.dart';

class FirebaseShelterStorage {

  // Factory constructor and singleton pattern
  FirebaseShelterStorage._sharedInstance();
  static final FirebaseShelterStorage _shared = FirebaseShelterStorage._sharedInstance();
  factory FirebaseShelterStorage() {
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
      userLikesFieldName: [],
      userDislikesFieldName: [],
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
      userLikes: const [],
      userDislikes: const [],
    );
  }

  // Map the shelters to a CloudShelterInfo object
  Future<Iterable<CloudShelterInfo>> getSheltersByUserID({required String ownerUserId}) async {
    try {
      return await shelters.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .get().
      then(
        (value) => value.docs.map(
          (doc) => CloudShelterInfo.fromSnapshot(doc)),
      );
    } catch (e) {
      throw CouldNotGetAllSheltersException();
    }
  }

  // Map the shelters to a CloudShelterInfo object
  Future<Iterable<CloudShelterInfo>> getShelters() async {
    try {
      return await shelters
      .get().
      then(
        (value) => value.docs.map(
          (doc) => CloudShelterInfo.fromSnapshot(doc)),
      );
    } catch (e) {
      throw CouldNotGetAllSheltersException();
    }
  }

  Future<CloudShelterInfo> getShelterByDocumentID({required String documentId}) {

    var x = shelters.get().then((value) => value.docs.map((doc) => CloudShelterInfo.fromSnapshot(doc)).firstWhere((element) => element.documentId == documentId));
    // print(x.documentId);
    return x;
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
      throw CouldNotUpdateShelterException();
    }
  }

  Future<void> deleteShelter({required String documentId}) async {
    try {
      await shelters.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteShelterException();
    }
  }

  Future<void> likeShelter({required String documentId, required String userId}) async {
    try {
      await shelters.doc(documentId).update({
        userLikesFieldName: FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw CouldNotLikeShelterException();
    }
  }

  Future<void> removeLikeShelter({required String documentId, required String userId}) async {
    try {
      await shelters.doc(documentId).update({
        userLikesFieldName: FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw CouldNotLikeShelterException();
    }
  }

  Future<void> dislikeShelter({required String documentId, required String userId}) async {
    try {
      await shelters.doc(documentId).update({
        userDislikesFieldName: FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      throw CouldNotDislikeShelterException();
    }
  }

  Future<void> removeDislikeShelter({required String documentId, required String userId}) async {
    try {
      await shelters.doc(documentId).update({
        userDislikesFieldName: FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      throw CouldNotDislikeShelterException();
    }
  }

  Future<List> getShelterLikes({required String documentId}) async {
    try {
      return await shelters.doc(documentId).get().then((value) => value.get(userLikesFieldName));
    } catch (e) {
      throw CouldNotGetShelterLikesException();
    }
  }

    Future<List> getShelterDislikes({required String documentId}) async {
    try {
      return await shelters.doc(documentId).get().then((value) => value.get(userDislikesFieldName));
    } catch (e) {
      throw CouldNotGetShelterLikesException();
    }
  }
}