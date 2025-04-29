// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a TemplateResultEntity object.
// 反序列化函数：将 JSON map 转换为 TemplateResultEntity 对象。
import '../../models/template_result_entity.dart';

TemplateResultEntity $TemplateResultEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final TemplateResultEntity templateResultEntity = TemplateResultEntity();
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    templateResultEntity.img = img;
  }
  final int? releaseId = jsonConvert.convert<int>(json['releaseId']);
  if (releaseId != null) {
    templateResultEntity.releaseId = releaseId;
  }
  final int? configId = jsonConvert.convert<int>(json['configId']);
  if (configId != null) {
    templateResultEntity.configId = configId;
  }
  final String? author = jsonConvert.convert<String>(json['author']);
  if (author != null) {
    templateResultEntity.author = author;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    templateResultEntity.sex = sex;
  }
  final int? isPackage = jsonConvert.convert<int>(json['isPackage']);
  if (isPackage != null) {
    templateResultEntity.isPackage = isPackage;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    templateResultEntity.type = type;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    templateResultEntity.title = title;
  }
  final String? tplId = jsonConvert.convert<String>(json['tplId']);
  if (tplId != null) {
    templateResultEntity.tplId = tplId;
  }
  final int? moreTpl = jsonConvert.convert<int>(json['moreTpl']);
  if (moreTpl != null) {
    templateResultEntity.moreTpl = moreTpl;
  }
  return templateResultEntity;
}

// Serialization function: Converts a TemplateResultEntity object into a JSON map.
// 序列化函数：将 TemplateResultEntity 对象转换为 JSON map。
Map<String, dynamic> $TemplateResultEntityToJson(TemplateResultEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['img'] = entity.img;
  data['releaseId'] = entity.releaseId;
  data['configId'] = entity.configId;
  data['author'] = entity.author;
  data['sex'] = entity.sex;
  data['isPackage'] = entity.isPackage;
  data['type'] = entity.type;
  data['title'] = entity.title;
  data['tplId'] = entity.tplId;
  data['moreTpl'] = entity.moreTpl;
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
