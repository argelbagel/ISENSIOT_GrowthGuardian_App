import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class card extends StatelessWidget {
  const card({super.key, required this.plantNames, required this.roomName, required this.switchToPlantPage});

  final String plantNames;
  final String roomName;
  final Function switchToPlantPage;
  

  @override
  Widget build(BuildContext context) {
    print(plantNames);
    print(roomName);
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> plantNamesList = plantNames.split(",");
    if(plantNamesList.length<4){
      plantNamesList.add("");
    }

    String dirFoto = path.join('/data/user/0/com.example.growth_guardian/cache/$roomName/_${plantNamesList[0].toLowerCase()}.jpg');
    return GestureDetector(
      onTap: () {
        switchToPlantPage(roomName, plantNamesList[0], plantNamesList[1], dirFoto, plantNamesList[2]);
      },

      //switchToPlantPage(roomName, plantNamesList[0], plantNamesList[0], dirFoto);
      child: Container(
        width: 10.0,
        height: 10.0,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: screenWidth * 0.9,
            height: 100.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
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
                Container(
                  width: 100.0, 
                  height: 100.0, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                    image: DecorationImage(
                      image: FileImage(
                          File(dirFoto)),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(child: Align(alignment: Alignment.centerLeft,child: Text(plantNamesList[0], textAlign: TextAlign.left, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,),))),
                          Container(child: Align(alignment: Alignment.centerLeft,child: Text(plantNamesList[1], textAlign: TextAlign.left, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary,),))),
                          Container(child: Align(alignment: Alignment.centerLeft,child: Text(plantNamesList[3], textAlign: TextAlign.left, style: TextStyle(color: Theme.of(context).colorScheme.error,),))),
                        ],
                      )
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.primary,
                    size: 70.0,
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}