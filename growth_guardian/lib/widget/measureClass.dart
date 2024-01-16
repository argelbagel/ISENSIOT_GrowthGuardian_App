class Measurement{
  Measurement({required this.timeStamp, required this.measurementValue});
  final DateTime timeStamp;
  final int measurementValue;
}

class FullMeasurement{
  FullMeasurement({required this.timeStamp, required this.temperature, required this.humidity, required this.waterlevel, required this.resevoir, required this.light});
  final DateTime timeStamp;
  final int temperature;
  final int humidity;
  final int waterlevel;
  final int resevoir;
  final int light;
}