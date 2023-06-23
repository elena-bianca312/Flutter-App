import 'package:flutter/material.dart';

const kDefaultPadding = 20.0;

class CategoryList extends ChangeNotifier {
  int selectedIndex = 0;
  List<String> categories = [
    'Fresh Foods',
    'Non-perishable Foods',
    'Sanitary Items',
    'Clothing',
    'Toys',
    'Other',
  ];

  String get selectedCategory => categories[selectedIndex];

  void selectCategory(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            selectCategory(index);
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              right: index == categories.length - 1 ? kDefaultPadding : 0,
            ),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? Colors.white.withOpacity(0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              categories[index],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
