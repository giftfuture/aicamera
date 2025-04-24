import 'package:aicamera/generated/json/base/json_convert_content.dart';

import '../generated/json/logo_entity.g.dart';

import '../generated/json/logo_entity.g.dart';

class LogoEntity {
  int? ps;
  int? sourceZone;
  String? source;
  int? deviceId;
  String? version;
  String? logoUrl;

  LogoEntity({
    this.ps,
    this.sourceZone,
    this.source,
    this.deviceId,
    this.version,
    this.logoUrl,
  });




  // Creates an instance from a JSON map
  factory LogoEntity.fromJson(Map<String, dynamic> json) => $LogoEntityFromJson(json);

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => $LogoEntityToJson(this);

  // Creates a copy of the instance with updated fields
  LogoEntity copyWith({
    int? ps,
    int? sourceZone,
    String? source,
    int? deviceId,
    String? version,
    String? logoUrl,
  }) {
    return LogoEntity(
      ps: ps ?? this.ps,
      sourceZone: sourceZone ?? this.sourceZone,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
      version: version ?? this.version,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  @override
  String toString() {
    return 'LogoEntity{ps: $ps, sourceZone: $sourceZone, source: $source, deviceId: $deviceId, version: $version, logoUrl: $logoUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LogoEntity &&
              runtimeType == other.runtimeType &&
              ps == other.ps &&
              sourceZone == other.sourceZone &&
              source == other.source &&
              deviceId == other.deviceId &&
              version == other.version &&
              logoUrl == other.logoUrl;

  @override
  int get hashCode =>
      ps.hashCode ^
      sourceZone.hashCode ^
      source.hashCode ^
      deviceId.hashCode ^
      version.hashCode ^
      logoUrl.hashCode;
}
