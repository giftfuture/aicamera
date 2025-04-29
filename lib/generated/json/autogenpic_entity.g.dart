// GENERATED CODE - DO NOT MODIFY BY HAND


// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// Deserialization function: Converts a JSON map into an AutoGenPicEntity object.
// 反序列化函数：将 JSON map 转换为 AutoGenPicEntity 对象。
import '../../models/autogenpic_entity.dart';

AutoGenPicEntity $AutoGenPicEntityFromJson(Map<String, dynamic> json) {
  // Assuming you might use a helper like json_convert_content from your previous examples
  // 假设您可能使用像之前示例中的 json_convert_content 这样的辅助工具
  // If not using a helper, direct conversion would look like:
  // 如果不使用辅助工具，直接转换如下：
  // final String? img = json['img'] as String?;
  // final String? tplid = json['tplid'] as String?;
  // ... and so on.

  // Using a hypothetical jsonConvert helper for consistency with previous examples:
  // 为与先前示例保持一致，使用假设的 jsonConvert 辅助工具：
  final AutoGenPicEntity autoGenPicEntity = AutoGenPicEntity();
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    autoGenPicEntity.img = img;
  }
  final String? tplid = jsonConvert.convert<String>(json['tplid']);
  if (tplid != null) {
    autoGenPicEntity.tplid = tplid;
  }
  final String? sex = jsonConvert.convert<String>(json['sex']);
  if (sex != null) {
    autoGenPicEntity.sex = sex;
  }
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    autoGenPicEntity.source = source;
  }
  final String? deviceId = jsonConvert.convert<String>(json['deviceId']);
  if (deviceId != null) {
    autoGenPicEntity.deviceId = deviceId;
  }
  return autoGenPicEntity;
}

// Serialization function: Converts an AutoGenPicEntity object into a JSON map.
// 序列化函数：将 AutoGenPicEntity 对象转换为 JSON map。
Map<String, dynamic> $AutoGenPicEntityToJson(AutoGenPicEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['img'] = entity.img;
  data['tplid'] = entity.tplid;
  data['sex'] = entity.sex;
  data['source'] = entity.source;
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
    // Add specific type conversions if needed (e.g., int to String)
    // 如果需要，添加特定的类型转换（例如，int 到 String）
    if (T == String) return value.toString() as T?;
    // ... other types
    return value as T?; // Basic cast as fallback / 基本转换作为回退
  }
}
// --- End Helper Function Placeholder ---
