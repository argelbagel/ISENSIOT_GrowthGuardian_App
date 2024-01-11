import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:growth_guardian/widget/measureClass.dart';

class PlantPageLineChart extends StatelessWidget {
  PlantPageLineChart({required this.dataList, required this.mode, required this.element});

  final List<Measurement> dataList;
  final String mode;
  final String element;


  (num,num) getStartNumber(){
    DateTime now = DateTime.now();
    late num startNumber;
    late num endNumber;
    switch(mode){
      case "day":
        startNumber = now.subtract(Duration(days: 1)).hour;
        endNumber = now.hour;
        break;
      case "week":
        startNumber = now.subtract(Duration(days: 7)).day;
        endNumber = now.day;
        break;
      case "month":
        startNumber = now.subtract(Duration(days: 30)).month;
        endNumber = now.month;
        break;
      case "year":
        startNumber = now.subtract(Duration(days: 365)).year;
        endNumber = now.year;
        break;
    }
    return (startNumber, endNumber);
  }

  num getChartTimeStamp(int timeStamp){
    late num convertedTime;
    switch(mode){
      case "day":
        convertedTime = DateTime.fromMillisecondsSinceEpoch(timeStamp).hour + (1/60)*DateTime.fromMillisecondsSinceEpoch(timeStamp).minute;
        break;
      case "week":
        convertedTime = DateTime.fromMillisecondsSinceEpoch(timeStamp).day+(1/24)*DateTime.fromMillisecondsSinceEpoch(timeStamp).hour+(1/1440)*DateTime.fromMillisecondsSinceEpoch(timeStamp).minute;
        break;
      case "month":
        convertedTime = DateTime.fromMillisecondsSinceEpoch(timeStamp).day+(1/24)*DateTime.fromMillisecondsSinceEpoch(timeStamp).hour+(1/1440)*DateTime.fromMillisecondsSinceEpoch(timeStamp).minute;
        break;
      case "year":
        convertedTime = DateTime.fromMillisecondsSinceEpoch(timeStamp).month+(1/31)*DateTime.fromMillisecondsSinceEpoch(timeStamp).day+(1/744)*DateTime.fromMillisecondsSinceEpoch(timeStamp).hour+(1/44640)*DateTime.fromMillisecondsSinceEpoch(timeStamp).hour+(1/1440)*DateTime.fromMillisecondsSinceEpoch(timeStamp).minute;
        break;

    }
    return convertedTime;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Measurement, num>> series = [
      charts.Series(
        id: "developers",
        data: dataList,
        domainFn: (Measurement series, _) => DateTime.fromMillisecondsSinceEpoch(series.timeStamp).hour + (1/60)*DateTime.fromMillisecondsSinceEpoch(series.timeStamp).minute,
        measureFn: (Measurement series, _) => series.measurementValue,
        //colorFn: (DeveloperSeries series, _) => series.barColor
      )
    ];

    return charts.LineChart(series, domainAxis: const charts.NumericAxisSpec(
                 tickProviderSpec:
                 charts.BasicNumericTickProviderSpec(zeroBound: false),
                 viewport: charts.NumericExtents(0, 24),
           ), animate: true);
  }

}