import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/widgets/background_image.dart';



class EmergencyContactsView extends StatelessWidget {
  const EmergencyContactsView({super.key});

  _makePhoneCall(String phoneNumber) async {
  var url = Uri.parse("tel:$phoneNumber");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Emergency Contacts'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.transparent,
                child: GlassBox(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            'Romania Emergency Number',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(kCustomBlue),
                              ),
                              onPressed: () {
                                _makePhoneCall('112');
                              },
                              child: const Text(
                                '112',
                                style: TextStyle(color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
