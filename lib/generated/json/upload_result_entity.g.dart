// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// **************************************************************************
// BUCK Auto-Generated Code (or similar generator comment)
// **************************************************************************

// Import the base converter and the main entity model.
// Adjust the paths based on your actual project structure.
import 'package:aicamera/generated/json/base/json_convert_content.dart'; // Adjust path as needed
import 'package:aicamera/models/upload_result_entity.dart'; // Adjust path as needed

// Deserialization function: Converts a JSON map into an UploadResultEntity object.
UploadResultEntity $UploadResultEntityFromJson(Map<String, dynamic> json) {
  final UploadResultEntity uploadResultEntity = UploadResultEntity();
  // Use jsonConvert for nullable fields, matching photo_entity.g.dart pattern
  final List<int>? faceRec = jsonConvert.convertListNotNull<int>(json['faceRec']);
  if (faceRec != null) {
    uploadResultEntity.faceRec = faceRec;
  }
  final String? insUrl = jsonConvert.convert<String>(json['insUrl']);
  if (insUrl != null) {
    uploadResultEntity.insUrl = insUrl;
  }
  final bool? insFacePorpCheak = jsonConvert.convert<bool>(json['insFacePorpCheak']);
  if (insFacePorpCheak != null) {
    uploadResultEntity.insFacePorpCheak = insFacePorpCheak;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    uploadResultEntity.sex = sex;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    uploadResultEntity.url = url;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    uploadResultEntity.age = age;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    uploadResultEntity.status = status;
  }
  return uploadResultEntity;
}

// Serialization function: Converts an UploadResultEntity object into a JSON map.
Map<String, dynamic> $UploadResultEntityToJson(UploadResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  // Assign entity fields to the map keys
  data['faceRec'] = entity.faceRec;
  data['insUrl'] = entity.insUrl;
  data['insFacePorpCheak'] = entity.insFacePorpCheak;
  data['sex'] = entity.sex;
  data['url'] = entity.url;
  data['age'] = entity.age;
  data['status'] = entity.status;
  return data;
}

// The copyWith extension method should be in upload_result_entity.dart.
// extension UploadResultEntityExtension on UploadResultEntity {
//   UploadResultEntity copyWith({
//     List<int>? faceRec,
//     String? insUrl,
//     bool? insFacePorpCheak,
//     int? sex,
//     String? url,
//     int? age,
//     int? status,
//   }) {
//     return UploadResultEntity()
//       ..faceRec = faceRec ?? this.faceRec
//       ..insUrl = insUrl ?? this.insUrl
//       ..insFacePorpCheak = insFacePorpCheak ?? this.insFacePorpCheak
//       ..sex = sex ?? this.sex
//       ..url = url ?? this.url
//       ..age = age ?? this.age
//       ..status = status ?? this.status;
//   }
// }
