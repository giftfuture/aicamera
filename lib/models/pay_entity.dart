// Assume this file is located at models/pay_entity.dart
// 假设此文件位于 models/pay_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/pay_entity.g.dart';

/// Represents the data structure for initiating a payment request.
/// 表示发起支付请求的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class PayEntity {
  /// Product type (e.g., 11: Reprint, 12: Generate Once, 13: Collect ID Photo). Example: "13"
  /// 商品类型 (例如, 11: 加印, 12: 生成一次, 13: 领取证件照)。示例: "13"
  String? productType;

  /// Product ID (Fixed value for single print). Example: "42"
  /// 商品ID (单张打印固定值)。示例: "42"
  String? productId;

  /// Source identifier (Channel). Example: "16"
  /// 来源标识符 (渠道)。示例: "16"
  String? source;

  /// Device identifier (Machine code). Example: "c814b..."
  /// 设备标识符 (机器编码)。示例: "c814b..."
  String? deviceId;

  /// Number of additional prints. Example: "1"
  /// 加打印张数。示例: "1"
  String? num;

  /// Record IDs (comma-separated). Example: "64273,i-11639"
  /// 记录ID (逗号分隔)。示例: "64273,i-11639"
  String? records;

  /// Default constructor.
  /// 默认构造函数。
  PayEntity({
    this.productType,
    this.productId,
    this.source,
    this.deviceId,
    this.num,
    this.records,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory PayEntity.fromJson(Map<String, dynamic> json) =>
      $PayEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $PayEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  PayEntity copyWith({
    String? productType,
    String? productId,
    String? source,
    String? deviceId,
    String? num,
    String? records,
  }) {
    return PayEntity(
      productType: productType ?? this.productType,
      productId: productId ?? this.productId,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
      num: num ?? this.num,
      records: records ?? this.records,
    );
  }

  @override
  String toString() {
    return 'PayEntity{productType: $productType, productId: $productId, source: $source, deviceId: $deviceId, num: $num, records: $records}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PayEntity &&
              runtimeType == other.runtimeType &&
              productType == other.productType &&
              productId == other.productId &&
              source == other.source &&
              deviceId == other.deviceId &&
              num == other.num &&
              records == other.records;

  @override
  int get hashCode =>
      productType.hashCode ^
      productId.hashCode ^
      source.hashCode ^
      deviceId.hashCode ^
      num.hashCode ^
      records.hashCode;
}
