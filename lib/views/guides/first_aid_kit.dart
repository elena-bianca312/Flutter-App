import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/guide_cloud/firebase_guide_storage.dart';

class SelectableItem {
  final String title;
  bool isSelected;

  SelectableItem(this.title, this.isSelected);
}

class SelectableItemsProvider extends ChangeNotifier {

  late List<SelectableItem> items;

  SelectableItemsProvider(List<bool> selectedItems) {
    assert(selectedItems.length == 13, 'Invalid number of selected items.');

    items = [
      SelectableItem('Water (for at least 3 days)', selectedItems[0]),
      SelectableItem('Non-perishable food (for at least 3 days)', selectedItems[1]),
      SelectableItem('Flashlight', selectedItems[2]),
      SelectableItem('Radio', selectedItems[3]),
      SelectableItem('Batteries', selectedItems[4]),
      SelectableItem('Medications (for at least 7 days)', selectedItems[5]),
      SelectableItem('First aid kit', selectedItems[6]),
      SelectableItem('Personal hygiene items', selectedItems[7]),
      SelectableItem('Copies of important personal documents', selectedItems[8]),
      SelectableItem('Mobile phone with chargers', selectedItems[9]),
      SelectableItem('Extra cash', selectedItems[10]),
      SelectableItem('Emergency blanket', selectedItems[11]),
      SelectableItem('Map of the area', selectedItems[12]),
    ];
  }

  Future<bool> toggleSelection(int index) async {
    items[index].isSelected = !items[index].isSelected;
    notifyListeners();
    return items[index].isSelected;
  }
}


class FirstAidKitView extends StatefulWidget {
  const FirstAidKitView({super.key});

  @override
  State<FirstAidKitView> createState() => _FirstAidKitViewState();
}

class _FirstAidKitViewState extends State<FirstAidKitView> {

  late final FirebaseGuideStorage _guideService;
  final currentUser = AuthService.firebase().currentUser!;
  late final userId = currentUser.id;

  @override
  void initState() {
    _guideService = FirebaseGuideStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Future.wait([
        _guideService.createNewGuide(ownerUserId: userId).then((value) => _guideService.getSelectionList(ownerUserId: userId)),
        // _guideService.getSelectionList(ownerUserId: userId)
      ]),
      builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const SizedBox();
      } else {
      return ChangeNotifierProvider<SelectableItemsProvider> (
        create: (_) => SelectableItemsProvider(snapshot.data![0]),
        child: Stack(
          children: [
            const BackgroundImage(),
            Scaffold(
              backgroundColor: Colors.transparent.withOpacity(0.5),
              appBar: AppBar(
                title: const Text('First Aid Kit'),
                backgroundColor: Colors.transparent,
              ),
              body: Consumer<SelectableItemsProvider>(
                builder: (_, provider, __) {
                  return ListView.builder(
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final item = provider.items[index];
                      return ListTile(
                        leading: item.isSelected ?
                          const Icon(Icons.check_box_rounded, color: Colors.white,) :
                          const Icon(Icons.check_box_outline_blank, color: Colors.white,),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                        tileColor: null,
                        onTap: () async {
                          bool isSelected = await provider.toggleSelection(index);
                          if (isSelected) {
                            await _guideService.selectItem(
                              ownerUserId: userId,
                              itemIndex: index + 1,
                            );
                          }
                          else {
                            await _guideService.deselectItem(
                              ownerUserId: userId,
                              itemIndex: index + 1,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ]
        ),
      );
      }
    });
  }
}