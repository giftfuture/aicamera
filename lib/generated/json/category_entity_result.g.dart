// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a CategoryEntityResult object.
// 反序列化函数：将 JSON map 转换为 CategoryEntityResult 对象。
import '../../models/category_entity_result.dart';

CategoryEntityResult $CategoryEntityResultFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final CategoryEntityResult categoryEntityResult = CategoryEntityResult();
  final String? categorys = jsonConvert.convert<String>(json['categorys']);
  if (categorys != null) {
    categoryEntityResult.categorys = categorys;
  }
  final int? isCos = jsonConvert.convert<int>(json['isCos']);
  if (isCos != null) {
    categoryEntityResult.isCos = isCos;
  }
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    categoryEntityResult.img = img;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    categoryEntityResult.price = price;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    categoryEntityResult.sex = sex;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    categoryEntityResult.name = name;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    categoryEntityResult.id = id;
  }
  final int? label = jsonConvert.convert<int>(json['label']);
  if (label != null) {
    categoryEntityResult.label = label;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    categoryEntityResult.type = type;
  }
  return categoryEntityResult;
}

// Serialization function: Converts a CategoryEntityResult object into a JSON map.
// 序列化函数：将 CategoryEntityResult 对象转换为 JSON map。
Map<String, dynamic> $CategoryEntityResultToJson(CategoryEntityResult entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['categorys'] = entity.categorys;
  data['isCos'] = entity.isCos;
  data['img'] = entity.img;
  data['price'] = entity.price;
  data['sex'] = entity.sex;
  data['name'] = entity.name;
  data['id'] = entity.id;
  data['label'] = entity.label;
  data['type'] = entity.type;
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
    // Handle potential type mismatch for double from int
    // 处理 double 可能来自 int 的类型不匹配
    if (T == double && value is int) return value.toDouble() as T?;

    try {
      return value as T?; // Basic cast as fallback / 基本转换作为回退
    } catch (e) {
      print("jsonConvert error: Cannot convert $value (${value.runtimeType}) to type $T");
      return null;
    }
  }
}
// --- End Helper Function Placeholder ---
