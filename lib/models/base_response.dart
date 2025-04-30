import 'package:aicamera/generated/json/base/json_convert_content.dart';
import 'package:aicamera/generated/json/logo_entity.g.dart';
import 'package:aicamera/models/category_entity_result.dart';
import 'package:aicamera/models/category_sub_entity_result.dart';
import 'package:aicamera/models/photo_entity.dart';
import 'package:aicamera/models/template_result_entity.dart';
import 'dart:convert';

import 'logo_entity.dart';


class BaseResponseList<T> {
  BaseResponseList({
    num? code,
    List<T>? data,
    String? msg,
  }) {
    _code = code;
    _data = data;
    _msg = msg;
  }

  // BaseResponseList.fromJson(dynamic json) {
  //   // _code = json['code'];
  //   print("#@@@@@@@@@@@@@@@@@@@@@@"+json["code"]);
  //   _code = json['code'] is int ? json['code'] as int : int.tryParse(json["code"]) ?? 0 ;
  //   if (json["data"] != null) {
  //     _data = JsonConvert.fromJsonAsT<List<T>>(json["data"]);
  //     _data = [];
  //     json['data'].forEach((v) {
  //       dynamic bean = _convertBean(data, v);
  //       if(bean != null) {
  //         _data?.add(bean);
  //       } else {
  //         _data?.add(v);
  //       }
  //     });
  //   }
  //   _msg = json['msg'];
  // }


  // BaseResponseList.fromJson(dynamic jsonString) {
  //   // ============ 处理 code 字段 ============
  //   // 1. 添加空值保护
  //   Map<String, dynamic> jsonObject = json.decode(jsonString);
  //   final dynamic codeValue = jsonObject['code'];
  //   _code = _safeParseCode(codeValue);
  //   print("#@BaseResponseList.fromJson Parsed code: $_code (原始值类型: ${codeValue.runtimeType})");
  //   // ============ 处理 data 字段 ============
  //   _data = [];
  //   if (jsonObject['data'] != null) {
  //     if(jsonObject['data'] is List) {
  //       final List<dynamic> rawList = jsonObject['data'] as List<dynamic>;
  //       _parseList(rawList);
  //       for (var v in rawData) {
  //         try {
  //           // 2. 统一使用泛型转换方法
  //           final T? bean = JsonConvert.fromJsonAsT<T>(v);
  //           if (bean != null) {
  //             _data!.add(bean);
  //           } else {
  //             print("#@ 数据项转换失败: ${v.runtimeType}");
  //           }
  //         } catch (e, stackTrace) {
  //           print("#@ 数据项解析异常: $e");
  //           print("#@ 堆栈跟踪: $stackTrace");
  //         }
  //       }
  //     }// 新增处理单个实体对象的逻辑
  //     else if (jsonObject['data'] is Map<String, dynamic>) {
  //       try {
  //         final T? bean = JsonConvert.fromJsonAsT<T>(jsonObject['data']);
  //         if (bean != null) {
  //           _data!.add(bean);
  //         } else {
  //           print("#@ 单对象转换失败: ${jsonObject['data'].runtimeType}");
  //         }
  //       } catch (e, stackTrace) {
  //         print("#@ 单对象解析异常: $e");
  //         print("#@ 堆栈跟踪: $stackTrace");
  //       }
  //     }
  //    // 兼容其他意外类型
  //     else if (jsonObject['data'] != null) {
  //       print("#@ 未知数据类型: ${jsonObject['data'].runtimeType}");
  //     }
  //
  //   } else {
  //     print("#@ data 字段不存在或非列表类型");
  //   }
  //
  //   // ============ 处理 msg 字段 ============
  //   _msg = jsonObject['msg']?.toString() ?? '未知消息';
  // }

