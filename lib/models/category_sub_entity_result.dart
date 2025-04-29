// Assume this file is located at models/category_sub_entity_result.dart
// 假设此文件位于 models/category_sub_entity_result.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/category_sub_entity.g.dart';
import '../generated/json/category_sub_entity_result.g.dart';

/// Represents the data structure for a sub-category item.
/// 表示子分类项目的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class CategorySubEntityResult {
  /// Included genders (0: Female, 1: Male, 2: Both). Example: 0
  /// 包含的性别 (0: 女, 1: 男, 2: 男女都包含)。示例: 0
  int? sex;

  /// Category name. Example: "嘟嘟王的朋友圈"
  /// 分类名。示例: "嘟嘟王的朋友圈"
  String? name;

  /// Category ID. Example: 81
  /// 分类ID。示例: 81
  int? id;

  /// Label type (0: Normal, 1: Hot, 2: New, ...). Example: 2
  /// 标签类型 (0: 普通, 1: 超火, 2: 新品, ...)。示例: 2
  int? label;

  /// Label name. Example: "新品"
  /// 标签名。示例: "新品"
  String? labelName;

  /// Default constructor.
  /// 默认构造函数。
  CategorySubEntityResult({
    this.sex,
    this.name,
    this.id,
    this.label,
    this.labelName,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory CategorySubEntityResult.fromJson(Map<String, dynamic> json) =>
      $CategorySubEntityResultFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $CategorySubEntityResultToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  CategorySubEntityResult copyWith({
    int? sex,
    String? name,
    int? id,
    int? label,
    String? labelName,
  }) {
    return CategorySubEntityResult(
      sex: sex ?? this.sex,
      name: name ?? this.name,
      id: id ?? this.id,
      label: label ?? this.label,
      labelName: labelName ?? this.labelName,
    );
  }

  @override
  String toString() {
    return 'CategorySubEntityResult{sex: $sex, name: $name, id: $id, label: $label, labelName: $labelName}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategorySubEntityResult &&
              runtimeType == other.runtimeType &&
              sex == other.sex &&
              name == other.name &&
              id == other.id &&
              label == other.label &&
              labelName == other.labelName;

  @override
  int get hashCode =>
      sex.hashCode ^
      name.hashCode ^
      id.hashCode ^
      label.hashCode ^
      labelName.hashCode;
}
