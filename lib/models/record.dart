import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/services/check_off_daily.dart';
import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType()
class Record extends HiveObject {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  bool done;
  @HiveField(2)
  HiveList<TodoItem> todoItems;

  Record({hour = 0}) {
    DateTime tomorrow = CheckOffDaily.setDate;
    DateTime refreshTime =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour);
    this.date = refreshTime;
    this.done = false;
  }

  void toggleDone() {
    done = true;
  }
}
