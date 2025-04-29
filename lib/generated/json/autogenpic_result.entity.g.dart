// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into an AutoGenPicResultEntity object.
// 反序列化函数：将 JSON map 转换为 AutoGenPicResultEntity 对象。
import '../../models/autogenpic_result.entity.dart';

AutoGenPicResultEntity $AutoGenPicResultEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final AutoGenPicResultEntity autoGenPicResultEntity = AutoGenPicResultEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    autoGenPicResultEntity.id = id;
  }
  final int? finishedTs = jsonConvert.convert<int>(json['finishedTs']);
  if (finishedTs != null) {
    autoGenPicResultEntity.finishedTs = finishedTs;
  }
  final int? queue = jsonConvert.convert<int>(json['queue']);
  if (queue != null) {
    autoGenPicResultEntity.queue = queue;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    autoGenPicResultEntity.status = status;
  }
  final int? ts = jsonConvert.convert<int>(json['ts']);
  if (ts != null) {
    autoGenPicResultEntity.ts = ts;
  }
  return autoGenPicResultEntity;
}

// Serialization function: Converts an AutoGenPicResultEntity object into a JSON map.
// 序列化函数：将 AutoGenPicResultEntity 对象转换为 JSON map。
Map<String, dynamic> $AutoGenPicResultEntityToJson(AutoGenPicResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['finishedTs'] = entity.finishedTs;
  data['queue'] = entity.queue;
  data['status'] = entity.status;
  data['ts'] = entity.ts;
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
    if (T == int && value is num) return value.toInt() as T?;
    if (T == double && value is num) return value.toDouble() as T?;
    if (T == String) return value.toString() as T?;
    // ... other types
    try {
      return value as T?; // Basic cast as fallback / 基本转换作为回退
    } catch (e) {
      print("jsonConvert error: Cannot convert $value to type $T");
      return null;
    }
  }
}
// --- End Helper Function Placeholder ---
