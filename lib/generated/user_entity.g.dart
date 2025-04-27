
import '../models/user_entity.dart';
import 'json/base/json_convert_content.dart';

UserEntity $UserEntityFromJson(Map<String, dynamic> json) {
  final UserEntity userEntity = UserEntity();
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    userEntity.username = username;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    userEntity.nickname = nickname;
  }
  final dynamic remark = json['remark'];
  if (remark != null) {
    userEntity.remark = remark;
  }
  final dynamic deptId = json['deptId'];
  if (deptId != null) {
    userEntity.deptId = deptId;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    userEntity.email = email;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    userEntity.mobile = mobile;
  }
  final int? sex = jsonConvert.convert<int>(json['sex']);
  if (sex != null) {
    userEntity.sex = sex;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    userEntity.avatar = avatar;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    userEntity.id = id;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    userEntity.status = status;
  }
  final String? loginIp = jsonConvert.convert<String>(json['loginIp']);
  if (loginIp != null) {
    userEntity.loginIp = loginIp;
  }
  final int? loginDate = jsonConvert.convert<int>(json['loginDate']);
  if (loginDate != null) {
    userEntity.loginDate = loginDate;
  }
  final int? createTime = jsonConvert.convert<int>(json['createTime']);
  if (createTime != null) {
    userEntity.createTime = createTime;
  }
  return userEntity;
}

Map<String, dynamic> $UserEntityToJson(UserEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['username'] = entity.username;
  data['nickname'] = entity.nickname;
  data['remark'] = entity.remark;
  data['deptId'] = entity.deptId;
  data['email'] = entity.email;
  data['mobile'] = entity.mobile;
  data['sex'] = entity.sex;
  data['avatar'] = entity.avatar;
  data['id'] = entity.id;
  data['status'] = entity.status;
  data['loginIp'] = entity.loginIp;
  data['loginDate'] = entity.loginDate;
  data['createTime'] = entity.createTime;
  return data;
}

extension UserEntityExtension on UserEntity {
  UserEntity copyWith({
    String? username,
    String? nickname,
    dynamic remark,
    dynamic deptId,
    List<dynamic>? postIds,
    String? email,
    String? mobile,
    int? sex,
    String? avatar,
    int? id,
    int? status,
    String? loginIp,
    int? loginDate,
    int? createTime,
    dynamic dept,
  }) {
    return UserEntity()
      ..username = username ?? this.username
      ..nickname = nickname ?? this.nickname
      ..remark = remark ?? this.remark
      ..deptId = deptId ?? this.deptId
      ..email = email ?? this.email
      ..mobile = mobile ?? this.mobile
      ..sex = sex ?? this.sex
      ..avatar = avatar ?? this.avatar
      ..id = id ?? this.id
      ..status = status ?? this.status
      ..loginIp = loginIp ?? this.loginIp
      ..loginDate = loginDate ?? this.loginDate
      ..createTime = createTime ?? this.createTime;
  }
}