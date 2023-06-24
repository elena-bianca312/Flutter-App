import 'package:flutter/material.dart';

class ItemList extends ChangeNotifier {
  final List _shopItems = const [
    ["Avocado"],
    ["Banana"],
    ["Chicken"],
    ["Water"],
  ];

  final List _otherShopItems = const [
    ["Item 1"],
    ["Item 2"],
    ["Item 3"],
    ["Item 4"],
  ];

  final List _freshFoods = const [
    ["Fruits: Apples, bananas, oranges, strawberries, grapes, watermelon"],
    ["Vegetables: Carrots, broccoli, spinach, tomatoes, lettuce, bell peppers"],
    ["Meat: Chicken breast, beef steak, pork chops, salmon, shrimp"],
    ["Dairy Products: Milk, yogurt, cheese, eggs"],
    ["Bread: Whole wheat bread, baguette, ciabatta."],
    ["Legumes: Lentils, chickpeas, black beans, kidney beans."],
    ["Mushrooms: Button mushrooms, shiitake mushrooms, portobello mushrooms."],
    ["Other"],
  ];

  final List _nonPerishableFoods = const [
    ["Canned Goods: Canned beans, canned vegetables, canned fruits, canned soups"],
    ["Pasta and Rice: Spaghetti, macaroni, rice, couscous, quinoa"],
    ["Cereal and Oatmeal: Breakfast cereals, instant oatmeal"],
    ["Dried Fruits and Nuts: Raisins, dried apricots, almonds, peanuts"],
    ["Canned or Jarred Sauces: Pasta sauce, tomato sauce, salsa"],
    ["Shelf-Stable Milk: Powdered milk, long-life milk"],
    ["Canned Meat and Fish: Tuna, salmon, chicken"],
    ["Peanut Butter and Nut Spreads: Peanut butter, almond butter."],
    ["Crackers and Biscuits: Saltine crackers, whole-grain crackers, oat biscuits"],
    ["Baking Essentials: Flour, sugar, baking powder, baking soda"],
    ["Other"],
  ];

  final List _sanitaryItems = const [
    ["Personal hygiene products (toothpaste, toothbrushes, soap, shampoo, etc.)"],
    ["Toilet paper"],
    ["Tissues"],
    ["Diapers (for babies and adults)"],
    ["Hand sanitizers"],
    ["Feminine hygiene products (pads, tampons)"],
    ["Disinfecting wipes"],
    ["Disposable gloves"],
    ["Other"],
  ];

  final List _clothingItems = const [
    ["Shirts & T-shirts"],
    ["Sweaters & Hoodies"],
    ["Jackets & Coats"],
    ["Pants & Jeans"],
    ["Dresses & Skirts"],
    ["Underwear & Socks"],
    ["Shoes"],
    ["Other"],
  ];

  final List _toysItems = const [
    ["Stuffed animals"],
    ["Dolls"],
    ["Action figures"],
    ["Board games"],
    ["Puzzles"],
    ["Art supplies"],
    ["Playsets"],
    ["Toy vehicles"],
    ["Musical instruments"],
    ["Sports equipment"],
    ["Educational toys"],
    ["Other"],
  ];

  final List _otherItems = const [
    ["Other"],
  ];

  final Map<String, int> _cartItemQuantities = {};
  final Set<String> _selectedItems = {};

  List get shopItems => _shopItems;

  List get otherShopItems => _otherShopItems;

  List get freshFoods => _freshFoods;

  List get nonPerishableFoods => _nonPerishableFoods;

  List get sanitaryItems => _sanitaryItems;

  List get clothingItems => _clothingItems;

  List get toysItems => _toysItems;

  List get otherItems => _otherItems;

  Map<String, int> get cartItemQuantities => _cartItemQuantities;

  Set<String> get selectedItems => _selectedItems;

  void addItem(String itemName) {
    _cartItemQuantities[itemName] = 1;

    _selectedItems.add(itemName);
    notifyListeners();
  }

  void removeItem(String itemName) {
    _cartItemQuantities.remove(itemName);

    _selectedItems.remove(itemName);
    notifyListeners();
  }

  void removeAllItems() {
    _cartItemQuantities.clear();

    _selectedItems.clear();
    notifyListeners();
  }

  void increaseItemQuantity(String itemName) {
    if (_cartItemQuantities.containsKey(itemName)) {
      _cartItemQuantities[itemName] = _cartItemQuantities[itemName]! + 1;
    } else {
      _cartItemQuantities[itemName] = 1;
    }

    notifyListeners();
  }

  void decreaseItemQuantity(String itemName) {
    if (_cartItemQuantities.containsKey(itemName)) {
      _cartItemQuantities[itemName] = _cartItemQuantities[itemName]! - 1;
      if (_cartItemQuantities[itemName]! <= 0) {
        _cartItemQuantities.remove(itemName);
        _selectedItems.remove(itemName);
      }
    }

    notifyListeners();
  }

  // check if an item is selected
  bool isItemSelected(String itemName) {
    return _cartItemQuantities.containsKey(itemName);
  }

  String calculateTotal() {
    double totalPrice = 0;
    for (String itemName in cartItemQuantities.keys) {
      int quantity = cartItemQuantities[itemName]!;
      for (List<dynamic> item in shopItems) {
        if (item[0] == itemName) {
          double price = double.parse(item[1]);
          totalPrice += price * quantity;
          break;
        }
      }
    }
    return totalPrice.toStringAsFixed(2);
  }
}
