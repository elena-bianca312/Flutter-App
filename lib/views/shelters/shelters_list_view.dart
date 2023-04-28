import 'package:flutter/material.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/utilities/dialogs/delete_dialog.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';

typedef ShelterCallback = void Function(CloudShelterInfo shelter);

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
      child: ListView.builder(
        itemCount: shelters.length,
        itemBuilder: (context, index) {
          final shelter = shelters.elementAt(index);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GlassBox(
              height: 50,
              width: 50,
              child: ListTile(
                onTap: () => onTap(shelter),
                title: Text(shelter.title, maxLines: 1, softWrap: true, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteShelter(shelter);
                    }
                  },
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}