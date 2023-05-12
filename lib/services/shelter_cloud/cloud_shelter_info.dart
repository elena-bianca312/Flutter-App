import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_constants.dart';

class Review {
  String userId;
  int rating;
  String review;

  Review({
    required this.userId,
    required this.rating,
    required this.review
  });
}

class CloudShelterInfo {
  final String documentId;
  final String ownerUserId;
  final String userName;
  final String title;
  final String address;
  final String? photoURL;
  final String? text;
  List<String>? userLikes;
  List<String>? userDislikes;
  List<Review>? reviews;
  int? freeBeds;

  CloudShelterInfo({
    required this.documentId,
    required this.ownerUserId,
    required this.userName,
    required this.title,
    required this.address,
    this.photoURL,
    this.text,
    this.userLikes,
    this.userDislikes,
    this.reviews,
    this.freeBeds,
  });

  CloudShelterInfo.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    documentId = snapshot.id,
    ownerUserId = snapshot.data()[ownerUserIdFieldName],
    userName = snapshot.data()[userNameFieldName],
    title = snapshot.data()[titleFieldName] as String,
    address = snapshot.data()[addressFieldName] as String,
    photoURL = snapshot.data()[photoURLFieldName],
    text = snapshot.data()[textFieldName],
    userLikes = snapshot.data()[userLikesFieldName].cast<String>(),
    userDislikes = snapshot.data()[userDislikesFieldName].cast<String>(),
    reviews = snapshot.data()[reviewsFieldName],
    freeBeds = snapshot.data()[freeBedsFieldName];
}