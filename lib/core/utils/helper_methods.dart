import 'package:ansicolor/ansicolor.dart';
import 'package:flutter/material.dart';

void printErrMsg(String msg){
  AnsiPen pen = AnsiPen()..red();
  debugPrint(pen(msg));
}