import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/views/shelters/features/donations/item_list.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final itemList = Provider.of<ItemList>(context);
    final selectedItems = itemList.selectedItems;
    final cartItemQuantities = itemList.cartItemQuantities;

    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent.withOpacity(0.5),
          appBar: AppBar(
            title: const Text('Checkout'),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: selectedItems.length,
                  itemBuilder: (context, index) {
                    final itemName = selectedItems.elementAt(index);
                    final quantity = cartItemQuantities[itemName] ?? 0;
                    return Column(
                      children: [
                        const Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        ListTile(
                          title: Text(
                            itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  if (quantity > 0) {
                                    itemList.decreaseItemQuantity(itemName);
                                  }
                                },
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  itemList.increaseItemQuantity(itemName);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (index == selectedItems.length - 1)
                          const Divider(
                            color: Colors.white,
                            thickness: 1.0,
                          ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: GlassBox(
                  height: 50,
                  width: 300,
                  addedOpacity: 0.3,
                  child: TextButton(
                    child: Text('Donate', style: labelPrimary,),
                    onPressed: () {
                      itemList.removeAllItems();
                      Navigator.of(context).pushNamed(thankYouRoute);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50,)
            ],
          ),
        ),
      ],
    );
  }
}
