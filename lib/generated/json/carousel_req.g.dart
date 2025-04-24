import 'package:aicamera/generated/json/base/json_convert_content.dart';
import 'package:aicamera/models/carousel_req.dart';

CarouselReq $CarouselReqFromJson(Map<String, dynamic> json) {
  final CarouselReq carouselReq = CarouselReq(
    type: jsonConvert.convert<String>(json['type']) ?? '',
    source: jsonConvert.convert<String>(json['source']) ?? '',
    deviceId: jsonConvert.convert<String>(json['deviceId']) ?? '',
  );
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    carouselReq.type = type;
  }
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    carouselReq.source = source;
  }
  return carouselReq;
}

Map<String, dynamic> $CarouselReqToJson(CarouselReq entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['type'] = entity.type;
  data['source'] = entity.source;
  data['deviceId'] = entity.deviceId;
  return data;
}

extension CarouselReqExtension on CarouselReq {
  CarouselReq copyWith({
    String? type,
    String? source,
    String? deviceId,
  }) {
    return CarouselReq(
      type: type ?? this.type,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}