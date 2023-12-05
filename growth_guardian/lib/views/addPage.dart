import 'package:flutter/material.dart';
import '../main.dart' show PlantStorage;

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.storage});

  final PlantStorage storage;


  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Wetenschappelijke naam gedetecteerde plant",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
          ),
          /*
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Naam",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),*/
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
            child: Container(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  labelText: 'Geef de plant een herkenbare naam',
                ),
              ),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Locatie",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),*/
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
            child: Container(
              height: 50.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  labelText: 'Waar staat de plant in het huis?',
                ),
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
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
                child: Container(
                  width: 340.0,
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text(
                      "Add plant",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}