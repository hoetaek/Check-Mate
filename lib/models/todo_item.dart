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
  @HiveField(5)
  List<DateTime> records;
  @HiveField(6)
  int colorIndex;

  TodoItem({this.title, this.done, this.idx, this.colorIndex}) {
    success = 0;
    level = 1;
    records = [];
  }

  void updateLevel() {
    level = level + 1;
  }

  void setIdx(int itemIdx) {
    idx = itemIdx;
  }

  void toggleDone() {
    done = !done;
  }
}
