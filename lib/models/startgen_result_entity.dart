// Assume this file is located at models/startgen_result_entity.dart
// 假设此文件位于 models/startgen_result_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/startgen_result_entity.g.dart';

/// Represents the data structure for the result of starting a generation task.
/// 表示启动生成任务结果的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class StartGenResultEntity {
  /// Unused parameter. Example: 0
  /// 暂不使用。示例: 0
  int? queue2;

  /// Unused parameter. Example: 100
  /// 暂不使用。示例: 100
  int? length;

  /// Generation record ID. Example: 48493
  /// 生成记录ID。示例: 48493
  int? id;

  /// Estimated completion timestamp (milliseconds). Example: 1732184911933
  /// 预估完成时间戳 (毫秒)。示例: 1732184911933
  int? finishedTs;

  /// Number of people in the queue (unused). Example: 0
  /// 排队人数 (暂不使用)。示例: 0
  int? queue;

  /// Status code (1 indicates success/passed validation). Example: 1
  /// 状态码 (1 表示通过校验)。示例: 1
  int? status;

  /// Server timestamp (milliseconds). Example: 1732184888969
  /// 服务器时间戳 (毫秒)。示例: 1732184888969
  int? ts;

  /// Default constructor.
  /// 默认构造函数。
  StartGenResultEntity({
    this.queue2,
    this.length,
    this.id,
    this.finishedTs,
    this.queue,
    this.status,
    this.ts,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory StartGenResultEntity.fromJson(Map<String, dynamic> json) =>
      $StartGenResultEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $StartGenResultEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  StartGenResultEntity copyWith({
    int? queue2,
    int? length,
    int? id,
    int? finishedTs,
    int? queue,
    int? status,
    int? ts,
  }) {
    return StartGenResultEntity(
      queue2: queue2 ?? this.queue2,
      length: length ?? this.length,
      id: id ?? this.id,
      finishedTs: finishedTs ?? this.finishedTs,
      queue: queue ?? this.queue,
      status: status ?? this.status,
      ts: ts ?? this.ts,
    );
  }

  @override
  String toString() {
    return 'StartGenResultEntity{queue2: $queue2, length: $length, id: $id, finishedTs: $finishedTs, queue: $queue, status: $status, ts: $ts}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StartGenResultEntity &&
              runtimeType == other.runtimeType &&
              queue2 == other.queue2 &&
              length == other.length &&
              id == other.id &&
              finishedTs == other.finishedTs &&
              queue == other.queue &&
              status == other.status &&
              ts == other.ts;

  @override
  int get hashCode =>
      queue2.hashCode ^
      length.hashCode ^
      id.hashCode ^
      finishedTs.hashCode ^
      queue.hashCode ^
      status.hashCode ^
      ts.hashCode;
}
