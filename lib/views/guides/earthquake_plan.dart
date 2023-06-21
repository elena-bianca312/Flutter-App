import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/background_image.dart';

class SelectableItem {
  final String title;
  bool isSelected;

  SelectableItem(this.title, this.isSelected);
}

class SelectableItemsProvider extends ChangeNotifier {
  List<SelectableItem> items = [
    SelectableItem('Agățați articole grele, cum ar fi tablouri și oglinzi, departe de paturi, canapele și alte locuri în care se stă', false),
    SelectableItem('Fixați corpurile de iluminat aeriene', false),
    SelectableItem('Instalați șuruburi rezistente pe dulapuri', false),
    SelectableItem('Asigurați-vă ca obiectele grele sunt cele mai apropiate de podea', false),
  ];

  void toggleSelection(int index) {
    items[index].isSelected = !items[index].isSelected;
    notifyListeners();
  }
}

class EarthquakePlanView extends StatelessWidget {

  const EarthquakePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectableItemsProvider>(
      create: (_) => SelectableItemsProvider(),
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
                          child: Text('Înainte de cutremur', style: labelPrimary,),
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
                                    onTap: () {
                                      provider.toggleSelection(index);
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
                          child: Text('În timpul cutremurului', style: labelPrimary,),
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
                          child: Text('Dacă vă aflați în interior', style: blacksubheader,),
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
                          child: Text('Dacă vă aflați afară', style: blacksubheader,),
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
                          child: Text('Dacă vă aflați într-o mașină', style: blacksubheader,),
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
                          child: Text('După cutremur', style: labelPrimary,),
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
}

List<String> insideList = [
  'Lăsați-vă la podea și acoperiți-vă capul și gâtul cu mâinile. Dacă este posibil, încercați să vă deplasați sub o masă sau un birou rezistent.',
  'Dacă sunteti în pat, rămâneți în pat și acoperiți-vă capul și gâtul cu o pernă.',
  'Stați departe de ferestre, oglinzi și obiecte care se pot sparge sau prăbuși.',
  'Rămâneți în interior până când se oprește mișcarea.',
  'Nu uitați că alarmele de incendiu și sprinklerele pot fi declanșate de un cutremur.',
];

List<String> outsideList = [
  'Găsiți un spațiu deschis, departe de clădiri, copaci, stâlpi de iluminat și fire electrice. Lăsați-vă la pămant!',
];

List<String> vehicleList = [
  'Trageți pe dreapta într-un loc liber și opriți-vă. Evitați podurile, pasajele subterane, clădirile și copacii.',
  'Rămâneți în mașină cu centura de siguranță fixată până când se oprește mișcarea.',
  'Dacă o linie de electricitate cade pe mașină, stați înăuntru până când un profesionist o poate îndepărta.',
  'Dacă sunteți într-o zonă cu risc de tsunami, mergeți la cel mai apropiat loc înalt sau la o zonă de evacuare.',
  'Dacă vă aflați într-o zonă muntoasă sau în apropierea stâncilor instabile, fiți atenți la alunecările de teren.',
];

List<String> afterwardList = [
  'Dacă sunteți plecat de acasă, întorceți-vă doar atunci când autoritățile vă permit.',
  'Fiți pregătit pentru eventuale replici ale cutremurului. Dacă simțiți una, consultați pașii de mai sus.',
  'Stați departe de clădiri avariate sau de zonele deteriorate din casă.',
  'Căutați și stingeți incendiile mici, incendiul este cel mai frecvent pericol după un cutremur.',
  'Verificați dacă sunteți rănit și ajutați-i pe cei din jurul vostru.',
];