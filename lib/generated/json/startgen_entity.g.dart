// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a StartGenEntity object.
// 反序列化函数：将 JSON map 转换为 StartGenEntity 对象。
import '../../models/startgen_entity.dart';

StartGenEntity $StartGenEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final StartGenEntity startGenEntity = StartGenEntity();
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    startGenEntity.source = source;
  }
  final String? tplId = jsonConvert.convert<String>(json['tplId']);
  if (tplId != null) {
    startGenEntity.tplId = tplId;
  }
  final String? faceImgs = jsonConvert.convert<String>(json['faceImgs']);
  if (faceImgs != null) {
    startGenEntity.faceImgs = faceImgs;
  }
  final String? sex = jsonConvert.convert<String>(json['sex']);
  if (sex != null) {
    startGenEntity.sex = sex;
  }
  final String? deviceId = jsonConvert.convert<String>(json['deviceId']);
  if (deviceId != null) {
    startGenEntity.deviceId = deviceId;
  }
  return startGenEntity;
}

// Serialization function: Converts a StartGenEntity object into a JSON map.
// 序列化函数：将 StartGenEntity 对象转换为 JSON map。
Map<String, dynamic> $StartGenEntityToJson(StartGenEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['source'] = entity.source;
  data['tplId'] = entity.tplId;
  data['faceImgs'] = entity.faceImgs;
  data['sex'] = entity.sex;
  data['deviceId'] = entity.deviceId;
  return data;
}


// --- Helper Function Placeholder ---
// --- 辅助函数占位符 ---
// If you are using a base converter like in photo_entity.g.dart,
// ensure it's imported and available here.
// 如果您像在 photo_entity.g.dart 中那样使用基础转换器，
// 请确保在此处导入并使其可用。
// Example:
// import 'package:your_project/generated/json/base/json_convert_content.dart'; // Adjust path / 调整路径
class jsonConvert { // Placeholder class / 占位符类
  static T? convert<T>(dynamic value) {
    // Implement actual conversion logic or use your existing helper
    // 实现实际的转换逻辑或使用您现有的辅助工具
    if (value == null) return null;
    if (value is T) return value;
    // Add specific type conversions if needed
    // 如果需要，添加特定的类型转换
    if (T == String) return value.toString() as T?;
    // ... other types
    try {
      return value as T?; // Basic cast as fallback / 基本转换作为回退
    } catch (e) {
      print("jsonConvert error: Cannot convert $value (${value.runtimeType}) to type $T");
      return null;
    }
  }
}
// --- End Helper Function Placeholder ---
