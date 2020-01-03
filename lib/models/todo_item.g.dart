// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoItemAdapter extends TypeAdapter<TodoItem> {
  @override
  TodoItem read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoItem(
      title: fields[0] as String,
      done: fields[1] as bool,
      idx: fields[2] as int,
      colorIndex: fields[6] as int,
      timestamp: fields[7] as DateTime,
    )
      ..success = fields[3] as int
      ..level = fields[4] as int
      ..records = (fields[5] as List)?.cast<DateTime>();
  }

  @override
  void write(BinaryWriter writer, TodoItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.done)
      ..writeByte(2)
      ..write(obj.idx)
      ..writeByte(3)
      ..write(obj.success)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.records)
      ..writeByte(6)
      ..write(obj.colorIndex)
      ..writeByte(7)
      ..write(obj.timestamp);
  }
}
