import 'package:check_mate/constants.dart';
import 'package:check_mate/models/record.dart';
import 'package:check_mate/models/record_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class CheckOffDaily {
  final Function initializeItemDone;
  static DateTime setDate =
      RecordList.getDay(DateTime.now().add(Duration(days: 1)));
//  static DateTime setDate = DateTime.now().add(Duration(seconds: 15));
  Box recordsBox = Hive.box(Boxes.recordsBox);

  CheckOffDaily({@required this.initializeItemDone}) {
    print(recordsBox.values);
    recordsBox.values.forEach((r) {
      Record record = r;
      print(record.date);
    });

    Stream.periodic(Duration(seconds: 1), (_) => DateTime.now())
        .skipWhile((DateTime date) {
//          print(date.toString());
//          print("looking for conditions");
          //skip if the time now is before the set time
          //set time should be inside somewhere
          if (date.isBefore(setDate)) {
            //skip if true
            return true;
            //skip if the time has passed the set time
          } else {
            return false;
          }
        })
        .take(1)
        .listen((DateTime date) {
          initializeItemDone();
//          print(setDate);
//          print(date.toString());
//          print("stream started");
//          recordsBox.values.where((r) {
//            Record record = r;
//            return record.isSameDate(Record.getDateTimeDay(Record.tomorrow));
//          }).forEach((r) {
//            Record record = r;
//            record.initializeDone();
//            record.save();
//          });
        });
  }
}
