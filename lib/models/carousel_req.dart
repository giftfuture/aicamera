import '../generated/json/carousel_req.g.dart';

class CarouselReq {
  late String type;
  late String source;
  late String deviceId;
  CarouselReq({
    required this.type , // 固定值1
    required this.source , // 原生线下机固定为14
    required this.deviceId, // 必须提供的设备ID
  });



  // Creates an instance from a JSON map
  factory CarouselReq.fromJson(Map<String, dynamic> json) =>
      $CarouselReqFromJson(json);

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => $CarouselReqToJson(this);

  // Creates a copy of the instance with updated fields
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
  // 转换方法
  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'source': source,
      'type': type,
    };
  }
  @override
  String toString() {
    return 'CarouselReq{type: $type, source: $source, deviceId: $deviceId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CarouselReq &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              source == other.source &&
              deviceId == other.deviceId;

  @override
  int get hashCode => type.hashCode ^ source.hashCode ^ deviceId.hashCode;
}