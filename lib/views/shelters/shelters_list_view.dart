import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/donation_page.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/shelter_view.dart';
import 'package:myproject/utilities/dialogs/delete_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';

typedef ShelterCallback = void Function(CloudShelterInfo shelter);
typedef ViewShelterCallback = ShelterView Function(CloudShelterInfo shelter);

class SheltersListView extends StatelessWidget {

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

  Future<void> _handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh (
      color: Colors.transparent,
        height: 80,
        backgroundColor: Colors.white,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
      child: Column(
        children: [
          myAnimatedButton(
            () => Navigator.of(context).pushNamed(makeDonationRoute),
            false,
            "Make a donation",
            null
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: shelters.length,
            itemBuilder: (context, index) {
              final shelter = shelters.elementAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GlassBox(
                  height: 200,
                  width: 100,
                  child: ListTile(
                    onTap: () => onTap(shelter),
                    title: Text(shelter.title, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
                    subtitle: Text("Address: ${shelter.address}", maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
                    leading:  SizedBox(
                      height: 100,
                      width: 100, // fixed width and height
                      child: shelter.photoURL == null || shelter.photoURL == '' ? Image.asset(backupPhotoURL) : Image.network(shelter.photoURL!)
                    ),
                    trailing: AuthService.firebase().currentUser!.id == shelter.ownerUserId?
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final shouldDelete = await showDeleteDialog(context);
                            if (shouldDelete) {
                              onDeleteShelter(shelter);
                            }
                          },
                          color: yellow,
                          // surround icon with border
                        ),
                      ) : null,
                  ),
                  // child: Container(
                  //   margin: EdgeInsets.all(10),
                  //   width: 210,
                  //   child: Stack(
                  //     alignment: Alignment.topCenter,
                  //     children: <Widget>[
                  //       Positioned(
                  //         bottom: 15,
                  //         child: Container(
                  //           height: 120,
                  //           width: 200,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             color: Colors.white,
                  //           ),
                  //           child: Padding(
                  //             padding: EdgeInsets.all(10),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: <Widget>[
                  //                 Text(shelter.title, style: Theme.of(context).textTheme.bodyMedium,),
                  //                 Text(shelter.address, style: Theme.of(context).textTheme.bodyMedium,),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(20),
                  //           boxShadow: const [
                  //             BoxShadow(
                  //               color: Colors.black26,
                  //               offset: Offset(0.0, 2.0),
                  //               blurRadius: 6.0
                  //             )
                  //           ],
                  //         ),
                  //         child: Stack(
                  //           children: <Widget>[
                  //             ClipRRect(
                  //               borderRadius: BorderRadius.circular(20),
                  //               child: Image(
                  //                 height: 180,
                  //                 width: 180,
                  //                 image: AssetImage(backupPhotoURL),
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //             Positioned(
                  //               left: 10,
                  //               bottom: 10,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: <Widget>[
                  //                   Text(shelter.title, style: Theme.of(context).textTheme.bodyMedium,),
                  //                   Row(
                  //                     children: <Widget>[
                  //                       Icon(Icons.location_on, size: 10, color: Colors.white,),
                  //                       SizedBox(width: 5,),
                  //                       Text(shelter.address, style: Theme.of(context).textTheme.bodyMedium,),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   )
                  // ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}