  BaseResponseList.fromJson(dynamic jsonString) {
    final jsonObject = _parseToMap(jsonString);

    // ============ 解析基础字段 ============
    _code = _safeParseCode(jsonObject['code']);
    _msg = jsonObject['msg']?.toString() ?? '未知消息';

    // ============ 多结构data解析 ============
    _data = [];
    final dynamic dataField = jsonObject['data'];

    if (dataField != null) {
      // 情况1：data是List类型
      if (dataField is List) {
        _processList(dataField);
      }
      // 情况2：data是Map类型
      else if (dataField is Map<String, dynamic>) {
        // 优先处理menuList字段
        if (dataField['menuList'] is List) {
          _processmenuList(dataField['menuList']!);
        }
        // 处理categorys字段（示例）
        else if (dataField['categorys'] is List) {
          _processCategorySubList(dataField['categorys']!);
        }
        // 处理categorys字段（示例）
        else if (dataField['pageModel']["list"] is List) {
          _processTemplateList(dataField['pageModel']["list"]!);
        }

        // 其他Map结构处理
        else {
          _processMap(dataField);
        }
      }
      // 情况3：其他类型
      else {
        print('[WARNING] 未知的data字段类型: ${dataField.runtimeType}');
      }
    }
  }


  static Map<String, dynamic> _parseToMap(dynamic jsonString) {
    try {
      if (jsonString is String) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      if (jsonString is Map<String, dynamic>) {
        return jsonString;
      }
      throw FormatException('不支持的JSON格式');
    } catch (e) {
      print('[ERROR] JSON解析失败: $e');
      return {};
    }
  }

  // 处理List类型数据
  void _processList(List<dynamic> list) {
    for (var item in list) {
      try {
        final parsed = _parseItem(item);
        if (parsed != null) _data!.add(parsed);
      } catch (e, stack) {
        print('[ERROR] 列表项解析失败: $e\n数据: $item\n堆栈: $stack');
      }
    }
  }
  // 处理List类型数据
  void _processmenuList(List<dynamic> list) {
    for (var item in list) {
      try {
        final parsed =  CategoryEntityResult.fromJson(item);
        if (parsed != null) _data!.add(parsed as T);
      } catch (e, stack) {
        print('[ERROR] 分类列表项解析失败: $e\n数据: $item\n堆栈: $stack');
      }
    }
  }
  // 处理List类型数据
  void _processCategorySubList(List<dynamic> list) {
    for (var item in list) {
      try {
        final parsed = CategorySubEntityResult.fromJson(item);
        if (parsed != null) _data!.add(parsed as T);
      } catch (e, stack) {
        print('[ERROR] 子分类列表项解析失败: $e\n数据: $item\n堆栈: $stack');
      }
    }
  }
  // 处理模板List类型数据
  void _processTemplateList(List<dynamic> list) {
    for (var item in list) {
      try {
        final parsed = TemplateResultEntity.fromJson(item);
        if (parsed != null) _data!.add(parsed as T);
      } catch (e, stack) {
        print('[ERROR] 模板列表项解析失败: $e\n数据: $item\n堆栈: $stack');
      }
    }
  }  // 处理Map类型数据
  void _processMap(Map<String, dynamic> map) {
    try {
      // 尝试直接转换整个Map为对象
      final parsed = _parseItem(map);
      if (parsed != null) _data!.add(parsed);
    } catch (e) {
      print('[WARNING] Map结构转换失败: ${map.keys}');
    }
  }

  // 通用项解析
  T? _parseItem(dynamic item) {
    try {
      // 自动处理两种常见格式：
      // 1. 项本身就是目标类型
      if (item is T) return item;

      // 2. 项是需要转换的Map
      if (item is Map<String, dynamic>) {
        return JsonConvert.fromJsonAsT<T>(item);
      }

      print('[WARNING] 非常规数据项类型: ${item.runtimeType}');
      return null;
    } catch (e) {
      print('[ERROR] 数据项转换失败: ${T.toString()}');
      return null;
    }
  }

  // ============ 类型安全转换方法 ============
  static int _safeParseCode(dynamic value) {
    try {
      // 覆盖所有可能的类型情况
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    } catch (e) {
      print("#@ code 字段解析失败: $value (类型: ${value.runtimeType})");
      return 0; // 确保最终返回合法整数值
    }
  }
  num? _code;
  List<T>? _data;
  String? _msg;
  BaseResponseList copyWith({
    num? code,
    List<T>? data,
    String? msg,
  }) =>
      BaseResponseList(
        code: code ?? _code,
        data: data ?? _data,
        msg: msg ?? _msg,
      );
  num? get code => _code;
  List<T>? get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data?.map((v){
        Map<String, dynamic> json =  _convertJson(T,v);
        if(json.isNotEmpty) {
          return json;
        }
        return  v;
      }).toList();
    }
    map['msg'] = _msg;
    return map;
  }
}

