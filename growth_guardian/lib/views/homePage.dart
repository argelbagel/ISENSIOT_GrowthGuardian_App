import 'package:flutter/material.dart';
import 'package:growth_guardian/widget/cart.dart';
import '../main.dart' show PlantStorage;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.storage});

  final PlantStorage storage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
List<String> rooms = [];
List<String> warnings = ["Woonkamer;Hoekplant,Luchtvochtigheid te hoog;Vette plant,Krijgt te veel zonlicht","Badkamer;Vette plant,Krijgt te veel zonlicht"];

@override
void initState() {
  super.initState();
  getLocalStorage();
}

void getLocalStorage(){
  widget.storage.readPlants().then((value) {
      setState(() {
        final splitValues = value.split('/');
        for (int i = 0; i < splitValues.length; i++) {
          rooms.add(splitValues[i]);
        }
      });
    });
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
                return RoomList(room: rooms[index],allWarnings: warnings,);
              }
            }
          )
      )
    );
  }
}

class RoomList extends StatelessWidget {
  RoomList({super.key, required this.room, required this.allWarnings,});

  final String room;
  final List<String> allWarnings;


  @override
  Widget build(BuildContext context) {
    List<String> roomContent = room.split(';');
    for(int warningSplitIndex = 0; warningSplitIndex<allWarnings.length;warningSplitIndex++){
      List<String> warningsSplit = allWarnings[warningSplitIndex].split(";");
      if(warningsSplit[0] == roomContent[0]){
        for(int spliceWarningIntoPlantsIndex = 0;spliceWarningIntoPlantsIndex<warningsSplit.length;spliceWarningIntoPlantsIndex++){
          List<String> warningIntoString = warningsSplit[spliceWarningIntoPlantsIndex].split(",");
          for(int addToPlantIndex = 0; addToPlantIndex<roomContent.length;addToPlantIndex++){
            if(roomContent[addToPlantIndex].contains(warningIntoString[0]) && roomContent[addToPlantIndex] != roomContent[0]){
              roomContent[addToPlantIndex] = roomContent[addToPlantIndex] + "," + warningIntoString[warningIntoString.length-1];
            }
          }
        }
      }
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary,),child: Center(child: Text(roomContent[0],textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),))),
          ),
        ),
        //card()
        for(var i=1;i<roomContent.length;i++) Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(height:100, width: MediaQuery.of(context).size.width,child:card(plantNames: roomContent[i],)),
        )
      ],
    );
  }
}
