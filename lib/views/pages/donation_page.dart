import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/views/pages/custom.dart';


class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  var selectedPayment = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Page'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset('assets/images/ui/dogs.jpg', height: 100),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shelter\nName',
                          style: header,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'nuj ce scriu aici',
                          style: small,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      '\$100,000',
                      style: price,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '/an',
                      style: small,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: subheader,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your donation can provide temporary shelter, food, and clean water to those affected by the earthquake. It can help provide medical aid to those who have been injured, and support relief efforts to ensure that necessary supplies reach those who need them the most. Your generosity can go a long way in providing hope and a brighter future for those who have been affected by this disaster.',
                      style: p,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: subheader,
                    ),
                    const SizedBox(height: 12),
                    _selectPayment('VISA', 'assets/images/payment/visa.png'),
                    const SizedBox(height: 16),
                    _selectPayment('Master Card', 'assets/images/payment/mc.png'),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  style: buttonPrimary,
                  onPressed: () {},
                  child: Text(
                    'Support Now',
                    style: labelPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Terms & Conditions',
                    style: labelSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectPayment(String title, String? image) {
    return InkWell(
      onTap: () {
        selectPayment(title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: title == selectedPayment ? white : Colors.transparent,
          border: title == selectedPayment
              ? Border.all(width: 1, color: Colors.transparent)
              : Border.all(width: 1, color: grey),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: title == selectedPayment ? paymentSelected : payment,
                ),
                const Spacer(),
                image != null ? Image.asset(image, height: 23) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectPayment(title) {
    setState(() {
      selectedPayment = title;
    });
  }
}