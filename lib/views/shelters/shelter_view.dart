import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myproject/animation/heart.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/utilities/generics/get_arguments.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_exceptions.dart';
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
    required this.onRemoveDislike
  });

  @override
  State<ShelterView> createState() => _ShelterViewState();
}

class _ShelterViewState extends State<ShelterView> {

  late CloudShelterInfo _shelter = widget.shelter;
  late final FirebaseShelterStorage _sheltersService;
  int numberOfLikes = 0;

  @override
  void initState() {
    // _shelter = getExistingShelter(context) as CloudShelterInfo;
    _sheltersService = FirebaseShelterStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
  }

  Future<CloudShelterInfo> getExistingShelter(BuildContext context) async {
    try {
      final id = context.getArgument<CloudShelterInfo>()!.documentId;
      final currentShelter = await _sheltersService.getShelterByDocumentID(documentId: id);
      // final currentShelter = context.getArgument<CloudShelterInfo>()!;
      _shelter = currentShelter;
      return currentShelter;
    } catch (e) {
      throw CouldNotGetCurrentShelterException();
    }
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

  Future<void> likeAnimation() async {
    IconButton(
      onPressed: () async {
        await _sheltersService.likeShelter(documentId: _shelter.documentId, userId: AuthService.firebase().currentUser!.id);
      },
      icon: const Icon(Icons.person_outline),
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
                    const SizedBox(width: 30,),
                    Row(
                      children: [
                        Heart(onLike: widget.onLike, onDislike: widget.onDislike, onRemoveLike: widget.onRemoveLike, onRemoveDislike: widget.onRemoveDislike),
                        FutureBuilder(
                          future: _sheltersService.getShelterLikes(documentId: _shelter.documentId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.length == 1) {
                                return const Text("1 Like");
                              }
                              return Text("${snapshot.data!.length} Likes");
                            } else {
                              return const Text("0 Likes");
                            }
                          }
                        ),
                      ],
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