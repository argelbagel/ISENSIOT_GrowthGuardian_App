import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:growth_guardian/widget/measureClass.dart';

class PlantPageLineChart extends StatelessWidget {
  PlantPageLineChart({required this.dataList, required this.mode, required this.element});

  final List<Measurement> dataList;
  final String mode;
  final String element;

  @override
  Widget build(BuildContext context) {

    //Selects the displayed interval on the x axis of the graph
    late DateTimeIntervalType graphInterval;
    //Selects which graph title is displayed at the top of  the graph
    late String graphTitle;
    late String graphTitleTime;

    //Uses a switch statement to set the time part of the title and display interval
    switch(mode){
      case "Dag":
        graphInterval = DateTimeIntervalType.hours;
        graphTitleTime = '24 uur';
        break;
      case "Week":
        graphInterval = DateTimeIntervalType.days;
        graphTitleTime = 'week';
        break;
      case "Maand":
        graphInterval = DateTimeIntervalType.days;
        graphTitleTime = 'maand';
        break;
      case "Jaar":
        graphInterval = DateTimeIntervalType.months;
        graphTitleTime = 'jaar';
        break;
      default:
        graphInterval = DateTimeIntervalType.hours;
        graphTitleTime = '24 uur';
    }

    //Uses a switch statement to set the correct title depending on which variable should be displayed
    switch(element){
      case "Temperatuur":
        graphTitle = 'Temperatuur afgelopen ';
        break;
      case "Luchtvochtigheid":
        graphTitle = 'Luchtvochtigheid afgelopen ';
        break;
      case "Grondwater niveau":
        graphTitle = 'Grondwater niveau afgelopen ';
        break;
      case "Reservoir":
        graphTitle = 'Reservoir waterniveau afgelopen ';
        break;
      case "Licht":
        graphTitle = 'Licht niveau afgelopen ';
        break;
      default:
        graphTitle = 'Temperatuur afgelopen ';
    }

    //Makes a linechart visualising all the given data entries
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(intervalType: graphInterval),
      title: ChartTitle(text: graphTitle+graphTitleTime),
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: Legend(isVisible: false),
      //Uses the given order of the data entries to make the line of the chart
      series: <LineSeries<Measurement, DateTime>>[
        LineSeries<Measurement, DateTime>(
          dataSource: dataList,
          xValueMapper: (Measurement series, _) => series.timeStamp,
          yValueMapper: (Measurement series, _) => series.measurementValue,
          name: element,
          color: Theme.of(context).colorScheme.primary,
        )
      ],
      
    );
  }

}