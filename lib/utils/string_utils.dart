import 'package:flutter/material.dart';

/// 防止文字自动换行
extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}