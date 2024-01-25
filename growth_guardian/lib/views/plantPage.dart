import 'package:flutter/material.dart';
import 'dart:io';
import 'package:growth_guardian/widget/measureClass.dart';
import 'package:growth_guardian/widget/plantPageLineChart.dart';
import 'package:sqflite/sqflite.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key, required this.activePlantInformation, required this.activePlantStats, required this.idealEnvironmentPerSpecies});

  final List<String> activePlantInformation;

  final Map<String,dynamic> activePlantStats;
  final Map<String,Map<String,dynamic>> idealEnvironmentPerSpecies;

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  //Creates the state variables and gives them defaults
  String mode = "Maand";
  String element = "Temperatuur";
  //State datalist that gets initialised in the initialiser and can get updated by the changeActiveData function
  List<Measurement> activeData = [];
  //constants that declare which database and table therin is being used, can be made dynamic later if multiple options get introduced
  final String database = 'doggie_database.db';
  final String table = 'dogs';
  final String plantName = "plantenpot";

  String status = "Alles gaat goed";

  bool warning = false;

  String idealTemp = "...";
  String idealHumid = "...";
  String idealLight = "...";

  @override
  void initState() {
    super.initState();
    
    changeActiveData(element,mode);
    setIdealValues();
  }

  void changeActiveData(String element, String mode){
    //Change plantName to the correct part of activePlantInformation when proper data starts being used
    QueryDatabase(database, table, element, mode, plantName).then((value){
      List<Measurement> newData = [];
      for(var i in value){
        newData.add(Measurement(timeStamp: DateTime.fromMillisecondsSinceEpoch(i["tijd"]), measurementValue: i[convertAppElementToDatabaseElement(element)]));
      }
      // print(newData[0].timeStamp);
      // print(newData[19].timeStamp);
      setState(() {
        activeData = newData;
        if(widget.activePlantInformation[5] != ""){
          status = widget.activePlantInformation[5];
          warning = true;
        }
      });
    });
  }

  void setIdealValues(){
    final speciesInfo = widget.idealEnvironmentPerSpecies[widget.activePlantInformation[2]]!;
    print(speciesInfo);
    setState(() {
      idealTemp = speciesInfo["temperatuurMin"].toString() + " - " + speciesInfo["temperatuurMax"].toString() + " C";
      idealHumid = speciesInfo["luchtvochtigheidMin"].toString() + " - " + speciesInfo["luchtvochtigheidMax"].toString() + " %";
      idealLight = speciesInfo["lichtintensiteitMin"].toString() + " - " + speciesInfo["lichtintensiteitMax"].toString() + " Lux";
    });
  }

  void changeMode(String modeValue){
    setState(() {
      mode = modeValue;
    });
    changeActiveData(element,mode);
  }

  void changeElement(String elementValue){
    setState(() {
      element = elementValue;
    });
    changeActiveData(element,mode);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    print(widget.activePlantInformation);

    /*
    print("Naam: ${widget.activePlantInformation[1]}");
    print("Wetenschappelijke naam: ${widget.activePlantInformation[2]}");
    print("Locatie: ${widget.activePlantInformation[0]}");
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
              width: warning
              ? 320
              : 250.0,
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
                        text: status,
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
                      Text(widget.activePlantStats["temperatuur"].toString()),
                      Spacer(),
                      elementTextButton(currentElement: element, buttonElement: "Luchtvochtigheid", changeElement: changeElement),
                      Text(widget.activePlantStats["luchtvochtigheid"].toString()),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      elementTextButton(currentElement: element, buttonElement: "Grondwater niveau", changeElement: changeElement),
                      Text(widget.activePlantStats["bodemvocht"].toString()),
                      Spacer(),
                      elementTextButton(currentElement: element, buttonElement: "Reservoir", changeElement: changeElement),
                      Text(widget.activePlantStats["waterniveau"].toString()),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      elementTextButton(currentElement: element, buttonElement: "Licht", changeElement: changeElement),
                      Text(widget.activePlantStats["lichtniveau"].toString()),
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
                    child: PlantPageLineChart(dataList: activeData, mode:mode, element: element,),
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
                        Text(idealTemp),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75.0, top: 10.0),
                    child: Row(
                      children: [
                        Text('Luchtvochtigheid: '),
                        Text(idealHumid),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 75.0,top: 10.0),
                    child: Row(
                      children: [
                        Text('Lichtniveau: '),
                      Text(idealLight),
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

String convertAppElementToDatabaseElement(element){
  switch(element){
      case "Temperatuur":
        return "temperatuur";
      case "Luchtvochtigheid":
        return"luchtvochtigheid";
      case "Grondwater niveau":
        return "bodemvocht";
      case "Reservoir":
        return "waterniveau";
      case "Licht":
        return "lichtniveau";
      default:
        return "temperatuur";
  }
}

Future<List<Map>> QueryDatabase(String database, String table, String element, String mode, String plantName) async{
  final db = await openDatabase(database);

  plantName = "\"" + plantName + "\"";

  //First sets up the varius parts of the query that are constant and variable to splice the desired query together
  late String queryWhatPart;
  String queryWhatPart1 = "SELECT ";
  String queryWhatPart2 = ", tijd FROM " + table;

  late int startOfRecords;
  DateTime now = DateTime.now();
  late String finalQuery;

  //Makes the first part of the query where a specific element is grabbed from the database
  queryWhatPart = queryWhatPart1 + convertAppElementToDatabaseElement(element) + queryWhatPart2;

  //Selects the time from which we want to display the data
  switch(mode){
      case "Dag":
        startOfRecords = DateTime(now.year, now.month, now.day-1, now.hour, now.minute).millisecondsSinceEpoch;
        break;
      case "Week":
        startOfRecords = DateTime(now.year, now.month, now.day-7, now.hour, now.minute).millisecondsSinceEpoch;
        break;
      case "Maand":
        startOfRecords = DateTime(now.year, now.month-1, now.day, now.hour, now.minute).millisecondsSinceEpoch;
        break;
      case "Jaar":
        startOfRecords = DateTime(now.year-1, now.month, now.day, now.hour, now.minute).millisecondsSinceEpoch;
        break;
      default:
        startOfRecords = DateTime(now.year, now.month, now.day-1, now.hour, now.minute).millisecondsSinceEpoch;
    }

    //Splices the parts together into a single string which will be used as query
    finalQuery = queryWhatPart + " WHERE tijd > " + startOfRecords.toString()+ " AND naam = " + plantName + " ORDER BY tijd ASC";
    //print(finalQuery);
  try {
    List<Map> list = await db.rawQuery(finalQuery);
    //print(list);
    print('Done ' + element + " " + mode);
    return list;
  } catch (Exception) {
    print('An error occurred!');
    return [];
  }

}