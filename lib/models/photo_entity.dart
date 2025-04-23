
import '../generated/json/photo_entity.g.dart';

class PhotoEntity {
  String? img;
  int? mediaType;
  int? tplConfigId;
  String? type;
  String? tplId;

  PhotoEntity({
    this.img,
    this.mediaType,
    this.tplConfigId,
    this.type,
    this.tplId,
  });

  // Creates an instance from a JSON map
  factory PhotoEntity.fromJson(Map<String, dynamic> json) =>
      $PhotoEntityFromJson(json);

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => $PhotoEntityToJson(this);

  // Creates a copy of the instance with updated fields
  PhotoEntity copyWith({
    String? img,
    int? mediaType,
    int? tplConfigId,
    String? type,
    String? tplId,
  }) {
    return PhotoEntity(
      img: img ?? this.img,
      mediaType: mediaType ?? this.mediaType,
      tplConfigId: tplConfigId ?? this.tplConfigId,
      type: type ?? this.type,
      tplId: tplId ?? this.tplId,
    );
  }

  @override
  String toString() {
    return 'PhotoEntity{img: $img, mediaType: $mediaType, tplConfigId: $tplConfigId, type: $type, tplId: $tplId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PhotoEntity &&
              runtimeType == other.runtimeType &&
              img == other.img &&
              mediaType == other.mediaType &&
              tplConfigId == other.tplConfigId &&
              type == other.type &&
              tplId == other.tplId;

  @override
  int get hashCode =>
      img.hashCode ^
      mediaType.hashCode ^
      tplConfigId.hashCode ^
      type.hashCode ^
      tplId.hashCode;
}