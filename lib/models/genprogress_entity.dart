// Assume this file is located at models/genprogress_entity.dart
// 假设此文件位于 models/genprogress_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/genprogress_entity.g.dart';

/// Represents the data structure for the generation progress/result.
/// 表示生成进度/结果的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class GenProgressEntity {
  /// Generated image URL (null or empty if still in progress). Example: "https://..."
  /// 生成结果图 (如果在进行中则为空字段)。示例: "https://..."
  String? img;

  /// Estimated remaining wait time in seconds (0 if finished). Example: 0
  /// 预计等待时间 (秒) (当任务还在进行中时，该值反应预计等待时间，完成后为0)。示例: 0
  int? waitSeconds;

  /// Type identifier. Example: 8
  /// 类型标识符。示例: 8
  int? type;

  /// Generation status (1: In Progress, 2: Generated). Example: 2
  /// 生成状态 (1: 进行中, 2: 已生成)。示例: 2
  int? status;

  /// Default constructor.
  /// 默认构造函数。
  GenProgressEntity({
    this.img,
    this.waitSeconds,
    this.type,
    this.status,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory GenProgressEntity.fromJson(Map<String, dynamic> json) =>
      $GenProgressEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $GenProgressEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  GenProgressEntity copyWith({
    String? img,
    int? waitSeconds,
    int? type,
    int? status,
  }) {
    return GenProgressEntity(
      img: img ?? this.img,
      waitSeconds: waitSeconds ?? this.waitSeconds,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'GenProgressEntity{img: $img, waitSeconds: $waitSeconds, type: $type, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GenProgressEntity &&
              runtimeType == other.runtimeType &&
              img == other.img &&
              waitSeconds == other.waitSeconds &&
              type == other.type &&
              status == other.status;

  @override
  int get hashCode =>
      img.hashCode ^
      waitSeconds.hashCode ^
      type.hashCode ^
      status.hashCode;
}
