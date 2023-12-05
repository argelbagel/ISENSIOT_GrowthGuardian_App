import 'package:flutter/material.dart';

class PlantPage extends StatefulWidget {
  const PlantPage({super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                                        'Naam',
                                        style: TextStyle(
                                          fontSize: 20.0, // Replace with your desired font size
                                          fontWeight: FontWeight.bold, // Replace with your desired font weight
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        'Locatie',
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
                                        'Wetenschappelijke naam',
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
                  color: Colors.black,
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