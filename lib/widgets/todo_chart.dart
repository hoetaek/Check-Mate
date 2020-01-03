/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TodoStrengthTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TodoStrengthTimeSeriesChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: charts.DateTimeAxisSpec(
          tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
              day: charts.TimeFormatterSpec(
            format: 'dd',
            transitionFormat: 'dd MMM',
          ))),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelAnchor: charts.TickLabelAnchor.after,
        ),
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          // Create the ticks to be used the domain axis.
          <charts.TickSpec<num>>[
            charts.TickSpec(100,
                label: '100%', style: charts.TextStyleSpec(fontSize: 14)),
            charts.TickSpec(75,
                label: '75%', style: charts.TextStyleSpec(fontSize: 14)),
            charts.TickSpec(50,
                label: '50%', style: charts.TextStyleSpec(fontSize: 14)),
            charts.TickSpec(25,
                label: '25%', style: charts.TextStyleSpec(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
