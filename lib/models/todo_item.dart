import 'package:hive/hive.dart';

part 'todo_item.g.dart';

@HiveType()
class TodoItem extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  bool done;
  @HiveField(2)
  int idx;
  @HiveField(3)
  int success;
  @HiveField(4)
  int level;

  TodoItem({this.title, this.done, this.idx});

  void setIdx(int itemIdx) {
    idx = itemIdx;
  }
}
