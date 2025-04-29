// Assume this file is located at models/autogenpic_result.entity.dart
// 假设此文件位于 models/autogenpic_result.entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/autogenpic_result.entity.g.dart';
import '../generated/json/base/json_field.dart';

/// Represents the data structure for the AutoGenPic result response.
/// 表示 AutoGenPic 结果响应的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class AutoGenPicResultEntity {
  /// Generation record ID.
  /// 生成记录 ID。
  int? id;

  /// Estimated completion timestamp (milliseconds).
  /// 预估完成时间戳 (毫秒)。
  int? finishedTs;

  /// Number of people in the queue (currently unused).
  /// 排队人数 (暂不使用)。
  int? queue;

  /// Status code (1 indicates success).
  /// 状态码 (1 表示成功)。
  int? status;

  /// Server timestamp (milliseconds).
  /// 服务器时间戳 (毫秒)。
  int? ts;

  /// Default constructor.
  /// 默认构造函数。
  AutoGenPicResultEntity({
    this.id,
    this.finishedTs,
    this.queue,
    this.status,
    this.ts,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory AutoGenPicResultEntity.fromJson(Map<String, dynamic> json) =>
      $AutoGenPicResultEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $AutoGenPicResultEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  AutoGenPicResultEntity copyWith({
    int? id,
    int? finishedTs,
    int? queue,
    int? status,
    int? ts,
  }) {
    return AutoGenPicResultEntity(
      id: id ?? this.id,
      finishedTs: finishedTs ?? this.finishedTs,
      queue: queue ?? this.queue,
      status: status ?? this.status,
      ts: ts ?? this.ts,
    );
  }

  @override
  String toString() {
    return 'AutoGenPicResultEntity{id: $id, finishedTs: $finishedTs, queue: $queue, status: $status, ts: $ts}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AutoGenPicResultEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              finishedTs == other.finishedTs &&
              queue == other.queue &&
              status == other.status &&
              ts == other.ts;

  @override
  int get hashCode =>
      id.hashCode ^
      finishedTs.hashCode ^
      queue.hashCode ^
      status.hashCode ^
      ts.hashCode;
}
