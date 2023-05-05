import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/utilities/utils.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/utilities/dialogs/delete_dialog.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';

// Momentarily, this does nothing

typedef ShelterCallback = void Function(CloudShelterInfo shelter);

class ShelterTile extends StatefulWidget {

  final CloudShelterInfo shelter;
  final ShelterCallback onTap;
  final ShelterCallback onDeleteShelter;

  const ShelterTile({super.key, required this.shelter, required this.onTap, required this.onDeleteShelter});

  @override
  State<ShelterTile> createState() => _ShelterTileState();
}

class _ShelterTileState extends State<ShelterTile> {

  late CloudShelterInfo shelter = widget.shelter;

  @override
  Widget build(BuildContext context) {

    return Container(
                    width: 100,
                    child: Align(
                      child: Container(
                          alignment: Alignment.bottomLeft,
                          height: 120.0,
                          width: 100.0,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/ui/dogs.jpg"),
                              fit: BoxFit.cover,
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("title", style: header),
                              ]
                            ),
                          ),
                      ),
                    ),
                  );
  }
}