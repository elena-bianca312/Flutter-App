import 'package:flutter/services.dart';

String backupPhotoURL = 'assets/images/bloc1.jpg';

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