// Assume this file is located at models/template_entity.dart
// 假设此文件位于 models/template_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/template_entity.g.dart';

/// Represents the data structure for requesting templates.
/// 表示请求模板的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class TemplateEntity {
  /// Source identifier (Channel). Example: "14"
  /// 来源标识符 (渠道)。示例: "14"
  String? source;

  /// Sub-category ID(s). Example: "45"
  /// 子分类ID。示例: "45"
  String? categorys;

  /// Page number for pagination. Example: "1"
  /// 分页的页码。示例: "1"
  String? page;

  /// Number of items per page. Example: "100"
  /// 每页的项目数。示例: "100"
  String? pageSize;

  /// Default constructor.
  /// 默认构造函数。
  TemplateEntity({
    this.source,
    this.categorys,
    this.page,
    this.pageSize,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory TemplateEntity.fromJson(Map<String, dynamic> json) =>
      $TemplateEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $TemplateEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  TemplateEntity copyWith({
    String? source,
    String? categorys,
    String? page,
    String? pageSize,
  }) {
    return TemplateEntity(
      source: source ?? this.source,
      categorys: categorys ?? this.categorys,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  String toString() {
    return 'TemplateEntity{source: $source, categorys: $categorys, page: $page, pageSize: $pageSize}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TemplateEntity &&
              runtimeType == other.runtimeType &&
              source == other.source &&
              categorys == other.categorys &&
              page == other.page &&
              pageSize == other.pageSize;

  @override
  int get hashCode =>
      source.hashCode ^
      categorys.hashCode ^
      page.hashCode ^
      pageSize.hashCode;
}
