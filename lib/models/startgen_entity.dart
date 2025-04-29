// Assume this file is located at models/startgen_entity.dart
// 假设此文件位于 models/startgen_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/startgen_entity.g.dart';

/// Represents the data structure for starting a generation task.
/// 表示启动生成任务的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class StartGenEntity {
  /// Source identifier (Channel). Example: "16"
  /// 来源标识符 (渠道)。示例: "16"
  String? source;

  /// Template ID. Example: "8959"
  /// 模板ID。示例: "8959"
  String? tplId;

  /// User face image URL. Example: "https://..."
  /// 用户人脸图URL。示例: "https://..."
  String? faceImgs;

  /// Gender identifier. Example: "0"
  /// 性别标识符。示例: "0"
  String? sex;

  /// Device identifier. Example: "4d0f..."
  /// 设备号。示例: "4d0f..."
  String? deviceId;

  /// Default constructor.
  /// 默认构造函数。
  StartGenEntity({
    this.source,
    this.tplId,
    this.faceImgs,
    this.sex,
    this.deviceId,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory StartGenEntity.fromJson(Map<String, dynamic> json) =>
      $StartGenEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $StartGenEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  StartGenEntity copyWith({
    String? source,
    String? tplId,
    String? faceImgs,
    String? sex,
    String? deviceId,
  }) {
    return StartGenEntity(
      source: source ?? this.source,
      tplId: tplId ?? this.tplId,
      faceImgs: faceImgs ?? this.faceImgs,
      sex: sex ?? this.sex,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  String toString() {
    return 'StartGenEntity{source: $source, tplId: $tplId, faceImgs: $faceImgs, sex: $sex, deviceId: $deviceId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StartGenEntity &&
              runtimeType == other.runtimeType &&
              source == other.source &&
              tplId == other.tplId &&
              faceImgs == other.faceImgs &&
              sex == other.sex &&
              deviceId == other.deviceId;

  @override
  int get hashCode =>
      source.hashCode ^
      tplId.hashCode ^
      faceImgs.hashCode ^
      sex.hashCode ^
      deviceId.hashCode;
}
