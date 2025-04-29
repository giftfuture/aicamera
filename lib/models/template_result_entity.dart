// Assume this file is located at models/template_result_entity.dart
// 假设此文件位于 models/template_result_entity.dart

// Import the generated part file which will contain the serialization logic
// 导入将包含序列化逻辑的生成部分文件

import '../generated/json/base/json_field.dart';
import '../generated/json/template_result_entity.g.dart';

/// Represents the data structure for a template result item.
/// 表示模板结果项目的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class TemplateResultEntity {
  /// Image URL. Example: "https://..."
  /// 图片URL。示例: "https://..."
  String? img;

  /// Release ID (0 if not user-uploaded). Example: 0
  /// 上传ID (如果不是用户上传的模板则为0)。示例: 0
  int? releaseId;

  /// Configuration ID. Example: 1118
  /// 上线配置ID。示例: 1118
  int? configId;

  /// Author name. Example: "Toller"
  /// 作者。示例: "Toller"
  String? author;

  /// Template gender (0: Female, 1: Male, 2: Both). Example: 0
  /// 模板对应性别 (0: 女, 1: 男, 2: 两者都包含)。示例: 0
  int? sex;

  /// Whether it's a package (0: No, 1: Yes). Example: 0
  /// 是否是生成包 (0: 否, 1: 是)。示例: 0
  int? isPackage;

  /// Generation type (1: AI Generate, 2: Beauty Direct Shot, 3: Upload Print). Example: 1
  /// 生成类型 (1: AI生成, 2: 美颜直拍, 3: 传图打印)。示例: 1
  int? type;

  /// Template title/name. Example: "休闲白底"
  /// 模板名。示例: "休闲白底"
  String? title;

  /// Template ID (String). Example: "2183"
  /// 模板ID (字符串)。示例: "2183"
  String? tplId;

  /// Indicates if there are more templates (0: No, 1: Yes). Example: 0
  /// 是否有更多模板 (0: 无, 1: 有)。示例: 0
  int? moreTpl;

  /// Default constructor.
  /// 默认构造函数。
  TemplateResultEntity({
    this.img,
    this.releaseId,
    this.configId,
    this.author,
    this.sex,
    this.isPackage,
    this.type,
    this.title,
    this.tplId,
    this.moreTpl,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory TemplateResultEntity.fromJson(Map<String, dynamic> json) =>
      $TemplateResultEntityFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $TemplateResultEntityToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  TemplateResultEntity copyWith({
    String? img,
    int? releaseId,
    int? configId,
    String? author,
    int? sex,
    int? isPackage,
    int? type,
    String? title,
    String? tplId,
    int? moreTpl,
  }) {
    return TemplateResultEntity(
      img: img ?? this.img,
      releaseId: releaseId ?? this.releaseId,
      configId: configId ?? this.configId,
      author: author ?? this.author,
      sex: sex ?? this.sex,
      isPackage: isPackage ?? this.isPackage,
      type: type ?? this.type,
      title: title ?? this.title,
      tplId: tplId ?? this.tplId,
      moreTpl: moreTpl ?? this.moreTpl,
    );
  }

  @override
  String toString() {
    return 'TemplateResultEntity{img: $img, releaseId: $releaseId, configId: $configId, author: $author, sex: $sex, isPackage: $isPackage, type: $type, title: $title, tplId: $tplId, moreTpl: $moreTpl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TemplateResultEntity &&
              runtimeType == other.runtimeType &&
              img == other.img &&
              releaseId == other.releaseId &&
              configId == other.configId &&
              author == other.author &&
              sex == other.sex &&
              isPackage == other.isPackage &&
              type == other.type &&
              title == other.title &&
              tplId == other.tplId &&
              moreTpl == other.moreTpl;

  @override
  int get hashCode =>
      img.hashCode ^
      releaseId.hashCode ^
      configId.hashCode ^
      author.hashCode ^
      sex.hashCode ^
      isPackage.hashCode ^
      type.hashCode ^
      title.hashCode ^
      tplId.hashCode ^
      moreTpl.hashCode;
}