class BaseResponseEntity<T> {
  final num? code;
  final T? data;
  final String? msg;
  BaseResponseEntity({this.code, this.data, this.msg});

  factory BaseResponseEntity.fromJson(dynamic json , T Function(dynamic) fromJsonT) {
    try {
      final dynamic decoded = json is String ? jsonDecode(json) : json;
      if (decoded == null) throw FormatException("Null response received");
      if (decoded is! Map<String, dynamic>) {
        throw FormatException("Expected Map<String, dynamic> but got ${decoded.runtimeType}");
      }
      // print('BaseResponseEntity原始响应runtimeType: ${decoded.runtimeType}');
      // print('BaseResponseEntity原始响应内容: $decoded');
      // print(fromJsonT(decoded['data']));
      // print('decoded["data"] type: ${decoded["data"]?.runtimeType}');
      final entity = BaseResponseEntity<T>(
        code: decoded['code'] as num?,
        data: decoded['data'] != null ?  fromJsonT(decoded['data']) : null,
        msg: decoded['msg'] as String?,
      );
      print('Parsed BaseResponseEntity: code=${entity.code}, data=${entity.data}, msg=${entity.msg}');
      return entity;
    } catch (e) {
    throw FormatException("Failed to parse BaseResponseEntity11: $e");
    }
  }

  Future<BaseResponseEntity<T>> fromJsonFuture(dynamic jsonData) async {
    try {
      print('原始响应runtimeType: ${jsonData.runtimeType}');
      print('原始响应内容: $jsonData');
      if (jsonData == null) {
        print("#@ data 字段为 null");
        return BaseResponseEntity<T>(
          code: null,
          data: null,
          msg: "Received null response",
        );
      }
      // If jsonData is a String, decode it; otherwise, assume it's a Map
      final Map<String, dynamic> dataMap = jsonData is String ? jsonDecode(jsonData) : jsonData as Map<String, dynamic>;
      return BaseResponseEntity<T>(
        code: dataMap['code'] as num?,
        data: dataMap['data'] != null ? LogoEntity.fromJson(dataMap['data']) as T : null,
        msg: dataMap['msg'] as String?,
      );
    } catch (e, stackTrace) {
      print("#@ 实体对象解析异常: $e");
      print("#@ 堆栈跟踪: $stackTrace");
      rethrow; // Or handle the error as needed
    }
  }

// Future<BaseResponseEntity<LogoEntity>> fromJsonFuture(dynamic jsonString) async {
//     print('原始响应runtimeType: ${jsonString.runtimeType}');
//     print('原始响应jsonString.data内容: ${jsonString.data}');
//     Map<String, dynamic> jsonObject = json.decode(jsonString);
//     print('原始jsonString响应内容: ${jsonObject}');
//     final dynamic codeValue = jsonObject['code'];
//     final code = _safeParseCode(codeValue);
//     print("#@ Parsed code: $code (原始值类型: ${codeValue.runtimeType})");
//
//     // dynamic ? data;
//     if (jsonObject['data'] != null) {
//       try {
//         final dynamic jsonData = jsonObject['data'];
//         print('原始响应: ${jsonData.runtimeType}');
//         print('原始响应内容: ${jsonData.data}');
//         // data = await JsonConvert.fromJsonAsT<T>(jsonData);
//         if (jsonData == null) {
//           print("#@ 实体对象转换失败: ${jsonData.runtimeType}");
//         }
//       } catch (e, stackTrace) {
//         print("#@ 实体对象解析异常: $e");
//         print("#@ 堆栈跟踪: $stackTrace");
//       }
//     } else {
//       print("#@ data 字段不存在");
//     }
//
//     final msg = jsonObject['msg']?.toString() ?? '未知消息';
//     return BaseResponseEntity<LogoEntity>(
//       code: code,
//       data: LogoEntity.fromJson(jsonObject["data"]),
//       msg: msg,
//     );
//   }

