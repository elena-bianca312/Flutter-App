import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/widgets/background_image.dart';

class SelectableItem {
  final String title;
  bool isSelected;

  SelectableItem(this.title, this.isSelected);
}

class SelectableItemsProvider extends ChangeNotifier {
  List<SelectableItem> items = [
    SelectableItem('Apă (pentru cel puțin 3 zile)', false),
    SelectableItem('Alimente - produse neperisabile (pentru cel puțin 3 zile)', false),
    SelectableItem('Lanternă', false),
    SelectableItem('Radio', false),
    SelectableItem('Baterii', false),
    SelectableItem('Medicamente (pentru cel puțin 7 zile)', false),
    SelectableItem('Trusă de prim ajutor', false),
    SelectableItem('Obiecte de igienă personală', false),
    SelectableItem('Copii ale documentelor personale importante', false),
    SelectableItem('Telefon mobil cu încărcătoare', false),
    SelectableItem('Numerar suplimentar', false),
    SelectableItem('Pătură de urgență', false),
    SelectableItem('Hartă a zonei', false),
  ];

  void toggleSelection(int index) {
    items[index].isSelected = !items[index].isSelected;
    notifyListeners();
  }
}


class FirstAidKitView extends StatelessWidget {
  const FirstAidKitView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectableItemsProvider>(
      create: (_) => SelectableItemsProvider(),
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
                      onTap: () {
                        provider.toggleSelection(index);
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
}