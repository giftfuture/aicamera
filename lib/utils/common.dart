
import '../models/user_entity.dart';

class Common {
  final String _baseUrl = 'https://mpa.playinjoy.com/';
  static final allowedExtensions = ["xls","xlsx","xlsm","xltx","xltm","csv","pdf"];
  static UserEntity? user;
  String get baseUrl => _baseUrl;
}