// Assume this file is located at models/pay_result_entity.dart
// 假设此文件位于 models/pay_result_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/pay_result_entity.g.dart';

/// Represents the data structure for the payment result (e.g., WeChat Pay parameters).
/// 表示支付结果的数据结构 (例如微信支付参数)。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class PayResultEntity {
  /// Application ID (e.g., WeChat App ID). Example: "wx0b7a5dcc6fe601bf"
  /// 应用ID (例如微信 App ID)。示例: "wx0b7a5dcc6fe601bf"
  String? appId;

  /// Payment QR code URL or similar identifier. Example: "weixin://..."
  /// 支付二维码URL或类似标识符。示例: "weixin://..."
  String? codeUrl;

  /// Nonce string. Example: "fY2c6YMxajDhLxEh"
  /// 随机字符串。示例: "fY2c6YMxajDhLxEh"
  String? nonceStr;

  /// Order ID. Example: "1211556956760092672"
  /// 订单号。示例: "1211556956760092672"
  String? orderId;

  /// Package value (e.g., prepay_id for WeChat Pay). Example: "prepay_id=..."
  /// 包值 (例如微信支付的 prepay_id)。示例: "prepay_id=..."
  // @JsonKey(name: 'package') // Map 'package' JSON key to packageValue field
  String? packageValue;

  /// Payment signature. Example: "706FDD5B1D..."
  /// 支付签名。示例: "706FDD5B1D..."
  String? paySign;

  /// Signature type. Example: "MD5"
  /// 签名类型。示例: "MD5"
  String? signType;

  /// Timestamp. Example: "1730450894"
  /// 时间戳。示例: "1730450894"
  String? timeStamp;

  /// Default constructor.
  /// 默认构造函数。
  PayResultEntity({
    this.appId,
    this.codeUrl,
    this.nonceStr,
    this.orderId,
    this.packageValue, // Use the renamed field
    this.paySign,
    this.signType,
    this.timeStamp,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory PayResultEntity.fromJson(Map<String, dynamic> json) =>
      $PayResultEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $PayResultEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  PayResultEntity copyWith({
    String? appId,
    String? codeUrl,
    String? nonceStr,
    String? orderId,
    String? packageValue,
    String? paySign,
    String? signType,
    String? timeStamp,
  }) {
    return PayResultEntity(
      appId: appId ?? this.appId,
      codeUrl: codeUrl ?? this.codeUrl,
      nonceStr: nonceStr ?? this.nonceStr,
      orderId: orderId ?? this.orderId,
      packageValue: packageValue ?? this.packageValue,
      paySign: paySign ?? this.paySign,
      signType: signType ?? this.signType,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  @override
  String toString() {
    return 'PayResultEntity{appId: $appId, codeUrl: $codeUrl, nonceStr: $nonceStr, orderId: $orderId, packageValue: $packageValue, paySign: $paySign, signType: $signType, timeStamp: $timeStamp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PayResultEntity &&
              runtimeType == other.runtimeType &&
              appId == other.appId &&
              codeUrl == other.codeUrl &&
              nonceStr == other.nonceStr &&
              orderId == other.orderId &&
              packageValue == other.packageValue &&
              paySign == other.paySign &&
              signType == other.signType &&
              timeStamp == other.timeStamp;

  @override
  int get hashCode =>
      appId.hashCode ^
      codeUrl.hashCode ^
      nonceStr.hashCode ^
      orderId.hashCode ^
      packageValue.hashCode ^
      paySign.hashCode ^
      signType.hashCode ^
      timeStamp.hashCode;
}
