import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key, required this.activePlantInformation});

  final List<String> activePlantInformation;

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  @override
  Widget build(BuildContext context) {
    QueryWaterniveau();
    QueryLuchtvochtigheid();
    QueryTemperatuur();
    QueryBodemvocht();
    QueryLichtniveau();

    double screenWidth = MediaQuery.of(context).size.width;

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
                      Text('Temperatuur: '),
                      Text(' ...'),
                      Spacer(),
                      Text('Luchtvochtigheid: '),
                      Text('...'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Grondwaterniveau: '),
                      Text('...'),
                      Spacer(),
                      Text('Reservoir: '),
                      Text('...'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Huidige licht: '),
                      Text('...'),
                    ],
                  ),
                ],
              ),  
            ),     

            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
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

void QueryWaterniveau() async {
  final db = await openDatabase('doggie_database.db');

  try {
    List<Map> list = await db.rawQuery('SELECT waterniveau, tijd FROM dogs');
    print('Done waterniveau');
  } catch (Exception) {
    print('An error occurred!');
  }
}

void QueryLichtniveau() async {
  final db = await openDatabase('doggie_database.db');

  try {
    List<Map> list = await db.rawQuery('SELECT lichtniveau, tijd FROM dogs');
    print('Done lichtniveau');
  } catch (Exception) {
    print('An error occurred!');
  }
}

void QueryTemperatuur() async {
  final db = await openDatabase('doggie_database.db');

  try {
    List<Map> list = await db.rawQuery('SELECT temperatuur, tijd FROM dogs');
    print('Done temperatuur');
  } catch (Exception) {
    print('An error occurred!');
  }
}

void QueryBodemvocht() async {
  final db = await openDatabase('doggie_database.db');

  try {
    List<Map> list = await db.rawQuery('SELECT bodemvocht, tijd FROM dogs');
    print('Done bodemvocht');
  } catch (Exception) {
    print('An error occurred!');
  }
}

void QueryLuchtvochtigheid() async {
  final db = await openDatabase('doggie_database.db');

  try {
    List<Map> list = await db.rawQuery('SELECT luchtvochtigheid, tijd FROM dogs');
    print('Done luchtvochtigheid');
  } catch (Exception) {
    print('An error occurred!');
  }
}





