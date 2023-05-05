import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/views/pages/custom.dart';

String backupPhotoURL = 'assets/images/ui/bloc1.jpg';

Future<String?> loadAsset(String? assetPath) async {
  try {
    if (assetPath == null) {
      return "unavailable";
    }
    return await rootBundle.loadString(assetPath);
  } catch (e) {
    return "could not load asset";
  }
}

Widget myAnimatedButton(Function function, bool isSelected, String title, String? image) {
    return InkWell(
      onTap: () {
        function();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected ? white : Colors.transparent,
          border: isSelected
              ? Border.all(width: 1, color: Colors.transparent)
              : Border.all(width: 1, color: grey),
        ),
        child: SizedBox(
          width: 350,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: isSelected ? paymentSelected : payment,
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