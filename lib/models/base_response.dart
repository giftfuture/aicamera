import 'package:aicamera/generated/json/base/json_convert_content.dart';
import 'package:aicamera/models/photo_entity.dart';
import 'dart:convert';


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


  BaseResponseList.fromJson(dynamic jsonString) {
    // ============ 处理 code 字段 ============
    // 1. 添加空值保护
    Map<String, dynamic> jsonObject = json.decode(jsonString);
    final dynamic codeValue = jsonObject['code'];
    _code = _safeParseCode(codeValue);
    print("#@ Parsed code: $_code (原始值类型: ${codeValue.runtimeType})");
    // ============ 处理 data 字段 ============
    _data = [];
    if (jsonObject['data'] != null && jsonObject['data'] is List) {
      final List<dynamic> rawData = jsonObject['data'] as List<dynamic>;
      for (var v in rawData) {
        try {
          // 2. 统一使用泛型转换方法
          final T? bean = JsonConvert.fromJsonAsT<T>(v);
          if (bean != null) {
            _data!.add(bean);
          } else {
            print("#@ 数据项转换失败: ${v.runtimeType}");
          }
        } catch (e, stackTrace) {
          print("#@ 数据项解析异常: $e");
          print("#@ 堆栈跟踪: $stackTrace");
        }
      }
    } else {
      print("#@ data 字段不存在或非列表类型");
    }

    // ============ 处理 msg 字段 ============
    _msg = jsonObject['msg']?.toString() ?? '未知消息';
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
  if(T is PhotoEntity){
    return (v as PhotoEntity).toJson();
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





