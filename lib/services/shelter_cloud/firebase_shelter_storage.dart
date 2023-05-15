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
      reviewsFieldName: [],
      freeBedsFieldName: 0,
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
      reviews: const [],
      freeBeds: 0,
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

  Future<bool> checkIfLiked({required String documentId, required String userId}) async {
    try {
      return await shelters.doc(documentId).get().then((value) => value.get(userLikesFieldName).contains(userId));
    } catch (e) {
      throw CouldNotCheckIfLikedException();
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

  Future<bool> checkIfDisliked({required String documentId, required String userId}) async {
    try {
      return await shelters.doc(documentId).get().then((value) => value.get(userDislikesFieldName).contains(userId));
    } catch (e) {
      throw CouldNotCheckIfDislikedException();
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

  Future<void> addReview({required String documentId, required Review review}) async {
    try {
      await shelters.doc(documentId).update({
        reviewsFieldName: FieldValue.arrayUnion([review.toJson()]),
      });
    } catch (e) {
      throw CouldNotAddReviewException();
    }
  }

  Future<void> updateReview({
    required String documentId,
    required Review oldReview,
    required Review updatedReview,
  }) async {
    try {
      await shelters.doc(documentId).update({
        reviewsFieldName: FieldValue.arrayUnion([updatedReview.toJson()]),
      });
      await shelters.doc(documentId).update({
        reviewsFieldName: FieldValue.arrayRemove([oldReview.toJson()]),
      });
    } catch (e) {
      throw CouldNotUpdateReviewException();
    }
  }


  Future<List<Review>> getReviews({required String documentId}) async {
    try {
      final snapshot = await shelters.doc(documentId).get();
      final reviewData = snapshot.get(reviewsFieldName) as List<dynamic>;
      final reviews = reviewData.map((json) => Review.fromJson(json as Map<String, dynamic>)).toList();
      return reviews;
    } catch (e) {
      throw CouldNotGetReviewsException();
    }
  }

  Future<void> deleteReview({required String documentId, required Review review}) async {
    try {
      await shelters.doc(documentId).update({
        reviewsFieldName: FieldValue.arrayRemove([review.toJson()]),
      });
    } catch (e) {
      throw CouldNotDeleteReviewException();
    }
  }

  Future<Review> getUserReview({required String documentId, required String userId}) async {
    try {
      final snapshot = await shelters.doc(documentId).get();
      final reviewData = snapshot.get(reviewsFieldName) as List<dynamic>;
      final reviews = reviewData.map((json) => Review.fromJson(json as Map<String, dynamic>)).toList();
      return reviews.firstWhere((review) => review.userId == userId);
    } catch (e) {
      throw CouldNotGetUserReviewsException();
    }
  }

  Future<bool> didUserSubmitReview({required String documentId, required String userId}) async {
    try {
      final snapshot = await shelters.doc(documentId).get();
      final reviewData = snapshot.get(reviewsFieldName) as List<dynamic>;
      final reviews = reviewData.map((json) => Review.fromJson(json as Map<String, dynamic>)).toList();
      return reviews.any((review) => review.userId == userId);
    } catch (e) {
      throw CouldNotCheckIfUserSubmittedReviewException();
    }
  }

  // Future<void> addFreeBed({required String documentId}) async {
  //   try {
  //     await shelters.doc(documentId).update({
  //       freeBedsFieldName: FieldValue.increment(1),
  //     });
  //   } catch (e) {
  //     throw CouldNotAddFreeBedException();
  //   }
  // }
}
