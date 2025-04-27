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
import 'package:aicamera/models/upload_entity.dart'; // Adjust path as needed

// Deserialization function: Converts a JSON map into an UploadEntity object.
UploadEntity $UploadEntityFromJson(Map<String, dynamic> json) {
      final UploadEntity uploadEntity = UploadEntity();
      // Use jsonConvert for nullable String fields, matching photo_entity.g.dart pattern
      final String? imgPath = jsonConvert.convert<String>(json['imgPath']); // Use correct JSON key 'imgPath' if needed, or 'img'
      if (imgPath != null) {
            uploadEntity.imgPath = imgPath;
      }
      final String? deviceId = jsonConvert.convert<String>(json['deviceId']);
      if (deviceId != null) {
            uploadEntity.deviceId = deviceId;
      }
      final String? source = jsonConvert.convert<String>(json['source']);
      if (source != null) {
            uploadEntity.source = source;
      }
      final String? userId = jsonConvert.convert<String>(json['userId']);
      if (userId != null) {
            uploadEntity.userId = userId;
      }
      final String? type = jsonConvert.convert<String>(json['type']);
      if (type != null) {
            uploadEntity.type = type;
      }
      return uploadEntity;
}

// Serialization function: Converts an UploadEntity object into a JSON map.
Map<String, dynamic> $UploadEntityToJson(UploadEntity entity) {
      final Map<String, dynamic> data = <String, dynamic>{};
      // Assign entity fields to the map keys
      data['imgPath'] = entity.imgPath; // Use correct JSON key 'imgPath' if needed, or 'img'
      data['deviceId'] = entity.deviceId;
      data['source'] = entity.source;
      data['userId'] = entity.userId;
      data['type'] = entity.type;
      return data;
}

// The copyWith extension method should be in upload_entity.dart as per photo_entity pattern.
// extension UploadEntityExtension on UploadEntity {
//   UploadEntity copyWith({
//     String? imgPath,
//     String? deviceId,
//     String? source,
//     String? userId,
//     String? type,
//   }) {
//     return UploadEntity()
//       ..imgPath = imgPath ?? this.imgPath
//       ..deviceId = deviceId ?? this.deviceId
//       ..source = source ?? this.source
//       ..userId = userId ?? this.userId
//       ..type = type ?? this.type;
//   }
// }

