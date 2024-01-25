import 'package:flutter/material.dart';
import 'package:growth_guardian/widget/cart.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key, required this.switchToPlantPage, required this.warnings, required this.loadDatabase});

  final Function switchToPlantPage;
  final Function loadDatabase;

  final List<String> warnings;

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  //For now the warning system is only implemented as the internal structure
  //Replace later once they can actually be generated
  // List<String> warnings = ["Woonkamer;Hoekplant,Luchtvochtigheid te hoog;Vette plant,Krijgt te veel zonlicht","Badkamer;Vette plant,Krijgt te veel zonlicht"];
  //List<String> warnings = [];

  //Since warnings cant be dynamically generated yet this cant be esteblished yet
  Future refresh() async {
    widget.loadDatabase();
  }

  @override
  Widget build(BuildContext context) {
    List<String> allWarnings = [];
    print("warnings: " + widget.warnings.toString());

    //splits the warnings so they can be put back in the right order with the room inserted into them
    for(String roomWarnings in widget.warnings){
      List<String> allInRoom = roomWarnings.split(";");
      for(int i = 1;i<allInRoom.length;i++){
        List<String> warningSplit = allInRoom[i].split(",");
        allWarnings.add(warningSplit[0]+","+allInRoom[0]+","+warningSplit[1]+","+warningSplit[2]+","+warningSplit[3]);
      }
    }   

    print("allWarnings: " + allWarnings.toString());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: widget.warnings.isEmpty
          ? ListView(children: const [
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Er zijn geen meldingen",
                  textAlign: TextAlign.center,
                ),
              ),
            ])
          : ListView.builder(
            itemCount: allWarnings.length,
            itemBuilder: (context, index) {
              if (index < allWarnings.length) {
                String warning = allWarnings[index];
                List<String> parts = warning.split(',');
                String room = parts[1];
                parts.removeAt(1);
                String plantNames = parts.join(",");


                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(height:100, width: MediaQuery.of(context).size.width,child:card(plantNames: plantNames, roomName: room, switchToPlantPage: widget.switchToPlantPage,)));
              }
            }
          )
      )
    );
  }
}