  // BaseResponseEntity.fromJson(dynamic jsonString) {
  //   // ============ 处理 code 字段 ============
  //   Map<String, dynamic> jsonObject = json.decode(jsonString);
  //   final dynamic codeValue = jsonObject['code'];
  //   _code = _safeParseCode(codeValue);
  //   print("#@ Parsed code: $_code (原始值类型: ${codeValue.runtimeType})");
  //
  //   // ============ 处理 data 字段 ============
  //   if (jsonObject['data'] != null) {
  //     try {
  //       // 直接解析为单个实体对象
  //       // if (jsonObject['data'] is Map<String, dynamic>)
  //
  //       _data = JsonConvert.fromJsonAsT<T>(jsonObject['data']);
  //       if (_data == null) {
  //         print("#@ 实体对象转换失败: ${jsonObject['data'].runtimeType}");
  //       }
  //     } catch (e, stackTrace) {
  //       print("#@ 实体对象解析异常: $e");
  //       print("#@ 堆栈跟踪: $stackTrace");
  //     }
  //   } else {
  //     print("#@ data 字段不存在");
  //   }
  //
  //   // ============ 处理 msg 字段 ============
  //   _msg = jsonObject['msg']?.toString() ?? '未知消息';
  // }

  // ============ 类型安全转换方法 ============
  static int _safeParseCode(dynamic value) {
    try {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    } catch (e) {
      print("#@ code 字段解析失败: $value (类型: ${value.runtimeType})");
      return 0;
    }
  }

  num? _code;
  T? _data;
  String? _msg;

  BaseResponseEntity copyWith({
    num? code,
    T? data,
    String? msg,
  }) =>
      BaseResponseEntity(
        code: code ?? _code,
        data: data ?? _data,
        msg: msg ?? _msg,
      );

  // num? get code => _code;
  // T? get data => _data;
  // String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      // 处理单个实体的转换
      final jsonData = _convertJson(_data);
      map['data'] = jsonData.isNotEmpty ? jsonData : _data;
    }
    map['msg'] = _msg;
    return map;
  }

  // 辅助方法：将实体转换为JSON
  Map<String, dynamic> _convertJson(dynamic entity) {
    // 这里需要根据实际情况实现实体转JSON的逻辑
    // 如果实体有toJson方法，可以直接调用
    if (entity is Map<String, dynamic>) {
      return entity;
    } else if (entity != null && entity is! Map) {
      try {
        return (entity as dynamic).toJson();
      } catch (e) {
        print("#@ 实体转JSON失败: $e");
        return {};
      }
    }
    return {};
  }
}


dynamic _convertBean(data,v){
  if(data is List<PhotoEntity>) {
     return PhotoEntity.fromJson(v);
  // }else if(data is List<FormulaTypeEntity>) {
  //   return FormulaTypeEntity.fromJson(v);
  // }else if(data is List<FormulaTypeTagEntity>) {
  //   return FormulaTypeTagEntity.fromJson(v);
  // }else if(data is List<CreateCupEntity>) {
  //   return CreateCupEntity.fromJson(v);
  // }else if(data is List<FormulaInfoStepEntity>) {
  //   return FormulaInfoStepEntity.fromJson(v);
  // }else if(data is List<FormulaTypeRecycleEntity>) {
  //   return FormulaTypeRecycleEntity.fromJson(v);
  }else {
    return data;
  }
}

Map<String, dynamic> _convertJson(T,v){
  if(T is PhotoEntity) {
    return (v as PhotoEntity).toJson();
  }else if(T is LogoEntity){
    return (v as LogoEntity).toJson();
  // }else if(T is FormulaTypeTagEntity){
  //   return (v as FormulaTypeTagEntity).toJson();
  // }else if(T is CreateCupEntity){
  //   return (v as CreateCupEntity).toJson();
  // }else if(T is FormulaInfoStepEntity){
  //   return (v as FormulaInfoStepEntity).toJson();
  // }else if(T is FormulaTypeRecycleEntity){
  //   return (v as FormulaTypeRecycleEntity).toJson();
  }else {
    return <String, dynamic>{};
  }
}

class BaseResponse<T> {
  BaseResponse({
    num? code,
    T? data,
    String? msg,}){
    _code = code;
    _data = data;
    _msg = msg;
  }

  BaseResponse.fromJson(dynamic json) {
    _code = json['code'];
    _data = json['data'];
    _msg = json['msg'];
  }
  num? _code;
  T? _data;
  String? _msg;
  BaseResponse copyWith({  num? code,
    dynamic data,
    String? msg,
  }) => BaseResponse(  code: code ?? _code,
    data: data ?? _data,
    msg: msg ?? _msg,
  );
  num? get code => _code;
  dynamic get data => _data;
  String? get msg => _msg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    map['data'] = _data;
    map['msg'] = _msg;
    return map;
  }

}





