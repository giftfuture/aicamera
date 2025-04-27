// Import the generated part file
// Adjust the path if your generated files are in a different location
import '../generated/json/upload_entity.g.dart';

/// Represents the data entity for uploading.
class UploadEntity {
  String? imgPath; // Image file path (nullable)
  String? deviceId; // Device ID (nullable)
  String? source;   // Channel source (nullable)
  String? userId;   // User ID (nullable)
  String? type;     // Type parameter (nullable)

  // Constructor with named optional parameters for all fields
  UploadEntity({
    this.imgPath,
    this.deviceId,
    this.source,
    this.userId,
    this.type,
  });

  /// Creates an instance from a JSON map using the generated helper.
  factory UploadEntity.fromJson(Map<String, dynamic> json) =>
      $UploadEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated helper.
  Map<String, dynamic> toJson() => $UploadEntityToJson(this);

  /// Creates a copy of the instance with optionally updated fields.
  /// Follows the pattern from photo_entity.dart.
  UploadEntity copyWith({
    String? imgPath,
    String? deviceId,
    String? source,
    String? userId,
    String? type,
  }) {
    // Note: The constructor call here assumes the default constructor
    // initializes fields. If using factory/named constructors primarily,
    // adjust accordingly or use property assignment like in photo_entity.g.dart's copyWith.
    // This version directly uses the constructor for simplicity as fields are nullable.
    return UploadEntity(
      imgPath: imgPath ?? this.imgPath,
      deviceId: deviceId ?? this.deviceId,
      source: source ?? this.source,
      userId: userId ?? this.userId,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'UploadEntity{imgPath: $imgPath, deviceId: $deviceId, source: $source, userId: $userId, type: $type}';
  }

  // Optional: Add equality and hashCode for better object comparison if needed
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UploadEntity &&
              runtimeType == other.runtimeType &&
              imgPath == other.imgPath &&
              deviceId == other.deviceId &&
              source == other.source &&
              userId == other.userId &&
              type == other.type;

  @override
  int get hashCode =>
      imgPath.hashCode ^
      deviceId.hashCode ^
      source.hashCode ^
      userId.hashCode ^
      type.hashCode;
}

