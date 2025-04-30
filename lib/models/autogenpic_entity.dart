// Assume this file is located at models/autogenpic_entity.dart
// 假设此文件位于 models/autogenpic_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/autogenpic_entity.g.dart';
import '../generated/json/base/json_field.dart';

/// Represents the data structure for the autogenpic request/response.
/// 表示 autogenpic 请求/响应的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class AutoGenPicEntity {
  /// The image URL or identifier.
  /// 图片 URL 或标识符。
  String? img;

  /// Template ID.
  /// 模板 ID。
  String? tplid;

  /// Gender identifier (e.g., "0").
  /// 性别标识符 (例如 "0")。
  int? sex;

  /// Source identifier.
  /// 来源标识符。
  String? source;

  /// Device identifier.
  /// 设备标识符。
  String? deviceId;

  /// Default constructor.
  /// 默认构造函数。
  AutoGenPicEntity({
    this.img,
    this.tplid,
    this.sex,
    this.source,
    this.deviceId,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory AutoGenPicEntity.fromJson(Map<String, dynamic> json) =>
      $AutoGenPicEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $AutoGenPicEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  AutoGenPicEntity copyWith({
    String? img,
    String? tplid,
    int? sex,
    String? source,
    String? deviceId,
  }) {
    return AutoGenPicEntity(
      img: img ?? this.img,
      tplid: tplid ?? this.tplid,
      sex: sex ?? this.sex,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  String toString() {
    return 'AutoGenPicEntity{img: $img, tplid: $tplid, sex: $sex, source: $source, deviceId: $deviceId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AutoGenPicEntity &&
              runtimeType == other.runtimeType &&
              img == other.img &&
              tplid == other.tplid &&
              sex == other.sex &&
              source == other.source &&
              deviceId == other.deviceId;

  @override
  int get hashCode =>
      img.hashCode ^
      tplid.hashCode ^
      sex.hashCode ^
      source.hashCode ^
      deviceId.hashCode;
}
