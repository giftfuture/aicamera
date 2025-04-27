// Import the generated part file. Adjust the path as needed.
import '../generated/json/upload_result_entity.g.dart';
import 'dart:convert'; // Import for jsonEncode in toString if needed

/// Represents the result entity after an upload, containing analysis data.
class UploadResultEntity {
  /// Face rectangle coordinates [x_min, y_min, x_max, y_max]. Nullable.
  List<int>? faceRec;

  /// URL for the cropped "ins" style image. Nullable.
  String? insUrl;

  /// Check result for "ins" photo distance (true = pass, false = too close). Nullable.
  bool? insFacePorpCheak; // Note: Original key had a typo 'Porp', kept for consistency if API uses it

  /// Detected gender (0 = female, 1 = male). Nullable.
  int? sex;

  /// Original image URL. Nullable.
  String? url;

  /// Detected age. Nullable.
  int? age;

  /// Status code (1 = validation passed). Nullable.
  int? status;

  // Default constructor with optional named parameters
  UploadResultEntity({
    this.faceRec,
    this.insUrl,
    this.insFacePorpCheak,
    this.sex,
    this.url,
    this.age,
    this.status,
  });

  /// Creates an instance from a JSON map using the generated helper.
  factory UploadResultEntity.fromJson(Map<String, dynamic> json) =>
      $UploadResultEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated helper.
  Map<String, dynamic> toJson() => $UploadResultEntityToJson(this);

  /// Creates a copy of the instance with optionally updated fields.
  UploadResultEntity copyWith({
    List<int>? faceRec,
    String? insUrl,
    bool? insFacePorpCheak,
    int? sex,
    String? url,
    int? age,
    int? status,
  }) {
    // Uses property assignment similar to photo_entity.g.dart's copyWith extension
    return UploadResultEntity()
      ..faceRec = faceRec ?? this.faceRec
      ..insUrl = insUrl ?? this.insUrl
      ..insFacePorpCheak = insFacePorpCheak ?? this.insFacePorpCheak
      ..sex = sex ?? this.sex
      ..url = url ?? this.url
      ..age = age ?? this.age
      ..status = status ?? this.status;
  }

  @override
  String toString() {
    // Use jsonEncode for a more readable representation of the list
    return 'UploadResultEntity{faceRec: ${jsonEncode(faceRec)}, insUrl: $insUrl, insFacePorpCheak: $insFacePorpCheak, sex: $sex, url: $url, age: $age, status: $status}';
  }

  // Optional: Add equality and hashCode for better object comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UploadResultEntity &&
              runtimeType == other.runtimeType &&
              // Consider using DeepCollectionEquality().equals for lists
              faceRec == other.faceRec &&
              insUrl == other.insUrl &&
              insFacePorpCheak == other.insFacePorpCheak &&
              sex == other.sex &&
              url == other.url &&
              age == other.age &&
              status == other.status;

  @override
  int get hashCode =>
      // Consider using DeepCollectionEquality().hash for lists
  faceRec.hashCode ^
  insUrl.hashCode ^
  insFacePorpCheak.hashCode ^
  sex.hashCode ^
  url.hashCode ^
  age.hashCode ^
  status.hashCode;
}
