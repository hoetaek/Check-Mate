import 'package:check_mate/models/item_model.dart';
import 'package:check_mate/resources/todo_db_provider.dart';
import 'package:flutter/material.dart';

class TodoList extends ChangeNotifier {
  //TODO 여기에 firebase current user 확인하는 기능 추가
  List<ItemModel> itemList = [];
  TodoDbProvider todoDbProvider = TodoDbProvider();
  TodoList() {
    init();
  }
  void init() async {
    await todoDbProvider.init();
    List<ItemModel> todoDbData = await todoDbProvider.fetchItems();
    if (todoDbData != null) {
      itemList.addAll(todoDbData);
    }
  }

  void reorder(oldIdx, newIdx) {
    ItemModel selected = itemList.removeAt(oldIdx);
    itemList.insert(newIdx, selected);
    int idx = 0;
    itemList.forEach((ItemModel todoItem) {
      todoItem.setIdx(idx);
      todoDbProvider.updateItem(todoItem);
      idx += 1;
    });
    notifyListeners();
  }

  ItemModel getItem(int idx) {
    return itemList[idx];
  }

  String getTitle(int idx) {
    return itemList[idx].title;
  }

  bool getDone(int idx) {
    return itemList[idx].done;
  }

  void toggleDone(int idx) {
    ItemModel item = itemList[idx];
    item.done = !item.done;
    todoDbProvider.updateItem(item);
    notifyListeners();
  }

  void addItem(ItemModel todoItem) async {
    int itemId = await todoDbProvider.addItem(todoItem);
    todoItem.setId(itemId);
    todoItem.setIdx(itemList.length);
    todoItem.success = 0;
    todoItem.level = 1;
    itemList.add(todoItem);
    notifyListeners();
  }

  void updateItem(int idx, String title) {
    ItemModel item = itemList[idx];
    item.title = title;
    todoDbProvider.updateItem(item);
    notifyListeners();
  }

  void removeItem(int idx) {
    todoDbProvider.deleteItem(itemList[idx]);
    itemList.removeAt(idx);
    notifyListeners();
  }
}
