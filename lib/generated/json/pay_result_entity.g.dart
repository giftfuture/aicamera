// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a PayResultEntity object.
// 反序列化函数：将 JSON map 转换为 PayResultEntity 对象。
import '../../models/pay_result_entity.dart';

PayResultEntity $PayResultEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final PayResultEntity payResultEntity = PayResultEntity();
  final String? appId = jsonConvert.convert<String>(json['appId']);
  if (appId != null) {
    payResultEntity.appId = appId;
  }
  final String? codeUrl = jsonConvert.convert<String>(json['codeUrl']);
  if (codeUrl != null) {
    payResultEntity.codeUrl = codeUrl;
  }
  final String? nonceStr = jsonConvert.convert<String>(json['nonceStr']);
  if (nonceStr != null) {
    payResultEntity.nonceStr = nonceStr;
  }
  final String? orderId = jsonConvert.convert<String>(json['orderId']);
  if (orderId != null) {
    payResultEntity.orderId = orderId;
  }
  // Use 'package' key from JSON, map to 'packageValue' field
  // 使用 JSON 中的 'package' 键，映射到 'packageValue' 字段
  final String? packageValue = jsonConvert.convert<String>(json['package']);
  if (packageValue != null) {
    payResultEntity.packageValue = packageValue;
  }
  final String? paySign = jsonConvert.convert<String>(json['paySign']);
  if (paySign != null) {
    payResultEntity.paySign = paySign;
  }
  final String? signType = jsonConvert.convert<String>(json['signType']);
  if (signType != null) {
    payResultEntity.signType = signType;
  }
  final String? timeStamp = jsonConvert.convert<String>(json['timeStamp']);
  if (timeStamp != null) {
    payResultEntity.timeStamp = timeStamp;
  }
  return payResultEntity;
}

// Serialization function: Converts a PayResultEntity object into a JSON map.
// 序列化函数：将 PayResultEntity 对象转换为 JSON map。
Map<String, dynamic> $PayResultEntityToJson(PayResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['appId'] = entity.appId;
  data['codeUrl'] = entity.codeUrl;
  data['nonceStr'] = entity.nonceStr;
  data['orderId'] = entity.orderId;
  // Use 'package' key in JSON, map from 'packageValue' field
  // 在 JSON 中使用 'package' 键，从 'packageValue' 字段映射
  data['package'] = entity.packageValue;
  data['paySign'] = entity.paySign;
  data['signType'] = entity.signType;
  data['timeStamp'] = entity.timeStamp;
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
