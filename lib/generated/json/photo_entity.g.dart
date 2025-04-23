import 'package:aicamera/generated/json/base/json_convert_content.dart';
import 'package:aicamera/models/photo_entity.dart';

PhotoEntity $PhotoEntityFromJson(Map<String, dynamic> json) {
  final PhotoEntity photoEntity = PhotoEntity();
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    photoEntity.img = img;
  }
  final int? mediaType = jsonConvert.convert<int>(json['mediaType']);
  if (mediaType != null) {
    photoEntity.mediaType = mediaType;
  }
  final int? tplConfigId = jsonConvert.convert<int>(json['tplConfigId']);
  if (tplConfigId != null) {
    photoEntity.tplConfigId = tplConfigId;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    photoEntity.type = type;
  }
  final String? tplId = jsonConvert.convert<String>(json['tplId']);
  if (tplId != null) {
    photoEntity.tplId = tplId;
  }
  return photoEntity;
}

Map<String, dynamic> $PhotoEntityToJson(PhotoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['img'] = entity.img;
  data['mediaType'] = entity.mediaType;
  data['tplConfigId'] = entity.tplConfigId;
  data['type'] = entity.type;
  data['tplId'] = entity.tplId;
  return data;
}

extension PhotoEntityExtension on PhotoEntity {
  PhotoEntity copyWith({
    String? img,
    int? mediaType,
    int? tplConfigId,
    String? type,
    String? tplId,
  }) {
    return PhotoEntity()
      ..img = img ?? this.img
      ..mediaType = mediaType ?? this.mediaType
      ..tplConfigId = tplConfigId ?? this.tplConfigId
      ..type = type ?? this.type
      ..tplId = tplId ?? this.tplId;
  }
}