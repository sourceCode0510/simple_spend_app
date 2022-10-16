import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/db_provider.dart';

class ChartBox extends StatefulWidget {
  const ChartBox({Key? key}) : super(key: key);

  @override
  State<ChartBox> createState() => _ChartBoxState();
}

class _ChartBoxState extends State<ChartBox> {
  var activeTab = 'Recent';
  List<String> tabs = ['Recent', 'Monthly', 'Yearly'];

  // function to get the monday of week.
  DateTime get monday {
    DateTime date = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (date.weekday == i + 1) {
        date = date.subtract(Duration(days: i));
      }
    }
    return date;
  }

  // function to get the total spendings on day basis of the week
  List<Map<String, double>> get values {
    final provider = Provider.of<Dbprovider>(context, listen: false);

    final weekSpendings = provider.spendings.where((element) {
      return element.date.isAfter(monday) ||
          element.date.weekday == monday.weekday;
    }).toList();

    return List.generate(7, (index) {
      double amount = 0.0;
      DateTime newDay = monday.add(Duration(days: index));

      for (int i = 0; i < weekSpendings.length; i++) {
        if (weekSpendings[i].date.weekday == newDay.weekday) {
          amount += weekSpendings[i].amount;
        }
      }

      return {'day': double.parse(newDay.weekday.toString()), 'amount': amount};
    });
  }

  // function to get total spending amount of the week.
  double get totalAmount {
    final provider = Provider.of<Dbprovider>(context, listen: false);
    double totalAmount = 0.0;
    final weekSpendings = provider.spendings.where((element) {
      return element.date.isAfter(monday) ||
          element.date.weekday == monday.weekday;
    }).toList();
    for (int i = 0; i < weekSpendings.length; i++) {
      totalAmount += weekSpendings[i].amount;
    }
    return totalAmount;
  }

  // for labeling the columns
  final List<String> days = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'This week',
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          //
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.close),
          )
        ],
      ),
      // this will be the graph
      content: SizedBox(
        width: 400.0,
        height: 300.0,
        // color: Colors.red,
        child: totalAmount == 0
            ? const Center(
                child: Text(
                  'No Spendings this week',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 7,
                  minY: 0,
                  maxY: totalAmount,
                  lineBarsData: [
                    LineChartBarData(
                      spots: values
                          .map((e) => FlSpot(e['day']!, e['amount']!))
                          .toList(),
                      color: Theme.of(context).primaryColor,
                      isCurved: true,
                      preventCurveOverShooting: true,
                      preventCurveOvershootingThreshold: 2.0,
                      belowBarData: BarAreaData(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.8),
                            Theme.of(context).primaryColor.withOpacity(0.4),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        show: true,
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(drawBehindEverything: true),
                    rightTitles: AxisTitles(drawBehindEverything: true),
                    bottomTitles: AxisTitles(
                      axisNameSize: 25.0,
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            days[value.toInt() - 1],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
