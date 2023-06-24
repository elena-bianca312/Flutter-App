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
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ItemList>(context, listen: false).removeAllItems();
        return true;
      },
      child: Stack(
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
    
                  Consumer<CategoryList>(
                    builder: (context, categoryList, child) {
                      return CategoryListWidget(
                        categoryList: categoryList,
                      );
                    },
                  ),
    
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Divider(),
                  ),
    
                  const SizedBox(height: 24),
    
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      Provider.of<CategoryList>(context).selectedCategory,
                      style: header,
                    ),
                  ),
    
                  Consumer<ItemList>(
                    builder: (context, itemList, child) {
                      final selectedCategory = Provider.of<CategoryList>(context).selectedCategory;
                      List<dynamic> items;
    
                      if (selectedCategory == 'Fresh Foods') {
                        items = itemList.freshFoods;
                      } else if (selectedCategory == 'Non-perishable Foods') {
                        items = itemList.nonPerishableFoods;
                      } else if (selectedCategory == 'Sanitary Items') {
                        items = itemList.sanitaryItems;
                      } else if (selectedCategory == 'Clothing') {
                        items = itemList.clothingItems;
                      } else if (selectedCategory == 'Toys') {
                        items = itemList.toysItems;
                      } else {
                        items = itemList.otherItems;
                      }
    
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(12),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1 / 0.2,
                        ),
                        itemBuilder: (context, index) {
                          final itemName = items[index][0];
                          final isSelected = itemList.isItemSelected(itemName);
                          return ItemTile(
                            itemName: itemName,
                            onPressed: () {
                              if (isSelected) {
                                itemList.removeItem(itemName);
                              } else {
                                itemList.addItem(itemName);
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
      ),
    );
  }
}

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key, required this.categoryList});

  final CategoryList categoryList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            categoryList.selectCategory(index);
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              right: index == categoryList.categories.length - 1 ? kDefaultPadding : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: index == categoryList.selectedIndex
                  ? Colors.white.withOpacity(0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              categoryList.categories[index],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
