import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoList extends ChangeNotifier {
  List<TodoItem> itemList = [];
  Box todoItemBox;

  TodoList() {
    init();
  }

  void init() async {
    await Hive.openBox(Boxes.todoItemBox,
        compactionStrategy: (int total, int deleted) {
      return deleted > 20;
    });
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
        print('${event.key} is now assigned to ${event.value}');
      }
    });
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

  void toggleDone(int idx) {
    TodoItem item = itemList[idx];
    item.done = !item.done;
    item.save();
    notifyListeners();
  }

  void addItem(TodoItem todoItem) async {
    await todoItemBox.add(todoItem);
    todoItem.setIdx(itemList.length);
    todoItem.success = 0;
    todoItem.level = 1;
    itemList.add(todoItem);
    notifyListeners();
  }

  void updateItem(int idx, String title) {
    TodoItem item = itemList[idx];
    item.title = title;
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
