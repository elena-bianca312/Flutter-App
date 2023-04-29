import 'package:flutter/services.dart';

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