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
  @HiveField(7)
  DateTime timestamp;
  int plusLvNum = 0;
  double strength;
  int row;

  TodoItem({this.title, this.done, this.idx, this.colorIndex, this.timestamp}) {
    success = 0;
    level = 1;
    records = [];
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      "title": title,
      "done": done,
      "level": level,
      "colorIndex": colorIndex,
    };
  }

  setRow() {
    if (records.isNotEmpty) {
      print("setting row");
      print(getRow(records.last));
      return getRow(records.last) + (done ? 1 : 0);
    }
    return done ? 1 : 0;
  }

  int getRow(DateTime standardDate) {
    int sequenceNum = 1;
    DateTime pastDate = standardDate.subtract(Duration(days: 1));
    while (records.contains(pastDate)) {
      sequenceNum += 1;
      pastDate = pastDate.subtract(Duration(days: 1));
    }
    return sequenceNum;
  }

  int getMaxRow() {
    int maxRow = setRow();
    for (var record in records) {
      int row = getRow(record);
      if (row > maxRow) maxRow = row;
    }
    return maxRow;
  }

  String getMaxWeekday() {
    int maxWeeday;
    int maxDayCount = 0;
    List<int> recordWeekday = records.map((record) => record.weekday).toList();
    if (done) recordWeekday.add(DateTime.now().weekday);
    for (int i = 0; i < 7; i++) {
      int count = recordWeekday.where((weekday) => weekday == i).length;
      if (count > maxDayCount) {
        maxDayCount = count;
        maxWeeday = i;
      }
    }
    return [
      "Sun",
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat"
    ][maxWeeday ?? DateTime.now().weekday];
  }

  setStrength() {
    strength = getStrength(DateTime.now(), today: true);
  }

  double getStrength(DateTime standardDate, {bool today = false}) {
    DateTime short = standardDate.subtract(Duration(days: 7));
    DateTime middle = standardDate.subtract(Duration(days: 21));
    DateTime long = standardDate.subtract(Duration(days: 66));
    double shortStrength = 0;
    double middleStrength = 0;
    double longStrength = 0;
    if (done && today) {
      longStrength += 1;
      middleStrength += 1;
      shortStrength += 1;
    }
    records.forEach((record) {
      if (short.isBefore(record)) {
        longStrength += 1;
        middleStrength += 1;
        shortStrength += 1;
      } else if (middle.isBefore(record)) {
        middleStrength += 1;
        longStrength += 1;
      } else if (long.isBefore(record)) {
        longStrength += 1;
      }
    });

    double todoStrength =
        (shortStrength / 7 + middleStrength / 21 + longStrength / 66) / 3;
    return todoStrength;
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
