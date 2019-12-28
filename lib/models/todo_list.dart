import 'package:check_mate/constants.dart';
import 'package:check_mate/models/record.dart';
import 'package:check_mate/models/record_list.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoList with ChangeNotifier {
  List<TodoItem> itemList = [];
  Box todoItemBox;
  RecordList recordList;
  List<Record> dateRecordsList;

  TodoList() {
    init();
  }

  void init() async {
    //todoItemBox initialize
//    await Hive.openBox(Boxes.todoItemBox,
//        );
    todoItemBox = Hive.box(Boxes.todoItemBox);
    List todoItemList = todoItemBox.values.toList();
    todoItemList.forEach((item) {
      TodoItem todoItem = item;
      itemList.add(todoItem);
    });
    itemList.sort((a, b) => a.idx.compareTo(b.idx));

    todoItemBox.watch().listen((event) {
      if (event.deleted) {
        //firestore delete
        print('${event.key} is now deleted');
      } else {
        // set key item's value to event.value
        print('${event.key} is now assigned to ');
      }
      notifyListeners();
    });
    recordList = RecordList(itemList: itemList);
    dateRecordsList = recordList.dateRecordsList;
  }

  void reorder(oldIdx, newIdx) {
    TodoItem selected = itemList.removeAt(oldIdx);
    itemList.insert(newIdx, selected);
    int idx = 0;
    itemList.forEach((TodoItem todoItem) {
      todoItem.setIdx(idx);
      todoItem.save();
      idx += 1;
    });
    notifyListeners();
  }

  TodoItem getItem(int idx) {
    return itemList[idx];
  }

  String getTitle(int idx) {
    return itemList[idx].title;
  }

  bool getDone(int idx) {
    return itemList[idx].done;
  }

  int getColorIndex(int idx) {
    return itemList[idx].colorIndex;
  }

  void toggleDone(int idx) {
    TodoItem item = itemList[idx];
    item.done = !item.done;
    item.save();
    notifyListeners();
  }

  void addItem(TodoItem todoItem) async {
    await todoItemBox.add(todoItem);
    itemList.add(todoItem);
    notifyListeners();
  }

  void updateItem(int idx, String title, int colorIndex) {
    TodoItem item = itemList[idx];
    item.title = title;
    item.colorIndex = colorIndex;
    item.save();
    notifyListeners();
  }

  void removeItem(int idx) {
    TodoItem item = itemList[idx];
    item.delete();
    itemList.removeAt(idx);
    notifyListeners();
  }
}
