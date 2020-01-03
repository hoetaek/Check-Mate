import 'package:charts_flutter/flutter.dart' as charts;
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/app_bar/detail_appbar.dart';
import 'package:check_mate/widgets/todo_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TodoItemDetailPage extends StatelessWidget {
  final int idx;
  TodoItemDetailPage({this.idx});

  @override
  Widget build(BuildContext context) {
    final TodoItem todoItem = TodoList.itemList[idx];
    todoItem.setStrength();
    return Scaffold(
      appBar: DetailAppBar(todoItem: todoItem),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  CircularPercentIndicator(
                    center: Text(
                      '${(todoItem.strength * 100).toInt()}%',
                      style: TextStyle(
                          color: kEmphasisMainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    progressColor: kEmphasisMainColor,
                    backgroundColor: Color(0xFFE1BEE7),
                    radius: 100,
                    percent: todoItem.strength,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 100,
                    child: Center(
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                            numeric: true,
                            label: Text(
                              'days',
                              style: kEmphasisTextStyle,
                            ),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text(
                              'max\nrow',
                              textAlign: TextAlign.center,
                              style: kEmphasisTextStyle,
                            ),
                          ),
                          DataColumn(
                            numeric: true,
                            label: Text(
                              'max\nweekday',
                              textAlign: TextAlign.center,
                              style: kEmphasisTextStyle,
                              softWrap: true,
                            ),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(
                                '${DateTime.now().difference(todoItem.timestamp).inDays + 1}',
                                style: kTileSubtitle,
                              )),
                              DataCell(Text(
                                '${todoItem.getMaxRow()}',
                                textAlign: TextAlign.center,
                                style: kTileSubtitle,
                              )),
                              DataCell(Text(
                                '${todoItem.getMaxWeekday()}',
                                textAlign: TextAlign.center,
                                style: kTileSubtitle,
                              )),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: TodoStrengthTimeSeriesChart(
                    _createData(),
                    animate: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesTodo, DateTime>> _createData() {
    final TodoItem todoItem = TodoList.itemList[idx];

    final todoStrengthData = todoItem.records.map((record) {
      print(record);
      print(todoItem.getStrength(record) * 100);
      return TimeSeriesTodo(
          record, (todoItem.getStrength(record) * 100).toInt());
    }).toList();
//    todoStrengthData
//        .add(TimeSeriesTodo(DateTime.now().subtract(Duration(days: 4)), 50));
//    todoStrengthData
//        .add(TimeSeriesTodo(DateTime.now().subtract(Duration(days: 3)), 70));
    todoStrengthData
        .add(TimeSeriesTodo(DateTime.now(), (todoItem.strength * 100).toInt()));

    return [
      charts.Series<TimeSeriesTodo, DateTime>(
        id: 'Todo',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (TimeSeriesTodo todoStrength, _) => todoStrength.time,
        measureFn: (TimeSeriesTodo todoStrength, _) => todoStrength.strength,
//        measureUpperBoundFn: (TimeSeriesTodo todoStrength, _) => todoStrength.s+100,
        data: todoStrengthData,
      )
    ];
  }
}

class TimeSeriesTodo {
  final DateTime time;
  final int strength;

  TimeSeriesTodo(this.time, this.strength);
}
