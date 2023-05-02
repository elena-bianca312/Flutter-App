import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:myproject/animation/heart.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/utilities/generics/get_arguments.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_exceptions.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';


class ShelterView extends StatefulWidget {
  const ShelterView({super.key});

  @override
  State<ShelterView> createState() => _ShelterViewState();
}

class _ShelterViewState extends State<ShelterView> {

  late CloudShelterInfo _shelter;
  var backupPhotoURL = 'assets/images/bloc1.jpg';
  late final FirebaseShelterStorage _sheltersService;

  @override
  void initState() {
    // _shelter = getExistingShelter(context) as CloudShelterInfo;
    _sheltersService = FirebaseShelterStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _sheltersService.getShelters(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData) {
                  final id = context.getArgument<CloudShelterInfo>()!.documentId;
                  print(id);
                  print(snapshot.data!.map((e) => e.documentId == id).toList());
                  _shelter = snapshot.data!.firstWhere((element) => element.documentId == id);
                  print(_shelter.documentId);

                  return Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: _shelter.photoURL == null || _shelter.photoURL == '' ? Image.asset(backupPhotoURL) : Image.network(_shelter.photoURL!)
                      ),
                      buttonArrow(context),
                      scroll(),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('No data found'),
                  );
                }

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        )
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
                    Text(_shelter.address, style: Theme.of(context).textTheme.bodyMedium,),
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Text(AuthService.firebase().currentUser!.id == _shelter.ownerUserId ? "Posted by you" : _shelter.userName),
                        const SizedBox(width: 30,),
                        const Heart(),
                        const SizedBox(width: 5,),
                        const Text("69 Likes",),
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