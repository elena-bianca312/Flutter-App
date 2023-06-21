import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/views/shelters/features/donations/item_page.dart';
import 'package:myproject/views/shelters/features/donations/item_tile.dart';
import 'package:myproject/views/shelters/features/donations/item_list.dart';
import 'package:myproject/views/shelters/features/donations/category_list.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: false,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CartPage();
                },
              ),
            ),
            child: const Icon(Icons.shopping_bag),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Let's order fresh items for you
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Please select items to donate",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const CategoryList(),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Fresh Items",
                    style: header,
                  ),
                ),

                Consumer<ItemList>(
                  builder: (context, value, child) {
                    return GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(12),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.shopItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1 / 0.2,
                      ),
                      itemBuilder: (context, index) {
                        final itemName = value.shopItems[index][0];
                        final isSelected = value.isItemSelected(itemName);

                        return ItemTile(
                          itemName: itemName,
                          onPressed: () {
                            if (isSelected) {
                              value.removeItem(itemName);
                            } else {
                              value.addItem(itemName);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
