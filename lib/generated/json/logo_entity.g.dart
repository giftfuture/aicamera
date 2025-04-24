import '../../models/logo_entity.dart';
import 'package:aicamera/generated/json/base/json_convert_content.dart';

  LogoEntity $LogoEntityFromJson(Map<String, dynamic> json) {
    final LogoEntity logoEntity = LogoEntity();
    final int? ps = jsonConvert.convert<int>(json['ps']);
    if (ps != null) {
      logoEntity.ps = ps;
    }
    final int? sourceZone = jsonConvert.convert<int>(json['sourceZone']);
    if (sourceZone != null) {
      logoEntity.sourceZone = sourceZone;
    }
    final String? source = jsonConvert.convert<String>(json['source']);
    if (source != null) {
      logoEntity.source = source;
    }
    final int? deviceId = jsonConvert.convert<int>(json['deviceId']);
    if (deviceId != null) {
      logoEntity.deviceId = deviceId;
    }
    final String? version = jsonConvert.convert<String>(json['version']);
    if (version != null) {
      logoEntity.version = version;
    }
    final String? logoUrl = jsonConvert.convert<String>(json['logoUrl']);
    if (logoUrl != null) {
      logoEntity.logoUrl = logoUrl;
    }
    return logoEntity;
  }

  Map<String, dynamic> $LogoEntityToJson(LogoEntity entity) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ps'] = entity.ps;
    data['sourceZone'] = entity.sourceZone;
    data['source'] = entity.source;
    data['deviceId'] = entity.deviceId;
    data['version'] = entity.version;
    data['logoUrl'] = entity.logoUrl;
    return data;
  }

  extension LogoEntityExtension on LogoEntity {
  LogoEntity copyWith({
    int? ps,
    int? sourceZone,
    String? source,
    int? deviceId,
    String? version,
    String? logoUrl,
  }) {
    return LogoEntity()
      ..ps = ps ?? this.ps
      ..sourceZone = sourceZone ?? this.sourceZone
      ..source = source ?? this.source
      ..deviceId = deviceId ?? this.deviceId
      ..version = version ?? this.version
      ..logoUrl = logoUrl ?? this.logoUrl;
  }
}
