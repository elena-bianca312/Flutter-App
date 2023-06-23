import 'cloud_guide_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/guide_cloud/cloud_guide_exceptions.dart';


class FirebaseGuideStorage {
  // Factory constructor and singleton pattern
  FirebaseGuideStorage._sharedInstance();
  static final FirebaseGuideStorage _shared = FirebaseGuideStorage._sharedInstance();
  factory FirebaseGuideStorage() {
    return _shared;
  }

  final guide = FirebaseFirestore.instance.collection('users_guide');

  Future<void> createNewGuide({required String ownerUserId}) async {
    final guideDoc = guide.doc(ownerUserId);

    final guideSnapshot = await guideDoc.get();
    if (guideSnapshot.exists) {
      // Guide already exists, do not create a new one
      return;
    }

    await guideDoc.set({
      item1FieldName: false,
      item2FieldName: false,
      item3FieldName: false,
      item4FieldName: false,
      item5FieldName: false,
      item6FieldName: false,
      item7FieldName: false,
      item8FieldName: false,
      item9FieldName: false,
      item10FieldName: false,
      item11FieldName: false,
      item12FieldName: false,
      item13FieldName: false,
    });
  }

  Future<void> selectItem({required String ownerUserId, required int itemIndex}) async {
    await guide.doc(ownerUserId).update({
      _getItemFieldName(itemIndex): true,
    });
  }

  Future<void> deselectItem({required String ownerUserId, required int itemIndex}) async {
    await guide.doc(ownerUserId).update({
      _getItemFieldName(itemIndex): false,
    });
  }

  Future<bool> isItemSelected({required String ownerUserId, required int itemIndex}) async {
    final guideSnapshot = await guide.doc(ownerUserId).get();
    if (!guideSnapshot.exists) {
      throw GuideNotFoundException();
    }

    return guideSnapshot.get(_getItemFieldName(itemIndex));
  }

  Future<List<bool>> getSelectionList({required String ownerUserId}) async {
    final guideSnapshot = await guide.doc(ownerUserId).get();
    if (!guideSnapshot.exists) {
      throw GuideNotFoundException();
    }

    return [
      guideSnapshot.get(item1FieldName),
      guideSnapshot.get(item2FieldName),
      guideSnapshot.get(item3FieldName),
      guideSnapshot.get(item4FieldName),
      guideSnapshot.get(item5FieldName),
      guideSnapshot.get(item6FieldName),
      guideSnapshot.get(item7FieldName),
      guideSnapshot.get(item8FieldName),
      guideSnapshot.get(item9FieldName),
      guideSnapshot.get(item10FieldName),
      guideSnapshot.get(item11FieldName),
      guideSnapshot.get(item12FieldName),
      guideSnapshot.get(item13FieldName),
    ];
  }

  _getItemFieldName(int itemIndex) {
    switch (itemIndex) {
      case 1:
        return item1FieldName;
      case 2:
        return item2FieldName;
      case 3:
        return item3FieldName;
      case 4:
        return item4FieldName;
      case 5:
        return item5FieldName;
      case 6:
        return item6FieldName;
      case 7:
        return item7FieldName;
      case 8:
        return item8FieldName;
      case 9:
        return item9FieldName;
      case 10:
        return item10FieldName;
      case 11:
        return item11FieldName;
      case 12:
        return item12FieldName;
      case 13:
        return item13FieldName;
      default:
        throw InvalidIndexException();
    }
  }
}
