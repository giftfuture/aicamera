// Import the generated part file. Adjust path as necessary.
import 'dart:convert';

import '../generated/login_result_entity.g.dart'; // For jsonEncode in toString

/// Represents the data entity received after a successful login or device info fetch.
/// 登录或设备信息获取成功后收到的数据实体。
class LoginResultEntity {
  /// Source zone identifier. Nullable.
  /// 源区域标识符。可为空。
  int? sourceZone;

  /// Background image URL or identifier. Nullable.
  /// 背景图片URL或标识符。可为空。
  String? background;

  /// Offline type indicator. Nullable.
  /// 离线类型指示符。可为空。
  int? offlineType;

  /// Unique identifier (e.g., for device or configuration). Nullable.
  /// 唯一标识符（例如设备或配置的ID）。可为空。
  int? id; // Made nullable for consistency, adjust if always required

  /// Source channel identifier. Nullable.
  /// 渠道来源标识符。可为空。
  String? source;

  /// Device identifier. Nullable.
  /// 设备标识符。可为空。
  String? deviceId;

  /// URL for the logo image. Nullable.
  /// Logo 图片的 URL。可为空。
  String? logoUrl;

  // Constructor with optional named parameters for all fields.
  // 包含所有字段的可选命名参数的构造函数。
  LoginResultEntity({
    this.sourceZone,
    this.background,
    this.offlineType,
    this.id,
    this.source,
    this.deviceId,
    this.logoUrl,
  });

  /// Creates an instance from a JSON map using the generated helper.
  /// 使用生成的辅助函数从 JSON map 创建实例。
  factory LoginResultEntity.fromJson(Map<String, dynamic> json) =>
      $LoginResultEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated helper.
  /// 使用生成的辅助函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $LoginResultEntityToJson(this);

  /// Creates a copy of the instance with optionally updated fields.
  /// 创建具有可选更新字段的实例副本。
  LoginResultEntity copyWith({
    int? sourceZone,
    String? background,
    int? offlineType,
    int? id,
    String? source,
    String? deviceId,
    String? logoUrl,
  }) {
    // Uses property assignment similar to photo_entity.g.dart's copyWith extension
    return LoginResultEntity()
      ..sourceZone = sourceZone ?? this.sourceZone
      ..background = background ?? this.background
      ..offlineType = offlineType ?? this.offlineType
      ..id = id ?? this.id
      ..source = source ?? this.source
      ..deviceId = deviceId ?? this.deviceId
      ..logoUrl = logoUrl ?? this.logoUrl;
  }

  @override
  String toString() {
    return 'LoginResultEntity{sourceZone: $sourceZone, background: $background, offlineType: $offlineType, id: $id, source: $source, deviceId: $deviceId, logoUrl: $logoUrl}';
  }

  // Optional: Add equality and hashCode for better object comparison if needed
  // 可选：如果需要，添加相等性和哈希码以便更好地进行对象比较
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LoginResultEntity &&
              runtimeType == other.runtimeType &&
              sourceZone == other.sourceZone &&
              background == other.background &&
              offlineType == other.offlineType &&
              id == other.id &&
              source == other.source &&
              deviceId == other.deviceId &&
              logoUrl == other.logoUrl;

  @override
  int get hashCode =>
      sourceZone.hashCode ^
      background.hashCode ^
      offlineType.hashCode ^
      id.hashCode ^
      source.hashCode ^
      deviceId.hashCode ^
      logoUrl.hashCode;
}
