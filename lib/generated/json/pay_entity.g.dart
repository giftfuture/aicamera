// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a PayEntity object.
// 反序列化函数：将 JSON map 转换为 PayEntity 对象。
import '../../models/pay_entity.dart';

PayEntity $PayEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final PayEntity payEntity = PayEntity();
  final String? productType = jsonConvert.convert<String>(json['productType']);
  if (productType != null) {
    payEntity.productType = productType;
  }
  final String? productId = jsonConvert.convert<String>(json['productId']);
  if (productId != null) {
    payEntity.productId = productId;
  }
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    payEntity.source = source;
  }
  final String? deviceId = jsonConvert.convert<String>(json['deviceId']);
  if (deviceId != null) {
    payEntity.deviceId = deviceId;
  }
  final String? num = jsonConvert.convert<String>(json['num']);
  if (num != null) {
    payEntity.num = num;
  }
  final String? records = jsonConvert.convert<String>(json['records']);
  if (records != null) {
    payEntity.records = records;
  }
  return payEntity;
}

// Serialization function: Converts a PayEntity object into a JSON map.
// 序列化函数：将 PayEntity 对象转换为 JSON map。
Map<String, dynamic> $PayEntityToJson(PayEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['productType'] = entity.productType;
  data['productId'] = entity.productId;
  data['source'] = entity.source;
  data['deviceId'] = entity.deviceId;
  data['num'] = entity.num;
  data['records'] = entity.records;
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
