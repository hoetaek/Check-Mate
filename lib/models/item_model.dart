class ItemModel {
  int id;
  String title;
  bool done;
  int idx;
  int success;
  int level;

  ItemModel({this.title, this.done});
  ItemModel.fromDb(Map itemData)
      : this.id = itemData['id'],
        this.title = itemData['title'],
        this.done = itemData['done'] == 1,
        this.idx = itemData['idx'],
        this.success = itemData['success'],
        this.level = itemData['level'];

  Map<String, dynamic> toMapForDb() {
    return <String, dynamic>{
      "id": id,
      "title": title,
      "done": done ? 1 : 0,
      "idx": idx,
      "success": success,
      "level": level,
    };
  }

  void setId(int itemId) {
    id = itemId;
  }

  void setIdx(int itemIdx) {
    idx = itemIdx;
  }
}
