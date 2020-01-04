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
      created: fields[8] as DateTime,
      share: fields[9] as bool,
    )
      ..success = fields[3] as int
      ..level = fields[4] as int
      ..records = (fields[5] as List)?.cast<DateTime>();
  }

  @override
  void write(BinaryWriter writer, TodoItem obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.timestamp)
      ..writeByte(8)
      ..write(obj.created)
      ..writeByte(9)
      ..write(obj.share);
  }
}
