// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// **************************************************************************
// BUCK Auto-Generated Code (or similar generator comment)
// **************************************************************************

// Import the base converter and the main entity model.
// Adjust the paths based on your actual project structure.
// 导入基础转换器和主实体模型。请根据您的实际项目结构调整路径。
import 'package:aicamera/generated/json/base/json_convert_content.dart'; // Adjust path as needed
import 'package:aicamera/models/login_result_entity.dart'; // Adjust path as needed

// Deserialization function: Converts a JSON map into a LoginResultEntity object.
// 反序列化函数：将 JSON map 转换为 LoginResultEntity 对象。
LoginResultEntity $LoginResultEntityFromJson(Map<String, dynamic> json) {
  final LoginResultEntity loginResultEntity = LoginResultEntity();
  // Use jsonConvert for nullable fields, matching photo_entity.g.dart pattern
  // 对可空字段使用 jsonConvert，匹配 photo_entity.g.dart 模式
  final int? sourceZone = jsonConvert.convert<int>(json['sourceZone']);
  if (sourceZone != null) {
    loginResultEntity.sourceZone = sourceZone;
  }
  final String? background = jsonConvert.convert<String>(json['background']);
  if (background != null) {
    loginResultEntity.background = background;
  }
  final int? offlineType = jsonConvert.convert<int>(json['offlineType']);
  if (offlineType != null) {
    loginResultEntity.offlineType = offlineType;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    loginResultEntity.id = id;
  }
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    loginResultEntity.source = source;
  }
  final String? deviceId = jsonConvert.convert<String>(json['deviceId']);
  if (deviceId != null) {
    loginResultEntity.deviceId = deviceId;
  }
  final String? logoUrl = jsonConvert.convert<String>(json['logoUrl']);
  if (logoUrl != null) {
    loginResultEntity.logoUrl = logoUrl;
  }
  return loginResultEntity;
}

// Serialization function: Converts a LoginResultEntity object into a JSON map.
// 序列化函数：将 LoginResultEntity 对象转换为 JSON map。
Map<String, dynamic> $LoginResultEntityToJson(LoginResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  // Assign entity fields to the map keys
  // 将实体字段分配给 map 键
  data['sourceZone'] = entity.sourceZone;
  data['background'] = entity.background;
  data['offlineType'] = entity.offlineType;
  data['id'] = entity.id;
  data['source'] = entity.source;
  data['deviceId'] = entity.deviceId;
  data['logoUrl'] = entity.logoUrl;
  return data;
}

// The copyWith extension method should be in login_result_entity.dart.
// copyWith 扩展方法应位于 login_result_entity.dart 中。
// extension LoginResultEntityExtension on LoginResultEntity {
//   LoginResultEntity copyWith({
//     int? sourceZone,
//     String? background,
//     int? offlineType,
//     int? id,
//     String? source,
//     String? deviceId,
//     String? logoUrl,
//   }) {
//     return LoginResultEntity()
//       ..sourceZone = sourceZone ?? this.sourceZone
//       ..background = background ?? this.background
//       ..offlineType = offlineType ?? this.offlineType
//       ..id = id ?? this.id
//       ..source = source ?? this.source
//       ..deviceId = deviceId ?? this.deviceId
//       ..logoUrl = logoUrl ?? this.logoUrl;
//   }
// }
