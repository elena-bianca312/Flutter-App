import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/guide_cloud/cloud_guide_constants.dart';

class CloudGuideInfo {
  final String ownerUserId;
  final bool item1;
  final bool item2;
  final bool item3;
  final bool item4;
  const CloudGuideInfo({
    required this.ownerUserId,
    required this.item1,
    required this.item2,
    required this.item3,
    required this.item4,
  });

CloudGuideInfo.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    ownerUserId = snapshot.id,
    item1 = snapshot.data()[item1FieldName],
    item2 = snapshot.data()[item2FieldName],
    item3 = snapshot.data()[item3FieldName],
    item4 = snapshot.data()[item4FieldName];
}
