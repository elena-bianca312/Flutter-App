import 'package:flutter/material.dart';

class ItemList extends ChangeNotifier {
  final List _shopItems = const [
    ["Avocado"],
    ["Banana"],
    ["Chicken"],
    ["Water"],
  ];

  final Map<String, int> _cartItemQuantities = {};
  final Set<String> _selectedItems = {};

  List get shopItems => _shopItems;

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
