import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/shelter_view.dart';
import 'package:myproject/utilities/dialogs/delete_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';

typedef ShelterCallback = void Function(CloudShelterInfo shelter);
typedef ViewShelterCallback = ShelterView Function(CloudShelterInfo shelter);

// ignore: must_be_immutable
class SheltersListView extends StatefulWidget {

  final Iterable<CloudShelterInfo> shelters;
  // I can only delete it if it was posted by the current user
  final ShelterCallback onDeleteShelter;
  final ShelterCallback onTap;

  const SheltersListView({
    Key? key,
    required this.shelters,
    required this.onDeleteShelter,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SheltersListView> createState() => _SheltersListViewState();
}

class _SheltersListViewState extends State<SheltersListView> {
  Iterable<CloudShelterInfo> results = [];
  String enteredKeyword = '';

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    results = widget.shelters;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return LiquidPullToRefresh(
       color: Colors.transparent,
        height: 80,
        backgroundColor: Colors.white,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600]?.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  style: subheader,
                  onChanged: (value) {
                    setState(() {
                      enteredKeyword = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: subheader,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      suffixIcon: const Icon(Icons.search, color: Colors.white,),
                    ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(usefulInformationRoute);
              },
              child: const Text(
                'Useful Information',
                style: TextStyle(color: Colors.white, fontSize: 20, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: widget.shelters.where((shelter) =>
                          (shelter.title.toLowerCase().contains(enteredKeyword.toLowerCase())) || shelter.address.toLowerCase().contains(enteredKeyword.toLowerCase()))
                          .toList()
                          .length,
                itemBuilder: (context, index) {
                final shelter = widget.shelters.where((shelter) =>
                                (shelter.title.toLowerCase().contains(enteredKeyword.toLowerCase())) || shelter.address.toLowerCase().contains(enteredKeyword.toLowerCase()))
                                .toList()
                                .elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: shelter.photoURL == null || shelter.photoURL == '' ?
                                AssetImage(backupPhotoURL) as ImageProvider :
                                NetworkImage(shelter.photoURL!,),
                            colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            GlassBox(
                              height: 80,
                              width: 400,
                              addedOpacity: 0.35,
                              child: ListTile(
                                leading: Icon(Icons.arrow_drop_down_circle, color: black,),
                                title: Text(shelter.title, style: blackheader),
                                subtitle: Text(
                                  "Address: ${shelter.address}",
                                ),
                              ),
                            ),
                            const SizedBox(height: 160),
                            ButtonBar(
                              alignment: MainAxisAlignment.start,
                              buttonAlignedDropdown: true,
                              children: [
                                GlassBox(
                                  height: 40,
                                  width: 90,
                                  addedOpacity: 0.6,
                                  child: TextButton(
                                    child: Text('View', style: labelPrimary,),
                                    onPressed: () {
                                      widget.onTap(shelter);
                                    },
                                  ),
                                ),
                                AuthService.firebase().currentUser!.id == shelter.ownerUserId ?
                                  GlassBox(
                                    height: 40,
                                    width: 50,
                                    addedOpacity: 0.6,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.black,),
                                      onPressed: () async {
                                        final shouldDelete = await showDeleteDialog(context);
                                        if (shouldDelete) {
                                          widget.onDeleteShelter(shelter);
                                        }
                                      },
                                    ),
                                  ) :
                                  const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      );
  }
}