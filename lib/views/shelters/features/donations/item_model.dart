import 'package:flutter/material.dart';

class ItemModel extends ChangeNotifier {
  // list of items on sale
  final List _shopItems = const [
    // [ itemName, itemPrice, imagePath, color ]
    ["Avocado", "4.00", "assets/images/items_list/avocado.png", Colors.green],
    ["Banana", "2.50", "assets/images/items_list/banana.png", Colors.yellow],
    ["Chicken", "12.80", "assets/images/items_list/chicken.png", Colors.brown],
    ["Water", "1.00", "assets/images/items_list/water.png", Colors.blue],
  ];

  // hashmap of cart items with quantity
  final Map<String, int> _cartItemQuantities = {};

  get cartItemQuantities => _cartItemQuantities;

  get shopItems => _shopItems;

  // add item to cart
  void addItemToCart(String itemName) {

    if (_cartItemQuantities.containsKey(itemName)) {
      _cartItemQuantities[itemName] = _cartItemQuantities[itemName]! + 1;
    } else {
      _cartItemQuantities[itemName] = 1;
    }

    notifyListeners();
  }

  // remove item from cart
  void removeItemFromCart(String itemName) {

    if (_cartItemQuantities.containsKey(itemName)) {
      _cartItemQuantities[itemName] = _cartItemQuantities[itemName]! - 1;
      if (_cartItemQuantities[itemName]! <= 0) {
        _cartItemQuantities.remove(itemName);
      }
    }

    notifyListeners();
  }

  // calculate total price
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
