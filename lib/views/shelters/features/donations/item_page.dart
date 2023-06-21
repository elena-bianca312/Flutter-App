import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/views/shelters/features/donations/item_list.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  late final FirebaseShelterStorage _sheltersService;
  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.grey[800],
        ),
      ),
      body: Consumer<ItemList>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "My Selected Items",
                  style: GoogleFonts.notoSerif(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // list view of cart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: value.shopItems.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      if (value.cartItemQuantities[value.shopItems[index][0]] == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: Image.asset(
                              value.shopItems[index][2],
                              height: 36,
                            ),
                            title: Text(
                              value.shopItems[index][0],
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              // ignore: prefer_interpolation_to_compose_strings
                              '\$' + value.shopItems[index][1],
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: SizedBox(
                              width: 120,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () =>
                                        Provider.of<ItemList>(context, listen: false)
                                            .removeItem(value.shopItems[index][0]),
                                  ),
                                  Text(
                                    value.cartItemQuantities[value.shopItems[index][0]].toString(),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        Provider.of<ItemList>(context, listen: false)
                                            .addItem(value.shopItems[index][0]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // total amount + pay now

              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green,
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(color: Colors.green[200]),
                          ),

                          const SizedBox(height: 8),
                          // total price
                          Text(
                            '\$${value.calculateTotal()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // pay now
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green.shade200),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(thankYouRoute);
                              },
                              child: const Text('Donate Now', style: TextStyle(color: Colors.white),)
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}