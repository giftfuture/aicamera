import 'dart:convert';

import '../generated/json/base/json_field.dart';
import '../generated/user_entity.g.dart';

@JsonSerializable()
class UserEntity {
	String? username;
	String? nickname;
	dynamic remark;
	dynamic deptId;
	String? email;
	String? mobile;
	int? sex;
	String? avatar;
	int? id;
	int? status;
	String? loginIp;
	int? loginDate;
	int? createTime;

	UserEntity();

	factory UserEntity.fromJson(Map<String, dynamic> json) => $UserEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}