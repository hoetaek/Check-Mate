import 'package:check_mate/constants.dart';
import 'package:check_mate/models/record.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CheckedCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: Hive.box(Boxes.recordsBox),
        builder: (context, box) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
            child: CalendarCarousel<Event>(
              onDayPressed: (DateTime date, List<Event> events) {
                print(date);
                print(events);
                events.forEach((event) => print(event.title));
              },
              thisMonthDayBorderColor: Colors.transparent,
              todayButtonColor: kEmphasisMainColor,
//              headerTitleTouchable: true,
//              onHeaderTitlePressed: () {
//                final recordsBox = Hive.box(Boxes.recordsBox);
//                print(recordsBox.length);
//                print('');
//                recordsBox.values.forEach((r) {
//                  Record record = r;
//                  print(record.date);
//                  print(record.done);
////                  print(record.todoItems[0].title);
//                });
//
//                final todoItemBox = Hive.box(Boxes.todoItemBox);
//                print(todoItemBox.length);
//                print('');
//                todoItemBox.values.forEach((item) {
//                  TodoItem todoItem = item;
//                  print(todoItem.title);
//                  print(todoItem.done);
//                  print(todoItem.records);
//                  print('');
//                });
//                recordsBox.clear();
//              },
              leftButtonIcon: Icon(
                Icons.chevron_left,
                color: kMainColor,
              ),
              rightButtonIcon: Icon(
                Icons.chevron_right,
                color: kMainColor,
              ),
              isScrollable: false,
              headerTextStyle: TextStyle(
                  color: kMainColor, fontSize: 20, fontWeight: FontWeight.bold),
              weekdayTextStyle: TextStyle(color: Colors.blueGrey),
              markedDatesMap: _getCarouselMarkedDates(box),
            ),
          );
        });
  }

  EventList<Event> _getCarouselMarkedDates(Box box) {
    final recordsBox = box;
    EventList<Event> eventList = EventList<Event>();
    for (Record r in recordsBox.values) {
      print(r.date);
      for (TodoItem item in r.todoItems) {
        print(item.title);
        print(item.colorIndex);
        eventList.add(
            r.date,
            Event(
                date: r.date,
                title: item.title,
                dot: _markedDatesDot(color: kColors[item.colorIndex])));
      }
    }
    return eventList;
  }

  Widget _markedDatesDot({Color color}) {
    return Container(
      height: 7,
      width: 7,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}
