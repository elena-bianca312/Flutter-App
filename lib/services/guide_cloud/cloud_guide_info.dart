import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/services/guide_cloud/cloud_guide_constants.dart';

class CloudGuideInfo {
  final String ownerUserId;
  final bool item1;
  final bool item2;
  final bool item3;
  final bool item4;
  final bool item5;
  final bool item6;
  final bool item7;
  final bool item8;
  final bool item9;
  final bool item10;
  final bool item11;
  final bool item12;
  final bool item13;
  const CloudGuideInfo({
    required this.ownerUserId,
    required this.item1,
    required this.item2,
    required this.item3,
    required this.item4,
    required this.item5,
    required this.item6,
    required this.item7,
    required this.item8,
    required this.item9,
    required this.item10,
    required this.item11,
    required this.item12,
    required this.item13,
  });

CloudGuideInfo.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) :
    ownerUserId = snapshot.id,
    item1 = snapshot.data()[item1FieldName],
    item2 = snapshot.data()[item2FieldName],
    item3 = snapshot.data()[item3FieldName],
    item4 = snapshot.data()[item4FieldName],
    item5 = snapshot.data()[item5FieldName],
    item6 = snapshot.data()[item6FieldName],
    item7 = snapshot.data()[item7FieldName],
    item8 = snapshot.data()[item8FieldName],
    item9 = snapshot.data()[item9FieldName],
    item10 = snapshot.data()[item10FieldName],
    item11 = snapshot.data()[item11FieldName],
    item12 = snapshot.data()[item12FieldName],
    item13 = snapshot.data()[item13FieldName];
}
