import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/earthquake_plan_cloud/cloud_earthquake_plan_constants.dart';
import 'package:myproject/services/earthquake_plan_cloud/cloud_earthquake_plan_exceptions.dart';


class FirebaseEarthquakePlanStorage {
  // Factory constructor and singleton pattern
  FirebaseEarthquakePlanStorage._sharedInstance();
  static final FirebaseEarthquakePlanStorage _shared = FirebaseEarthquakePlanStorage._sharedInstance();
  factory FirebaseEarthquakePlanStorage() {
    return _shared;
  }

  final earthquakePlan = FirebaseFirestore.instance.collection('users_earthquake_plan');

  Future<void> createNewEarthquakePlan({required String ownerUserId}) async {
    final guideDoc = earthquakePlan.doc(ownerUserId);

    final guideSnapshot = await guideDoc.get();
    if (guideSnapshot.exists) {
      return;
    }

    await guideDoc.set({
      item1FieldName: false,
      item2FieldName: false,
      item3FieldName: false,
      item4FieldName: false,
    });
  }

  Future<void> selectItem({required String ownerUserId, required int itemIndex}) async {
    await earthquakePlan.doc(ownerUserId).update({
      _getItemFieldName(itemIndex): true,
    });
  }

  Future<void> deselectItem({required String ownerUserId, required int itemIndex}) async {
    await earthquakePlan.doc(ownerUserId).update({
      _getItemFieldName(itemIndex): false,
    });
  }

  Future<bool> isItemSelected({required String ownerUserId, required int itemIndex}) async {
    final earthquakePlanSnapshot = await earthquakePlan.doc(ownerUserId).get();
    if (!earthquakePlanSnapshot.exists) {
      throw EarthquakePlanNotFoundException();
    }

    return earthquakePlanSnapshot.get(_getItemFieldName(itemIndex));
  }

  Future<List<bool>> getSelectionList({required String ownerUserId}) async {
    final guideSnapshot = await earthquakePlan.doc(ownerUserId).get();
    if (!guideSnapshot.exists) {
      throw EarthquakePlanNotFoundException();
    }

    return [
      guideSnapshot.get(item1FieldName),
      guideSnapshot.get(item2FieldName),
      guideSnapshot.get(item3FieldName),
      guideSnapshot.get(item4FieldName),
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
      default:
        throw InvalidIndexException();
    }
  }
}
