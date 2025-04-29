// Assume this file is located at models/category_entity_result.dart
// 假设此文件位于 models/category_entity_result.dart

// Import the generated part file which will contain the serialization logic

import '../generated/json/base/json_field.dart';
import '../generated/json/category_entity_result.g.dart';

/// Represents the data structure for the category result/details.
/// 表示分类结果/详情的数据结构。
// Add the annotation for the generator (e.g., json_serializable)
// 为生成器添加注解 (例如 json_serializable)
@JsonSerializable()
class CategoryEntityResult {
  /// Included category IDs (comma-separated string if multiple). Example: "45"
  /// 包含的分类ID (如果是多个，则为逗号分隔的字符串)。示例: "45"
  String? categorys;

  /// Whether it's a COS category (0 for false, 1 for true). Example: 0
  /// 是否是cos分类 (0为否, 1为是)。示例: 0
  int? isCos;

  /// Image URL for the category. Example: "https://..."
  /// 分类的图片地址。示例: "https://..."
  String? img;

  /// Price in cents (or smallest unit). Example: 0.01 (Note: Ensure backend sends as number)
  /// 价格 (单位：分或最小单位)。示例: 0.01 (注意: 确保后端发送的是数字类型)
  double? price;

  /// Included genders (0: Female only, 1: Male only, 2: Both). Example: 2
  /// 包含的性别 (0: 只有女, 1: 只有男, 2: 两者都包含)。示例: 2
  int? sex;

  /// Menu/Category name. Example: "证件照"
  /// 菜单/分类名。示例: "证件照"
  String? name;

  /// Menu/Category ID. Example: 37
  /// 菜单/分类ID。示例: 37
  int? id;

  /// Label type (0: Normal, 1: Hot, 2: New, ...). Example: 1
  /// 标签类型 (0: 普通, 1: 热门, 2: 新品, ...)。示例: 1
  int? label;

  /// Type identifier (1: AI Generate, 2: Beauty Direct Shot, 3: Upload Print). Example: 1
  /// 类型标识符 (1: AI生成, 2: 美颜直拍, 3: 传图打印)。示例: 1
  int? type;

  /// Default constructor.
  /// 默认构造函数。
  CategoryEntityResult({
    this.categorys,
    this.isCos,
    this.img,
    this.price,
    this.sex,
    this.name,
    this.id,
    this.label,
    this.type,
  });

  /// Creates an instance from a JSON map using the generated function.
  /// 使用生成的函数从 JSON map 创建实例。
  factory CategoryEntityResult.fromJson(Map<String, dynamic> json) =>
      $CategoryEntityResultFromJson(json);

  /// Converts the instance to a JSON map using the generated function.
  /// 使用生成的函数将实例转换为 JSON map。
  Map<String, dynamic> toJson() => $CategoryEntityResultToJson(this);

  /// Creates a copy of the instance with potentially updated fields.
  /// 创建具有可能更新字段的实例副本。
  CategoryEntityResult copyWith({
    String? categorys,
    int? isCos,
    String? img,
    double? price,
    int? sex,
    String? name,
    int? id,
    int? label,
    int? type,
  }) {
    return CategoryEntityResult(
      categorys: categorys ?? this.categorys,
      isCos: isCos ?? this.isCos,
      img: img ?? this.img,
      price: price ?? this.price,
      sex: sex ?? this.sex,
      name: name ?? this.name,
      id: id ?? this.id,
      label: label ?? this.label,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'CategoryEntityResult{categorys: $categorys, isCos: $isCos, img: $img, price: $price, sex: $sex, name: $name, id: $id, label: $label, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CategoryEntityResult &&
              runtimeType == other.runtimeType &&
              categorys == other.categorys &&
              isCos == other.isCos &&
              img == other.img &&
              price == other.price &&
              sex == other.sex &&
              name == other.name &&
              id == other.id &&
              label == other.label &&
              type == other.type;

  @override
  int get hashCode =>
      categorys.hashCode ^
      isCos.hashCode ^
      img.hashCode ^
      price.hashCode ^
      sex.hashCode ^
      name.hashCode ^
      id.hashCode ^
      label.hashCode ^
      type.hashCode;
}
