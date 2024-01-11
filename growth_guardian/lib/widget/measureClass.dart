import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class Measurement{
  Measurement({required this.timeStamp, required this.measurementValue});
  final int timeStamp;
  final int measurementValue;
}