import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

List<String> fixedListData = [
  'Fixed Item 1',
  'Fixed Item 2',
  'Fixed Item 3',
];

class EarthquakePlanView extends StatelessWidget {

  const EarthquakePlanView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectableItemsProvider>(
      create: (_) => SelectableItemsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Earthquake Plan'),
        ),
        body: Consumer<SelectableItemsProvider>(
          builder: (_, provider, __) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      const Text('Înainte de cutremur'),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: provider.items.length,
                          itemBuilder: (context, index) {
                            final item = provider.items[index];
                            return ListTile(
                              leading: item.isSelected ? const Icon(Icons.check_box_rounded) : const Icon(Icons.check_box_outline_blank),
                              title: Text(item.title),
                              tileColor: null,
                              onTap: () {
                                provider.toggleSelection(index);
                              },
                            );
                          },
                        ),
                      ),
                      const Text('În timpul cutremurului'),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20), // Add spacing before the next ListView.builder
                      const Text('Dacă vă aflați în interior'),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: insideList.length,
                        itemBuilder: (context, index) {
                          final fixedItem = insideList[index];
                          return ListTile(
                            title: Text(fixedItem),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20), // Add spacing before the next ListView.builder
                      const Text('Dacă vă aflați afară'),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: outsideList.length,
                        itemBuilder: (context, index) {
                          final fixedItem = outsideList[index];
                          return ListTile(
                            title: Text(fixedItem),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20), // Add spacing before the next ListView.builder
                      const Text('Dacă vă aflați într-o mașină'),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: vehicleList.length,
                        itemBuilder: (context, index) {
                          final fixedItem = vehicleList[index];
                          return ListTile(
                            title: Text(fixedItem),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20), // Add spacing before the next ListView.builder
                      const Text('După cutremur'),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: afterwardList.length,
                        itemBuilder: (context, index) {
                          final fixedItem = afterwardList[index];
                          return ListTile(
                            title: Text(fixedItem),
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