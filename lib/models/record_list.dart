import 'package:check_mate/constants.dart';
import 'package:check_mate/models/record.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/services/check_off_daily.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class RecordList {
  List<Record> dateRecordsList = [];
  List<TodoItem> itemList;
  Box recordsBox;
  Box todoItemBox = Hive.box(Boxes.todoItemBox);
  Record lastRecord;

  RecordList({@required this.itemList}) {
    recordInit();
  }

  int get length => dateRecordsList.length;

  void recordInit() async {
    //todoItemBox initialize
    await Hive.openBox(Boxes.recordsBox,
        compactionStrategy: (int total, int deleted) {
      return deleted > 20;
    });
    recordsBox = Hive.box(Boxes.recordsBox);
    List recordItemList = recordsBox.values.toList();
    recordItemList.forEach((item) {
      Record recordItem = item;
      dateRecordsList.add(recordItem);
    });
    dateRecordsList.sort((a, b) => a.date.compareTo(b.date));
    recordsBox.watch().listen((event) {
      if (event.deleted) {
//        print('${event.key} is now deleted');
      } else {
//        print('${event.key} is now assigned to ${event.value.date}');
      }
    });
    if (recordsBox.isNotEmpty) {
      lastRecord = recordsBox.getAt(recordsBox.length - 1);
      if (!lastRecord.done &&
          (getDay(lastRecord.date) != getDay(CheckOffDaily.setDate))) {
        print("it should initialize");
        initializeDone();
      }
    }
    addTodayRecord();
    CheckOffDaily(initializeItemDone: initializeDone);
  }

  void initializeDone() {
    print("initializing");
    itemList.forEach((TodoItem todoItem) {
      print(todoItem.title);
      print(todoItem.done);
      if (todoItem.done) {
        print("${todoItem.title} was done");
        todoItem.toggleDone();
        todoItem.updateLevel();
        todoItem.records
            .add(getDay(CheckOffDaily.setDate.subtract(Duration(days: 1))));
        // add todoItem to the record so that it can shown on the calendar
        lastRecord.todoItems.add(todoItem);
        todoItem.save();
      }
    });
    lastRecord.toggleDone();
    lastRecord.save();
    addTodayRecord();
//    todoItemBox.values.forEach((todoItem) {
//      TodoItem item = todoItem;
//      print(item.title);
//      print(item.done);
//      print(item.records[0].done);
//      print("");
//    });
  }

  void addTodayRecord() {
    if (todayRecordCondition()) addRecord();
  }

  bool todayRecordCondition() {
    if (dateRecordsList.isNotEmpty) {
      lastRecord = dateRecordsList[dateRecordsList.length - 1];
      DateTime setTime = CheckOffDaily.setDate;
      print("last record ${lastRecord.date}");
      if (!(getDay(lastRecord.date) == getDay(setTime))) {
        print("today date doesn't exist");
        return true;
      }
    } else {
      print("today date doesn't exist");
      return true;
    }
    return false;
  }

  void addRecord() {
    Record record = Record();
    recordsBox.add(record);
    record.todoItems = HiveList(todoItemBox);
    dateRecordsList.add(record);
    record.save();
  }

  static DateTime getDay(DateTime dateToConvert) =>
      DateTime(dateToConvert.year, dateToConvert.month, dateToConvert.day);
}
