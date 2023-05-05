import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/text_input.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/views/shelters/shelter_view.dart';
import 'package:myproject/views/shelters/shelter_tile.dart';
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

    return LiquidPullToRefresh(
       color: Colors.transparent,
        height: 80,
        backgroundColor: Colors.white,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        child: Column(
          children: [
            const TextInput(
              icon: Icons.search,
              hint: "Search",
              inputAction: TextInputAction.search,
              width: 330,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: buttonPrimary,
              onPressed: () {
                Navigator.of(context).pushNamed(makeDonationRoute);
              },
              child: Text(
                'Make a donation',
                style: labelPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: shelters.length,
                itemBuilder: (context, index) {
                  final shelter = shelters.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Card(
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.arrow_drop_down_circle, color: yellow,),
                            title: Text(shelter.title, style: header),
                            subtitle: Text(
                              "Address: ${shelter.address}",
                              style: subheader,
                            ),
                          ),
                          shelter.text == null || shelter.text == "" ?
                            const SizedBox() :
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  shelter.text!,
                                  style: p,
                                ),
                              ),
                            ),
                          ButtonBar(
                            alignment: MainAxisAlignment.start,
                            children: [
                              TextButton(
                                child: Text('View', style: price,),
                                onPressed: () {
                                  onTap(shelter);
                                },
                              ),
                              AuthService.firebase().currentUser!.id == shelter.ownerUserId ?
                                IconButton(
                                  icon: Icon(Icons.delete, color: yellow,),
                                  onPressed: () async {
                                    final shouldDelete = await showDeleteDialog(context);
                                    if (shouldDelete) {
                                      onDeleteShelter(shelter);
                                    }
                                  },
                                ) :
                                const SizedBox(),
                            ],
                          ),
                          // ClipRRect(
                          //   borderRadius: const BorderRadius.only(
                          //     bottomLeft: Radius.circular(20.0),
                          //     bottomRight: Radius.circular(20.0)),
                          //   child: shelter.photoURL == null || shelter.photoURL == '' ? Image.asset(backupPhotoURL, fit: BoxFit.cover) : Image.network(shelter.photoURL!,)
                          // ),

                          // Container(
                          //   height: 100.0,
                          //   width: 70.0,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.only(
                          //       bottomLeft: Radius.circular(5),
                          //       topLeft: Radius.circular(5)
                          //     ),
                          //     image: DecorationImage(
                          //       fit: BoxFit.cover,
                          //       image: NetworkImage("https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png")
                          //     )
                          //   ),
                          // ),

                        ],
                      ),
                    ),
                  );

                // return  Card(
                //   child: Container(
                //     color: Colors.black,
                //     height: 100.0,
                //     child: Row(
                //       children: <Widget>[
                //         Container(
                //           height: 100.0,
                //           width: 70.0,
                //           decoration: BoxDecoration(
                //             borderRadius: const BorderRadius.only(
                //               bottomLeft: Radius.circular(5),
                //               topLeft: Radius.circular(5)
                //             ),
                //             image: DecorationImage(
                //               fit: BoxFit.cover,
                //               image: shelter.photoURL == null || shelter.photoURL == '' ?
                //                 AssetImage(backupPhotoURL) as ImageProvider :
                //                 NetworkImage(shelter.photoURL!,),
                //             )
                //           ),
                //         ),
                //         SizedBox(
                //           height: 100,
                //           child: Padding(
                //             padding: const EdgeInsets.fromLTRB(10, 2, 0, 0),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: <Widget>[
                //                 Text(shelter.title, style: header),
                //                 const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                //                 Text("Address", textAlign: TextAlign.center, style: subheader),
                //                 Padding(
                //                   padding: const EdgeInsets.fromLTRB(0, 5, 0, 2),
                //                     child: SizedBox(
                //                     width: 260,
                //                     child: shelter.text == null || shelter.text == "" ?
                //                       const SizedBox() :
                //                       Text(
                //                         shelter.text!,
                //                         style: p,
                //                       ),
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // );
                }
              ),
            ),
          ],
        ),
      );
  }
}