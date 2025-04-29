// Assume this file is located at models/category_sub_entity.dart
// 假设此文件位于 models/category_sub_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件
import '../generated/json/base/json_field.dart';
import '../generated/json/category_sub_entity.g.dart';
import '../generated/json/category_sub_entity_result.g.dart';

/// Represents the data structure for the sub-category result.
/// 表示子分类结果的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class CategorySubEntity {
  /// Source identifier (Channel). Example: "14"
  /// 来源标识符 (渠道)。示例: "14"
  String? source;

  /// Included category IDs (comma-separated string). Example: "41,37,14,15,18,40,81"
  /// 包含的分类ID (逗号分隔的字符串)。示例: "41,37,14,15,18,40,81"
  String? categorys;

  /// Default constructor.
  /// 默认构造函数。
  CategorySubEntity({
    this.source,
    this.categorys,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory CategorySubEntity.fromJson(Map<String, dynamic> json) =>
      $CategorySubEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $CategorySubEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  CategorySubEntity copyWith({
    String? source,
    String? categorys,
  }) {
    return CategorySubEntity(
      source: source ?? this.source,
      categorys: categorys ?? this.categorys,
    );
  }

  @override
  String toString() {
    return 'CategorySubEntityResult{source: $source, categorys: $categorys}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategorySubEntity &&
              runtimeType == other.runtimeType &&
              source == other.source &&
              categorys == other.categorys;

  @override
  int get hashCode =>
      source.hashCode ^
      categorys.hashCode;
}
