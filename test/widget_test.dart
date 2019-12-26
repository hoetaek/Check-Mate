// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:hive/hive.dart';

void main() async {
//  Directory documentsDirectory = await getApplicationDocumentsDirectory();
//  final path = documentsDirectory.path;
  Hive.init('.');
  var box = await Hive.openBox('myBox');

  box.put('name', 'David');

  var name = box.get('name');

  print('Name: $name');
}
