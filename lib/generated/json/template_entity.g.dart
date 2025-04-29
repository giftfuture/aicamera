// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into a TemplateEntity object.
// 反序列化函数：将 JSON map 转换为 TemplateEntity 对象。
import '../../models/template_entity.dart';

TemplateEntity $TemplateEntityFromJson(Map<String, dynamic> json) {
  // Using a hypothetical jsonConvert helper for consistency:
  // 为保持一致性，使用假设的 jsonConvert 辅助工具：
  final TemplateEntity templateEntity = TemplateEntity();
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    templateEntity.source = source;
  }
  final String? categorys = jsonConvert.convert<String>(json['categorys']);
  if (categorys != null) {
    templateEntity.categorys = categorys;
  }
  final String? page = jsonConvert.convert<String>(json['page']);
  if (page != null) {
    templateEntity.page = page;
  }
  final String? pageSize = jsonConvert.convert<String>(json['pageSize']);
  if (pageSize != null) {
    templateEntity.pageSize = pageSize;
  }
  return templateEntity;
}

// Serialization function: Converts a TemplateEntity object into a JSON map.
// 序列化函数：将 TemplateEntity 对象转换为 JSON map。
Map<String, dynamic> $TemplateEntityToJson(TemplateEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['source'] = entity.source;
  data['categorys'] = entity.categorys;
  data['page'] = entity.page;
  data['pageSize'] = entity.pageSize;
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
    // Add specific type conversions if needed (e.g., int to String)
    // 如果需要，添加特定的类型转换（例如，int 到 String）
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
