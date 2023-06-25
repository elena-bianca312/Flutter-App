import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/views/pages/donation_page.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/features/chat/chat_page.dart';
import 'package:myproject/views/shelters/features/reviews/reviews.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/views/shelters/features/reviews/review_list.dart';
import 'package:myproject/views/shelters/features/donations/add_item_list.dart';
import 'package:myproject/views/shelters/features/google_maps/google_maps.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';
import 'package:myproject/views/shelters/features/like_dislike/like_dislike_animation.dart';

typedef LikeCallback = void Function();

class ShelterView extends StatefulWidget {

  final LikeCallback onLike;
  final LikeCallback onDislike;
  final LikeCallback onRemoveLike;
  final LikeCallback onRemoveDislike;
  final CloudShelterInfo shelter;
  const ShelterView({
    super.key,
    required this.shelter,
    required this.onLike,
    required this.onDislike,
    required this.onRemoveLike,
    required this.onRemoveDislike,
  });

  @override
  State<ShelterView> createState() => _ShelterViewState();
}

class _ShelterViewState extends State<ShelterView> {

  late CloudShelterInfo _shelter = widget.shelter;
  late final FirebaseShelterStorage _sheltersService;
  late dynamic shelters;

  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _sheltersService.allShelters(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _shelter = snapshot.data!.firstWhere((element) => element.documentId == _shelter.documentId);
          shelters = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.9),
            body:
              Stack(children: [
                  SizedBox(
                    width: double.infinity,
                    child: _shelter.photoURL == null || _shelter.photoURL == '' ? Image.asset(backupPhotoURL) : Image.network(_shelter.photoURL!)
                  ),
                  buttonArrow(context),
                  scroll(),
                ],
              )
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 1.0,
          minChildSize: 0.2,
          builder: (context, scrollController) {
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.95),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 5,
                              width: 35,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _shelter.title,
                            style: superheader,
                          ),
                          const Expanded(child: SizedBox()),
                          if (AuthService.firebase().currentUser!.id == _shelter.ownerUserId)
                            IconButton(
                              onPressed: () async {
                                setState(() {_sheltersService.getShelters();});
                                Navigator.of(context).pushNamed(addShelterRoute, arguments: _shelter);
                              },
                              icon: const Icon(Icons.edit, color: Colors.white24,),
                            )
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Text(AuthService.firebase().currentUser!.id == _shelter.ownerUserId ?
                        "Posted by you" : "Posted by ${_shelter.userName}",
                        style: small,
                      ),
                      const SizedBox(height: 15,),
                      // Display like and dislike
                      FutureBuilder(
                        future: Future.wait([
                          _sheltersService.checkIfLiked(documentId: _shelter.documentId, userId: AuthService.firebase().currentUser!.id),
                          _sheltersService.checkIfDisliked(documentId: _shelter.documentId, userId: AuthService.firebase().currentUser!.id),
                          _sheltersService.getShelterLikes(documentId: _shelter.documentId),
                          _sheltersService.getShelterDislikes(documentId: _shelter.documentId)
                        ]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            int noLikes = (snapshot.data![2] as List).length;
                            int noDislikes = (snapshot.data![3] as List).length;
                            return Column(
                              children: [
                                LikeDislikeAnimation(
                                  onLike: widget.onLike,
                                  onDislike: widget.onDislike,
                                  onRemoveLike: widget.onRemoveLike,
                                  onRemoveDislike: widget.onRemoveDislike,
                                  checkIfLiked: snapshot.data![0] as bool,
                                  checkIfDisliked: snapshot.data![1] as bool,
                                ),
                                Row(
                                  children: [
                                    (noLikes == 1) ?
                                      Text("1 Like", style: p,) :
                                      Text("${noLikes.toString()} Likes", style: p),
                                    const SizedBox(width: 25,),
                                    (noDislikes == 1) ?
                                      Text("1 Dislike", style: p,) :
                                      Text("${noDislikes.toString()} Dislikes", style: p),
                                  ],
                                ),
                              ],
                            );
                          }
                        }
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: Colors.white24,
                          height: 4,
                        ),
                      ),
                      Text(
                        "Description",
                        style: superheader,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (_shelter.text != null && _shelter.text != '') Text(_shelter.text!, style: p,),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: Colors.white24,
                          height: 4,
                        ),
                      ),
                      Text(
                        "Google Maps",
                        style: superheader,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text("Address: ${_shelter.address}", style: p,),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => MapPage(shelter: _shelter, shelterNumber: shelters.length)
                          ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(googleMapsPhoto)
                        )
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: Colors.white24,
                          height: 4,
                        ),
                      ),
                      Text(
                        "Donations",
                        style: superheader,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const DonationPage()
                          ));
                        },
                        child: const Text(
                          'Offer Financial Support',
                          style: TextStyle(color: kCustomBlue, fontSize: 20, decoration: TextDecoration.underline),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const AddItemPage()
                          ));
                        },
                        child: const Text(
                          'Donate Items',
                          style: TextStyle(color: kCustomBlue, fontSize: 20, decoration: TextDecoration.underline),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: Colors.white24,
                          height: 4,
                        ),
                      ),
                      Text(
                        "Reviews",
                        style: superheader,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: Future.wait([
                          _sheltersService.didUserSubmitReview(documentId: _shelter.documentId, userId: AuthService.firebase().currentUser!.id)
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data![0] == true) {
                            return FutureBuilder(
                              future: Future.wait([
                                _sheltersService.didUserSubmitReview(documentId: _shelter.documentId, userId: AuthService.firebase().currentUser!.id),
                                _sheltersService.getUserReview(documentId: _shelter.documentId, userId: AuthService.firebase().currentUser!.id),
                              ]),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data![0] == true) {
                                  Review review = snapshot.data![1] as Review;
                                  return Column(
                                    children: [
                                      Text(
                                        "You have already submitted a review",
                                        style: p,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ReviewStars(shelter: _shelter, oldReview: review,),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              }
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Add a review",
                                  style: p,
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ReviewStars(shelter: _shelter,),
                              ],
                            );
                          }
                        }
                      ),
                      // ReviewStars(shelter: _shelter,),
                      const SizedBox(
                        height: 10,
                      ),
                      FutureBuilder(
                        future: Future.wait([_sheltersService.getReviews(documentId: _shelter.documentId)]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            if ((snapshot.data![0]).isEmpty) {
                              return const SizedBox();
                            }
                            List<Review> reviews = (snapshot.data![0]);
                            return ReviewList(shelter: _shelter, reviews: reviews);
                          }
                        }
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(
                          color: Colors.white24,
                          height: 4,
                        ),
                      ),
                      (AuthService.firebase().currentUser!.id != _shelter.ownerUserId) ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact",
                            style: superheader,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => ChatPage(recipientId: _shelter.ownerUserId)
                              ));
                            },
                            child: const Text(
                              'Leave us a message',
                              style: TextStyle(color: kCustomBlue, fontSize: 20, decoration: TextDecoration.underline),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Divider(
                              color: Colors.white24,
                              height: 4,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ) : const SizedBox(),
                    ],
                  ),
                ),
              );
          }),
        );
      }
}