// Assume this file is located at models/category_entity.dart
// 假设此文件位于 models/category_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/category_entity.g.dart';
import '../generated/json/base/json_field.dart';

/// Represents the data structure for category-related requests/responses.
/// 表示分类相关请求/响应的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class CategoryEntity {
  /// Source identifier (Channel). Example: "14"
  /// 来源标识符 (渠道)。示例: "14"
  String? source;

  /// Zone identifier. Example: "0"
  /// 分区标识符。示例: "0"
  String? zone;

  /// Version type (1: Landscape, 2: Portrait). Example: "1"
  /// 版本类型 (1: 横版, 2: 竖版)。示例: "1"
  String? versionType;

  /// Gender identifier. Example: "1"
  /// 性别标识符。示例: "1"
  int? sex;

  /// Device identifier. Example: "2c79fd470c61f7e2"
  /// 设备标识符。示例: "2c79fd470c61f7e2"
  String? deviceId;

  /// Default constructor.
  /// 默认构造函数。
  CategoryEntity({
    this.source,
    this.zone,
    this.versionType,
    this.sex,
    this.deviceId,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory CategoryEntity.fromJson(Map<String, dynamic> json) =>
      $CategoryEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $CategoryEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  CategoryEntity copyWith({
    String? source,
    String? zone,
    String? versionType,
    int? sex,
    String? deviceId,
  }) {
    return CategoryEntity(
      source: source ?? this.source,
      zone: zone ?? this.zone,
      versionType: versionType ?? this.versionType,
      sex: sex ?? this.sex,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  String toString() {
    return 'CategoryEntity{source: $source, zone: $zone, versionType: $versionType, sex: $sex, deviceId: $deviceId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryEntity &&
              runtimeType == other.runtimeType &&
              source == other.source &&
              zone == other.zone &&
              versionType == other.versionType &&
              sex == other.sex &&
              deviceId == other.deviceId;

  @override
  int get hashCode =>
      source.hashCode ^
      zone.hashCode ^
      versionType.hashCode ^
      sex.hashCode ^
      deviceId.hashCode;
}
