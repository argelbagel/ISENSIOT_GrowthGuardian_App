
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
List<String> rooms = ["Woonkamer;Hoekplant,Charophyllum temulum;Bankplant,Aglaonema;Vette plant,Aeonium Crassulaceae","Badkamer;Hoekplant,Charophyllum temulum;Bankplant,Aglaonema;Vette plant,Aeonium Crassulaceae"];
List<String> warnings = ["Hoekplant,Luchtvochtigheid te hoog","Vette plant,Krijgt te veel zonlicht"];

void getLocalStorage(){

}

Future refresh() async {
    rooms.clear();
    getLocalStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: rooms.isEmpty
          ? ListView(children: const [
              Text(
                "Er zijn nog geen planten aan de app gekoppeld",
                textAlign: TextAlign.center,
              ),
            ])
          : ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              if (index < rooms.length) {
                return RoomList(room: rooms[index],warnings: warnings,);
              }
            }
          )
      )
    );
  }
}

class RoomList extends StatelessWidget {
  RoomList({super.key, required this.room, required this.warnings,});

  final String room;
  final List<String> warnings;
  

  @override
  Widget build(BuildContext context) {
    List<String> roomContent = room.split(';');
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,),child: Center(child: Text(roomContent[0],textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),))),
        ),
        //card()
        for(var i=1;i<roomContent.length;i++) card(plantNames: roomContent[i],)
      ],
    );
  }
}

class card extends StatelessWidget {
  const card({super.key, required this.plantNames});

  final String plantNames;

  @override
  Widget build(BuildContext context) {
    List<String> plantNamesList = plantNames.split(",");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(plantNamesList[0]),
        Text(plantNamesList[1]),
      ],
    );
  }
}