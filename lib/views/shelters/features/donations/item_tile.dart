import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myproject/views/shelters/features/donations/item_list.dart';

class ItemTile extends StatefulWidget {
  final String itemName;
  final Function onPressed;

  const ItemTile({Key? key, required this.itemName, required this.onPressed})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    final itemList = Provider.of<ItemList>(context);
    final isSelected = itemList.isItemSelected(widget.itemName);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              itemList.removeItem(widget.itemName);
            } else {
              itemList.addItem(widget.itemName);
              widget.onPressed();
            }
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              widget.itemName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
