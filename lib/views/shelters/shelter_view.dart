import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/animation/like_dislike_animation.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';

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
          return Scaffold(
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
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5,
                            width: 35,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _shelter.title,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        if (AuthService.firebase().currentUser!.id == _shelter.ownerUserId)
                          IconButton(
                            onPressed: () async {
                              setState(() {_sheltersService.getShelters();});
                              Navigator.of(context).pushNamed(addShelterRoute, arguments: _shelter);

                              // TOOD: It doesnt update the shelter info after editing!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                              // Why????????????????????????
                            },
                            icon: const Icon(Icons.edit, color: Colors.grey,),
                          )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text("Address: ${_shelter.address}", style: Theme.of(context).textTheme.bodyMedium,),
                    const SizedBox(height: 15,),
                    Text(AuthService.firebase().currentUser!.id == _shelter.ownerUserId ? "Posted by you" : "Posted by ${_shelter.userName}"),

                    // Display ike and dislike
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
                                  (noLikes == 1) ? const Text("1 Like") : Text("${noLikes.toString()} Likes"),
                                  const SizedBox(width: 25,),
                                  (noDislikes == 1) ? const Text("1 Dislike") : Text("${noDislikes.toString()} Dislikes"),
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
                        height: 4,
                      ),
                    ),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (_shelter.text != null && _shelter.text != '') Text(_shelter.text!),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(
                        height: 4,
                      ),
                    ),
                    Text(
                      "Available Items",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // ListView.builder(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: 3,
                    //   itemBuilder: (context, index) => ingredients(context),
                    // ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(
                        height: 4,
                      ),
                    ),
                    Text(
                      "Google Maps",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // ListView.builder(
                    //   physics: NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: 3,
                    //   itemBuilder: (context, index) => steps(context, index),
                    // ),
                  ],
                ),
              ),
            );
        });
      }
}