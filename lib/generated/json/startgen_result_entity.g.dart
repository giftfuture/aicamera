// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a StartGenResultEntity object.
// 反序列化函数：将 JSON map 转换为 StartGenResultEntity 对象。
import '../../models/startgen_result_entity.dart';

StartGenResultEntity $StartGenResultEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final StartGenResultEntity startGenResultEntity = StartGenResultEntity();
  final int? queue2 = jsonConvert.convert<int>(json['queue2']);
  if (queue2 != null) {
    startGenResultEntity.queue2 = queue2;
  }
  final int? length = jsonConvert.convert<int>(json['length']);
  if (length != null) {
    startGenResultEntity.length = length;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    startGenResultEntity.id = id;
  }
  final int? finishedTs = jsonConvert.convert<int>(json['finishedTs']);
  if (finishedTs != null) {
    startGenResultEntity.finishedTs = finishedTs;
  }
  final int? queue = jsonConvert.convert<int>(json['queue']);
  if (queue != null) {
    startGenResultEntity.queue = queue;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    startGenResultEntity.status = status;
  }
  final int? ts = jsonConvert.convert<int>(json['ts']);
  if (ts != null) {
    startGenResultEntity.ts = ts;
  }
  return startGenResultEntity;
}

// Serialization function: Converts a StartGenResultEntity object into a JSON map.
// 序列化函数：将 StartGenResultEntity 对象转换为 JSON map。
Map<String, dynamic> $StartGenResultEntityToJson(StartGenResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['queue2'] = entity.queue2;
  data['length'] = entity.length;
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
      print("jsonConvert error: Cannot convert $value (${value.runtimeType}) to type $T");
      return null;
    }
  }
}
// --- End Helper Function Placeholder ---
