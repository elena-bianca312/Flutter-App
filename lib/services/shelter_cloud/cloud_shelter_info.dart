import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_constants.dart';

class Review {
  String userId;
  String email;
  int rating;
  String review;
  DateTime date;

  Review({
    required this.userId,
    required this.email,
    required this.rating,
    required this.review,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'rating': rating,
      'review': review,
      'date': date.toUtc().toIso8601String(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      email: json['email'],
      rating: json['rating'],
      review: json['review'],
      date: DateTime.parse(json['date']),
    );
  }
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
  Map<String, int>? donations;

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
    this.donations,
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
    reviews = snapshot.data()[reviewsFieldName].cast<Review>(),
    freeBeds = snapshot.data()[freeBedsFieldName],
    donations = snapshot.data()[donationsFieldName];
}