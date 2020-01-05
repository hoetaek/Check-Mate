import 'package:check_mate/constants.dart';
import 'package:check_mate/models/record.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/widgets/event_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<Event> eventsList = [];
  @override
  Widget build(BuildContext context) {
    return WatchBoxBuilder(
        box: Hive.box(Boxes.recordsBox),
        builder: (context, box) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: <Widget>[
                    ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 380),
                        child: _checkedCalendar(context, box)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: eventsList.length,
                      itemBuilder: (context, index) {
                        Box todoItemBox = Hive.box(Boxes.todoItemBox);
                        Event event = eventsList[index];
                        String key = event.title;
                        TodoItem todoItem = todoItemBox.get(int.parse(key));
                        int sequenceNum = 1;
                        DateTime pastDate =
                            event.date.subtract(Duration(days: 1));
                        while (todoItem.records.contains(pastDate)) {
                          sequenceNum += 1;
                          pastDate = pastDate.subtract(Duration(days: 1));
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: EventTile(
                            date: event.date,
                            color: kColors[todoItem.colorIndex],
                            size: 50,
                            title: Text(
                              "${todoItem.title}",
                              style: TextStyle(
                                  color: kColors[todoItem.colorIndex]
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            subtitle: Text(
                              '연속: $sequenceNum일',
                              style: TextStyle(
                                color: kColors[todoItem.colorIndex]
                                            .computeLuminance() >
                                        0.5
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  EventList<Event> _getCarouselMarkedDates(Box box) {
    final recordsBox = box;
    EventList<Event> eventList = EventList<Event>();
    for (Record r in recordsBox.values) {
      for (TodoItem item in r.todoItems) {
        eventList.add(
            r.date.subtract(Duration(days: 1)),
            Event(
                date: r.date.subtract(Duration(days: 1)),
                title: item.key.toString(),
                dot: _markedDatesDot(color: kColors[item.colorIndex])));
      }
    }
    return eventList;
  }

  Widget _checkedCalendar(BuildContext context, Box box) {
    DateTime _selectedDate;
    return CalendarCarousel<Event>(
      onDayPressed: (DateTime date, List<Event> events) {
        setState(() {
          eventsList = events;
        });
      },
      thisMonthDayBorderColor: Colors.transparent,
      todayButtonColor: kEmphasisMainColor,
//      headerTitleTouchable: true,
//      onHeaderTitlePressed: () {
//        box.values.forEach((record) => print(record.date));
//      },
      pageScrollPhysics: NeverScrollableScrollPhysics(),
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      isScrollable: false,
      selectedDayButtonColor: kColors[4],
      selectedDateTime: _selectedDate,
      leftButtonIcon: Icon(
        Icons.chevron_left,
        color: kMainColor,
      ),
      rightButtonIcon: Icon(
        Icons.chevron_right,
        color: kMainColor,
      ),
      headerTextStyle: TextStyle(
          color: kMainColor, fontSize: 20, fontWeight: FontWeight.bold),
      weekdayTextStyle: TextStyle(color: Colors.blueGrey),
      markedDatesMap: _getCarouselMarkedDates(box),
      headerMargin: EdgeInsets.all(5),
    );
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
