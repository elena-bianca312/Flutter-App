import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/earthquake_plan_cloud/firebase_earthquake_plan_storage.dart';

class SelectableItem {
  final String title;
  bool isSelected;

  SelectableItem(this.title, this.isSelected);
}

class SelectableItemsProvider extends ChangeNotifier {

  late List<SelectableItem> items;

  SelectableItemsProvider(List<bool> selectedItems) {
    assert(selectedItems.length == 4, 'Invalid number of selected items.');

    items = [
      SelectableItem('Hang heavy items, such as paintings and mirrors, away from beds, sofas, and other sitting areas', selectedItems[0]),
      SelectableItem('Secure overhead lighting fixtures', selectedItems[1]),
      SelectableItem('Install sturdy screws on cabinets', selectedItems[2]),
      SelectableItem('Ensure that heavy objects are closest to the floor', selectedItems[3])
    ];
  }

  Future<bool> toggleSelection(int index) async {
    items[index].isSelected = !items[index].isSelected;
    notifyListeners();
    return items[index].isSelected;
  }
}

class EarthquakePlanView extends StatefulWidget {

  const EarthquakePlanView({super.key});

  @override
  State<EarthquakePlanView> createState() => _EarthquakePlanViewState();
}

class _EarthquakePlanViewState extends State<EarthquakePlanView> {

  late final FirebaseEarthquakePlanStorage _earthquakePlanService;
  final currentUser = AuthService.firebase().currentUser!;
  late final userId = currentUser.id;

  @override
  void initState() {
    _earthquakePlanService = FirebaseEarthquakePlanStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Future.wait([
        _earthquakePlanService.createNewEarthquakePlan(ownerUserId: userId).then((value) => _earthquakePlanService.getSelectionList(ownerUserId: userId)),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
        return const SizedBox();
      } else {
        return ChangeNotifierProvider<SelectableItemsProvider>(
          create: (_) => SelectableItemsProvider(snapshot.data![0]),
          child: Stack (
            children: [
              const BackgroundImage(),
              Scaffold(
              backgroundColor: Colors.transparent.withOpacity(0.5),
              appBar: AppBar(
                title: const Text('Earthquake Plan'),
                backgroundColor: Colors.transparent,
              ),
              body: Consumer<SelectableItemsProvider>(
                builder: (_, provider, __) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            GlassBox(
                              height: 50,
                              width: 300,
                              addedOpacity: 0.3,
                              child: Text('Before Earthquake', style: labelPrimary,),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 310,
                              child: ListView.builder(
                                itemCount: provider.items.length,
                                itemBuilder: (context, index) {
                                  final item = provider.items[index];
                                  return Column(
                                    children: [
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 1.0,
                                      ),
                                      ListTile(
                                        leading: item.isSelected
                                            ? const Icon(
                                                Icons.check_box_rounded,
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.check_box_outline_blank,
                                                color: Colors.white,
                                              ),
                                        title: Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        tileColor: null,
                                        onTap: () async {
                                          bool isSelected = await provider.toggleSelection(index);
                                          if (isSelected) {
                                            await _earthquakePlanService.selectItem(
                                              ownerUserId: userId,
                                              itemIndex: index + 1,
                                            );
                                          }
                                          else {
                                            await _earthquakePlanService.deselectItem(
                                              ownerUserId: userId,
                                              itemIndex: index + 1,
                                            );
                                          }
                                        },
                                      ),
                                      if (index == provider.items.length - 1)
                                        const Divider(
                                          color: Colors.white,
                                          thickness: 1.0,
                                        ),
                                    ]
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 30),
                            GlassBox(
                              height: 50,
                              width: 300,
                              addedOpacity: 0.3,
                              child: Text('During Earthquake', style: labelPrimary,),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            GlassBox(
                              height: 50,
                              width: 240,
                              addedOpacity: 0.3,
                              child: Text('If you are inside', style: blacksubheader,),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: insideList.length,
                              itemBuilder: (context, index) {
                                final fixedItem = insideList[index];
                                return Column(
                                  children: [
                                    const Divider(
                                      color: Colors.white,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      leading: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        fixedItem,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (index == provider.items.length)
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 1.0,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            GlassBox(
                              height: 50,
                              width: 240,
                              addedOpacity: 0.3,
                              child: Text('If you are outside', style: blacksubheader,),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: outsideList.length,
                              itemBuilder: (context, index) {
                                final fixedItem = outsideList[index];
                                return Column(
                                  children: [
                                    const Divider(
                                      color: Colors.white,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      leading: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        fixedItem,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.white,
                                      thickness: 1.0,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            GlassBox(
                              height: 50,
                              width: 240,
                              addedOpacity: 0.3,
                              child: Text('If you are in a moivng vehicle', style: blacksubheader,),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: vehicleList.length,
                              itemBuilder: (context, index) {
                                final fixedItem = vehicleList[index];
                                return Column(
                                  children: [
                                    const Divider(
                                      color: Colors.white,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      leading: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        fixedItem,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (index == provider.items.length)
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 1.0,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            GlassBox(
                              height: 50,
                              width: 300,
                              addedOpacity: 0.3,
                              child: Text('After Earthquake', style: labelPrimary,),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: afterwardList.length,
                              itemBuilder: (context, index) {
                                final fixedItem = afterwardList[index];
                                return Column(
                                  children: [
                                    const Divider(
                                      color: Colors.white,
                                      thickness: 1.0,
                                    ),
                                    ListTile(
                                      leading: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        fixedItem,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    if (index == provider.items.length)
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 1.0,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 30),
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        );
      }
    });
  }
}

List<String> insideList = [
  'Get down to the floor and cover your head and neck with your hands. If possible, try to move under a sturdy table or desk.',
  'If you are in bed, stay in bed and cover your head and neck with a pillow.',
  'Stay away from windows, mirrors, and objects that can shatter or collapse.',
  'Remain indoors until the shaking stops.',
  'Remember that fire alarms and sprinklers can be triggered by an earthquake.',
];

List<String> outsideList = [
  'Find an open space, away from buildings, trees, streetlights, and power lines. Get down to the ground!'
];

List<String> vehicleList = [
  'Pull over to a safe location and stop. Avoid bridges, tunnels, buildings, and trees.',
  'Stay in the car with your seatbelt fastened until the shaking stops.',
  'If a power line falls on your car, stay inside until a professional can remove it.',
  'If you are in a tsunami risk zone, go to the nearest high ground or evacuation area.',
  'If you are in a mountainous area or near unstable cliffs, be cautious of landslides.'
];

List<String> afterwardList = [
  'If you are away from home, return only when authorities allow it.',
  'Be prepared for possible aftershocks. If you feel one, refer to the steps above.',
  'Stay away from damaged buildings or areas of your house that are in disrepair.',
  'Search for and extinguish small fires, as fire is the most common hazard after an earthquake.',
  'Check yourself for injuries and assist those around you.'
];