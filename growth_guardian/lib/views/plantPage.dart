import 'package:flutter/material.dart';
import 'dart:io';
import 'package:growth_guardian/widget/measureClass.dart';
import 'package:growth_guardian/widget/plantPageLineChart.dart';


class PlantPage extends StatefulWidget {
  const PlantPage({super.key, required this.activePlantInformation});

  final List<String> activePlantInformation;

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  //temp dataseries dummy database data voor graph testen, delete later
  final List<Measurement> temperatuurData = [
    Measurement(timeStamp: DateTime.parse('2024-01-08 10:00:00Z'), measurementValue: 19),
    Measurement(timeStamp: DateTime.parse('2024-01-08 11:00:00Z'), measurementValue: 22),
    Measurement(timeStamp: DateTime.parse('2024-01-08 12:00:00Z'), measurementValue: 22),
    Measurement(timeStamp: DateTime.parse('2024-01-08 13:00:00Z'), measurementValue: 22),
    Measurement(timeStamp: DateTime.parse('2024-01-08 14:00:00Z'), measurementValue: 21),
    Measurement(timeStamp: DateTime.parse('2024-01-08 15:00:00Z'), measurementValue: 19),
    Measurement(timeStamp: DateTime.parse('2024-01-08 16:00:00Z'), measurementValue: 18),
    Measurement(timeStamp: DateTime.parse('2024-01-08 17:00:00Z'), measurementValue: 18),
    Measurement(timeStamp: DateTime.parse('2024-01-08 18:00:00Z'), measurementValue: 21),
    Measurement(timeStamp: DateTime.parse('2024-01-08 19:00:00Z'), measurementValue: 21),
    Measurement(timeStamp: DateTime.parse('2024-01-08 20:00:00Z'), measurementValue: 23),
    Measurement(timeStamp: DateTime.parse('2024-01-08 21:00:00Z'), measurementValue: 22),
    Measurement(timeStamp: DateTime.parse('2024-01-08 22:00:00Z'), measurementValue: 21),
    Measurement(timeStamp: DateTime.parse('2024-01-08 23:00:00Z'), measurementValue: 21),
    Measurement(timeStamp: DateTime.parse('2024-01-09 00:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 01:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 02:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 03:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 04:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 05:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 06:00:00Z'), measurementValue: 3),
    Measurement(timeStamp: DateTime.parse('2024-01-09 07:00:00Z'), measurementValue: 8),
    Measurement(timeStamp: DateTime.parse('2024-01-09 08:00:00Z'), measurementValue: 13),
    Measurement(timeStamp: DateTime.parse('2024-01-09 09:00:00Z'), measurementValue: 16),
  ];

  //Creates the state variables and gives them defaults
  String mode = "Dag";
  String element = "Temperatuur";

  void changeMode(String modeValue){
    setState(() {
      mode = modeValue;
    });
  }

  void changeElement(String elementValue){
    setState(() {
      element = elementValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    /*
    print("Naam: ${widget.activePlantInformation[0]}");
    print("Wetenschappelijke naam: ${widget.activePlantInformation[2]}");
    print("Locatie: ${widget.activePlantInformation[2]}");
    print("Fotolocatie: ${widget.activePlantInformation[3]}");
    */

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: FileImage(
                          File(widget.activePlantInformation[3])),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: screenWidth * 0.9, 
                            height: 80.0, 
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                              ), 
                            ),
                            
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.activePlantInformation[1],
                                        style: TextStyle(
                                          fontSize: 20.0, // Replace with your desired font size
                                          fontWeight: FontWeight.bold, // Replace with your desired font weight
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        widget.activePlantInformation[0],
                                        style: TextStyle(
                                          fontSize: 14.0, // Replace with your desired font size
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        widget.activePlantInformation[2],
                                        style: TextStyle(
                                          fontSize: 16.0, // Replace with your desired font size
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Satus van de plant",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              width: 250.0, 
              height: 40.0, 
              decoration: BoxDecoration(
                color:  Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Status',
                        style: TextStyle(color: Colors.white),
                     ),
                    ],
                  ),
                ),
              ), 
            ), 

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      elementTextButton(currentElement: element, buttonElement: "Temperatuur", changeElement: changeElement),
                      Text(' ...'),
                      Spacer(),
                      elementTextButton(currentElement: element, buttonElement: "Luchtvochtigheid", changeElement: changeElement),
                      Text('...'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      elementTextButton(currentElement: element, buttonElement: "Grondwater niveau", changeElement: changeElement),
                      Text('...'),
                      Spacer(),
                      elementTextButton(currentElement: element, buttonElement: "Reservoir", changeElement: changeElement),
                      Text('...'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      elementTextButton(currentElement: element, buttonElement: "Licht", changeElement: changeElement),
                      Text('...'),
                    ],
                  ),
                ],
              ),  
            ),     

            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    width: 350,
                    height: 150,
                    child: PlantPageLineChart(dataList: temperatuurData, mode:mode, element: element,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      intervalButton(currentMode: mode, buttonMode: "Dag", changeMode: changeMode),
                      intervalButton(currentMode: mode, buttonMode: "Week", changeMode: changeMode),
                      intervalButton(currentMode: mode, buttonMode: "Maand", changeMode: changeMode),
                      intervalButton(currentMode: mode, buttonMode: "Jaar", changeMode: changeMode),
                    ],
                  ),
                ],
              ),
            ),     
            
            
            
            Padding(
            padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Ideale leefomgeving voor deze plant:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75.0, top: 10.0),
                    child: Row(
                      children: [
                        Text('Temperatuur: '),
                        Text('...'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75.0, top: 10.0),
                    child: Row(
                      children: [
                        Text('Luchtvochtigheid: '),
                        Text('...'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75.0,top: 10.0),
                    child: Row(
                      children: [
                        Text('Lichtniveau: '),
                      Text('...'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}

class elementTextButton extends StatelessWidget {
  const elementTextButton({super.key, required this.currentElement, required this.buttonElement, required this.changeElement});

  final String currentElement;
  final String buttonElement;
  final Function changeElement;

  @override
  Widget build(BuildContext context) {
    return TextButton(style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        textStyle: currentElement==buttonElement
        ? TextStyle(fontWeight: FontWeight.bold)
        : TextStyle(fontWeight: FontWeight.normal)
      ), 
      onPressed: (){changeElement(buttonElement);},
      child: Text(buttonElement + ': ')
    );
  }
}

class intervalButton extends StatelessWidget {
  const intervalButton({super.key, required this.currentMode, required this.buttonMode, required this.changeMode});

  final String currentMode;
  final String buttonMode;
  final Function changeMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: ElevatedButton(style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minimumSize: Size.zero,
          padding: EdgeInsets.all(6),
          backgroundColor: currentMode==buttonMode
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary,
          
          elevation: 0,
          foregroundColor: currentMode==buttonMode
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.onSecondary,
    
          textStyle: currentMode==buttonMode
          ? TextStyle(fontWeight: FontWeight.bold)
          : TextStyle(fontWeight: FontWeight.normal)
        ), 
        onPressed: (){changeMode(buttonMode);},
        child: Text(buttonMode)
      ),
    );
  }
}