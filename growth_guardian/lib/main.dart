import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:growth_guardian/views/addPage.dart';
import 'package:growth_guardian/views/homePage.dart';
import 'package:growth_guardian/views/plantPage.dart';
import 'package:growth_guardian/views/problemPage.dart';
import 'dart:io';
import "package:dart_amqp/dart_amqp.dart";
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:postgres/postgres.dart';

void main() async {
    /*
  ConnectionSettings settings = ConnectionSettings(
    host: "145.101.75.2", //89.205.131.42, 192.168.94.218, localhost, 192.168.56.1
    port: 5672,
    authProvider: const PlainAuthenticator('harige_harry', 'harige_harry'), //mqtt-test, guest, harige_harry
  );

  Client client = Client(settings: settings);

  ProcessSignal.sigint.watch().listen((_) {
    client.close().then((_) {
      print("close client");
      exit(0);
    });
  });

  List<String> routingKeys = ["#"];


  client.channel().then((Channel channel) {
    print('Setting the exchange');
    return channel.exchange("sensordata", ExchangeType.TOPIC, durable: false); //amq.topic, voor sensoren > durable true
  }).then((Exchange exchange) {
    print("[*] Waiting for messages in logs. To Exit press CTRL+C");
    return exchange.bindPrivateQueueConsumer(
      routingKeys,
      consumerTag: "APP-GrowthGuardian", noAck: true
    );
  })
  .then((Consumer consumer) {
    consumer.listen((AmqpMessage event) async {
      //print("${event.routingKey};${event.payloadAsString}");
      String data = '${event.payloadAsString}';

      List<String> keyValuePairs = data.split(',');

      var sensordata = Dog(
        id: int.parse(keyValuePairs[1]),
        naam: "${event.routingKey}",
        waterniveau: int.parse(keyValuePairs[3]), 
        lichtniveau: int.parse(keyValuePairs[5]), 
        temperatuur: int.parse(keyValuePairs[7]), 
        bodemvocht: int.parse(keyValuePairs[9]), 
        luchtvochtigheid: int.parse(keyValuePairs[11]),
        tijd: tijd(),
      );
      
      //print('Inserting data');
      await insertDog(sensordata);
    });
  });
  */

  //final result = await conn.execute("SELECT 'foo'");
  //print(result[0][0]); // first row and first field

  runApp(const GrowthGuardianApp());

}

//This class is used to arrange local storage of plant profiles
class PlantStorage {
  //The localPath is required to obtain the local storage folder designated to the app by android
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  //The localFile getter uses the local file to access the storage file in the folder
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/plants.txt');
  }

  //The readplants function reads the existing file and returns the string contained within
  Future<String> readPlants() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  //The testSetup function seeds a profile into the local storage for testing purposes
  Future<File> testSetup() async{
    final file = await _localFile;
    return file.writeAsString("Woonkamer;Hoekplant,Charophyllum temulum;Bankplant,Aglaonema;Vette plant,Aeonium Crassulaceae/Badkamer;Hoekplant,Charophyllum temulum;Bankplant,Aglaonema;Vette plant,Aeonium Crassulaceae");
  }

  //The addPlant function takes the existing profile and adds a new plant to the correct location therein
  Future<File> addPlant(String room, String name, String scientificName, String plantCode) async {
    final file = await _localFile;
        
    //Calls for the existing storage string and waits until its recieved to actually add the plant to the file
    String plantListString = await readPlants();

    List<String> currentContent = plantListString.split("/");

    bool added = false;

    //Takes the split rooms and adds the plant to correct room if it already exists and that name is not already taken
    for(int i=0;i<currentContent.length;i++){
      //debugPrint(currentContent[i].toLowerCase());
      if(currentContent[i].toLowerCase().contains(room.toLowerCase())){
        if(!currentContent[i].contains(name)){
          currentContent[i] = currentContent[i]+";"+name+","+scientificName+","+plantCode;
        }
        added = true;
      }
    }

    //If the given room does not already exists the function adds the plant and room to the end of the current string
    if(!added){
      currentContent.add(room+";"+name+","+scientificName+","+plantCode);
    }

    // Write the file
    return file.writeAsString(currentContent.join("/"));
  }
  /*
  Future<String> switchToPlantPage(String room, String plantName, String scientificName, String locationImage) async{
    final page_controller = PageController(initialPage: 0,);
    page_controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    return '$room, $plantName, $scientificName, $locationImage';
  }*/
}

class GrowthGuardianApp extends StatelessWidget {
  const GrowthGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Growth Guardian',
      theme: ThemeData(
        colorScheme: const GrowthGuardianColorScheme(),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  //The content of the page controller directly alters the function of the pageView
  final page_controller = PageController(initialPage: 0,);

  //The selectedPage is the active page for the navigation bar
  int selectedPage = 0;

  //Active plant
  List<String> activePlantInformation = ['kelder', 'kelderplant', 'Narcissus papyraceus', 'locatie', 'cooleCode', ""]; 

  Map<String, dynamic> activePlantStats = {};

  List<String> warnings = [];

  final String database = "doggie_database.db";
  final String table = "dogs";

  final String testPlantName = "plantenpot";

  final Map<String,Map<String,dynamic>> idealEnvironmentPerSpecies = {
    "Adiantum caudatum":{
      "temperatuurMin":15,
      "temperatuurMax":25,
      "luchtvochtigheidMin":10,
      "luchtvochtigheidMax":50,
      "grondwaterniveauMin":50,
      "grondwaterniveauMax":100,
      "lichtintensiteitMin":10,
      "lichtintensiteitMax":50,
      "weekelijkseLichtUrenMin":50,
      "weekelijkseLichtUrenMax":100, 
    },
    "Dypsis lutescens":{
      "temperatuurMin":15,
      "temperatuurMax":25,
      "luchtvochtigheidMin":10,
      "luchtvochtigheidMax":50,
      "grondwaterniveauMin":50,
      "grondwaterniveauMax":100,
      "lichtintensiteitMin":10,
      "lichtintensiteitMax":50,
      "weekelijkseLichtUrenMin":50,
      "weekelijkseLichtUrenMax":100, 
    },
    "Ficus elastica":{
      "temperatuurMin":15,
      "temperatuurMax":25,
      "luchtvochtigheidMin":10,
      "luchtvochtigheidMax":50,
      "grondwaterniveauMin":50,
      "grondwaterniveauMax":100,
      "lichtintensiteitMin":10,
      "lichtintensiteitMax":50,
      "weekelijkseLichtUrenMin":50,
      "weekelijkseLichtUrenMax":100, 
    },
    "Narcissus papyraceus":{
      "temperatuurMin":15,
      "temperatuurMax":25,
      "luchtvochtigheidMin":30,
      "luchtvochtigheidMax":50,
      "grondwaterniveauMin":50,
      "grondwaterniveauMax":100,
      "lichtintensiteitMin":10,
      "lichtintensiteitMax":50,
      "weekelijkseLichtUrenMin":50,
      "weekelijkseLichtUrenMax":100, 
    },
    "Rhododendron simsii":{
      "temperatuurMin":15,
      "temperatuurMax":25,
      "luchtvochtigheidMin":10,
      "luchtvochtigheidMax":50,
      "grondwaterniveauMin":50,
      "grondwaterniveauMax":100,
      "lichtintensiteitMin":10,
      "lichtintensiteitMax":50,
      "weekelijkseLichtUrenMin":50,
      "weekelijkseLichtUrenMax":100, 
      },
     "Wetenschappelijke naam":{
      "temperatuurMin":15,
      "temperatuurMax":25,
      "luchtvochtigheidMin":10,
      "luchtvochtigheidMax":50,
      "grondwaterniveauMin":50,
      "grondwaterniveauMax":100,
      "lichtintensiteitMin":10,
      "lichtintensiteitMax":50,
      "weekelijkseLichtUrenMin":50,
      "weekelijkseLichtUrenMax":100, 
      }, 
    };

  @override
  void initState() {
    super.initState();

    get_data_from_postgresql_server();
    changeActivePlantStats(testPlantName);

    generateWarnings();
  }

  void generateWarnings(){
    makeWarnings(database,table,PlantStorage(),idealEnvironmentPerSpecies).then((List<String> newWarnings){
      setState(() {
        warnings = newWarnings;
      });
    });
    
    
  }

  void changeActivePlantStats(String plantName){
    print("ACTIVE PLANTTTTTTTTTTTTTTTTTT");
    print(plantName);
    //Grabs the latest entry of a plant and updates the state variable to be send to the plant page
    getLatestPlantInfo(database,table,plantName).then((newPlantInfo){
      print("AMOGUSUSUSUSUUSUSUSUSUSUUSUSUS");
      print(newPlantInfo);
      setState(() {
        activePlantStats = newPlantInfo;
      });
    });
  }

  @override
  void dispose() {
    page_controller.dispose();
    super.dispose();
  }

  //When the page changes due to the pageview this function is called
  void pageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  //When a navigation icon is pressed this function is called and switches the app to the desired page
  void navigationTapped(int index) {
    setState(() {
      selectedPage = index;
      goToPage(index);
    });
  }

  // 
  void switchToPlantPage(String room, String plantName, String scientificName, String locationImage, String plantCode) {
    String warningText = "";
    for(String warning in warnings){
      if(warning.contains(plantName) && warning.contains(room)){
        List<String> plantWarnings = warning.split(";");
        for(String plantWarning in plantWarnings){
          if(plantWarning.contains(plantName)){
            List<String> plantWarningInfo = plantWarning.split(",");
            warningText = plantWarningInfo[3];
          }
        }
      }

    }
    print(warningText);
    print(activePlantInformation.length);
    setState(() {
      activePlantInformation[0] = room;
      activePlantInformation[1] = plantName;
      activePlantInformation[2] = scientificName;
      activePlantInformation[3] = locationImage;
      activePlantInformation[4] = plantCode;
      activePlantInformation[5] = warningText;
    });
    print("PLANTCODDEEEEEEEEEEEEEEE");
    print(plantCode);
    changeActivePlantStats(plantCode);
    goToPage(2);
  }

  void goToPage(int index){
    page_controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The pageview holds all the seperate views of the app which contain all the content
      body: PageView(
        controller: page_controller,
        onPageChanged: (index){pageChanged(index);},
        children: [
          HomePage(storage: PlantStorage(), switchToPlantPage: switchToPlantPage, warnings: warnings,),
          ProblemPage(switchToPlantPage: switchToPlantPage, warnings: warnings,),
          PlantPage(activePlantInformation: activePlantInformation, activePlantStats: activePlantStats, idealEnvironmentPerSpecies: idealEnvironmentPerSpecies),
          AddPage(storage: PlantStorage(), goToPage: goToPage, idealEnvironmentPerSpecies: idealEnvironmentPerSpecies),
        ]
      ),
      //Below every page is the navigationbar to allow navigation and tell the user where they are
      bottomNavigationBar: NavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      indicatorColor: Theme.of(context).colorScheme.onPrimary,
      selectedIndex: selectedPage,
      onDestinationSelected: (index){navigationTapped(index);},
      destinations:  [
        NavigationDestination(
          icon: Icon(Icons.home,color: Theme.of(context).colorScheme.secondary,), 
          label: ''
        ),
        NavigationDestination(
          icon: Icon(Icons.announcement, color: Theme.of(context).colorScheme.secondary,), 
          label: ''
        ),
        NavigationDestination(
          icon: Icon(Icons.eco, color: Theme.of(context).colorScheme.secondary,), 
          label: ''
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle, color: Theme.of(context).colorScheme.secondary,), 
          label: ''
        ),
      ],
    ),

    );
  }
}


class GrowthGuardianColorScheme extends ColorScheme{
  static const Color primaryColor = Color(0xff2C8C39);
  static const Color onPrimaryColor = Color(0xffFFFFFF);

  static const Color secondaryColor = Color(0xffEFF5E0);
  static const Color onSecondaryColor = Color(0xff161412);

  static const Color surfaceColor = Color(0xffEFF5E0);
  static const Color onSurfaceColor = Color(0xff161412);
  
  static const Color backgroundColor = Color(0xffF7FAF0);
  static const Color onBackgroundColor = Color(0xff161412);

  static const Color errorColor = Color(0xffBA1200);
  static const Color onErrorColor = Color(0xffFFFFFF);
  
  // Override the constructor
    	const GrowthGuardianColorScheme({
    	// Set your custom colors as primary and secondary
    		Color primary = primaryColor,
        Color onPrimary = onPrimaryColor,
    		Color secondary = secondaryColor,
        Color onSecondary = onSecondaryColor,
        Color surface = surfaceColor,
        Color onSurface = onSurfaceColor,
        Color background = backgroundColor,
        Color onBackground = onBackgroundColor,
        Color error = errorColor,
        Color onError = onErrorColor,
    	
    	// Include other color properties from the super class
    	// such as background, surface, onBackground, etc.
    
    	}) : super(brightness: Brightness.light, primary: primary, secondary: secondary, background: background, onPrimary: onPrimary, onSecondary: onSecondary, onBackground: onBackground, surface: surface, onSurface: onSurface, error: error, onError: onError);
}

// Database columns
class Dog {
  final int id;
  final String naam;
  final int waterniveau;
  final int lichtniveau;
  final int temperatuur;
  final int bodemvocht;
  final int luchtvochtigheid;
  final int tijd;

  const Dog({
    required this.id,
    required this.naam,
    required this.waterniveau,
    required this.lichtniveau,
    required this.temperatuur,
    required this.bodemvocht,
    required this.luchtvochtigheid,
    required this.tijd,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'naam': naam,
      'waterniveau': waterniveau,
      'lichtniveau': lichtniveau,
      'temperatuur': temperatuur,
      'bodemvocht': bodemvocht,
      'luchtvochtigheid': luchtvochtigheid,
      'tijd': tijd,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, naam: $naam, waterniveau: $waterniveau, lichtniveau: $lichtniveau, temperatuur: $temperatuur, bodemvocht: $bodemvocht, luchtvochtigheid: $luchtvochtigheid}';
  }
}

Future<Map<String, dynamic>> getLatestPlantInfo(String database, String table, String plantName) async{
  final db = await openDatabase(database);

  plantName = "\"" + plantName + "\"";
  //grabs the latest record in the given table for the given plant
  String query = "SELECT * FROM "+ table + " WHERE naam = " + plantName + " ORDER BY tijd DESC LIMIT 1";
  print(query);
  try {
    List<Map<String,dynamic>> list = await db.rawQuery(query);
    //print('Done ' + plantName);
    return list[0];
  } catch (Exception) {
    print('An error occurred!');
    print(Exception);
    return {};
  }
}

void get_data_from_postgresql_server() async {
  //Code for the database
  //print(await getDatabasesPath()); 
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'doggie_database.db'),

    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, naam TEXT, waterniveau INTEGER, lichtniveau INTEGER, temperatuur INTEGER, bodemvocht INTEGER, luchtvochtigheid INTEGER, tijd INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'] as int,
        naam: maps[i]['naam'] as String,
        waterniveau: maps[i]['waterniveau'] as int,
        lichtniveau: maps[i]['lichtniveau'] as int,
        temperatuur: maps[i]['temperatuur'] as int,
        bodemvocht: maps[i]['bodemvocht'] as int,
        luchtvochtigheid: maps[i]['luchtvochtigheid'] as int,
        tijd: maps[i]['tijd'] as int,
      );
    });
  }

  final conn = await Connection.open(Endpoint(
    host: '136.144.163.112',
    database: 'sensordata',
    username: 'hugoheijmans',
    password: 'ditiseenhugoheijmanswachtwoord@#135',
  ));

  final result = await conn.execute("SELECT * FROM sensordata_table ORDER BY id;");
  print(result);
  for(var r in result) {
    var sensordata = Dog(
        id: r[0] as int,
        naam: r[1] as String,
        waterniveau: r[2] as int, 
        lichtniveau: r[3] as int, 
        temperatuur: r[4] as int, 
        bodemvocht: r[5] as int, 
        luchtvochtigheid: r[6] as int,
        tijd: r[7] as int,
      );
      
      await insertDog(sensordata);
  }

// Future<List<String>> makeWarnings(String database, String table, PlantStorage storage, Map<String,Map<String,dynamic>> idealEnvironmentPerSpecies) async {
//   List<String> warnings = [];
//   String fullStorageString = await storage.readPlants();
//   List<String> allRooms = fullStorageString.split("/");
//   allRooms.forEach((roomListString) {
//     if(roomListString != ""){
//       List<String> roomList = roomListString.split(";");
//       String room = roomList[0];
//       String roomWarning = room;
//       roomList.remove(room);
//       roomList.forEach((plantString) {
//         List<String> plantList = plantString.split(",");
//         // getLatestPlantInfo(database,table,plantList[2]).then((Map<String, dynamic> plantData){
//         getLatestPlantInfo(database,table,"plantenpot").then((Map<String, dynamic> plantData){
//           print(plantData);
//           String warning = makeWarning(idealEnvironmentPerSpecies[plantList[1]]!, plantData);
//           print(warning);
//           if(warning != "") roomWarning = roomWarning + ";"+ plantList[1] + "," + warning;
//           print(roomWarning);
//         });
//       });
//       print("iets");
//       print(roomWarning);
//       if(roomWarning != room) warnings.add(roomWarning);
//       print(warnings);
//     }
//   });
//   print(warnings);
//   print("werkt");
//   return warnings;
// }

// String makeWarning(Map<String,dynamic> idealEnvironment,Map<String, dynamic> plantData){
//   String warning = "";
//   if(plantData["waterniveau"] == 0){
//     warning = "Waterreservoir moet bijgevuld worden!";
//   }
//   else if(plantData["temperatuur"]<idealEnvironment["temperatuurMin"]){
//     warning = "Kamer temperatuur te laag voor deze plant!";
//   }
//   else if(plantData["temperatuur"]>idealEnvironment["temperatuurMax"]){
//     warning = "Kamer temperatuur te hoog voor deze plant!";
//   }
//   //light warnings need to be here
//   else if(plantData["luchtvochtigheid"]<idealEnvironment["luchtvochtigheidMin"]){
//     warning = "De luchtvochtigheid is te laag voor deze plant!";
//   }
//   else if(plantData["luchtvochtigheid"]>idealEnvironment["luchtvochtigheidMax"]){
//     warning = "De luchtvochtigheid is te hoog voor deze plant";
//   }

//   return warning;
// }
}

Future<List<String>> makeWarnings(String database, String table, PlantStorage storage, Map<String,Map<String,dynamic>> idealEnvironmentPerSpecies) async {
  List<String> warnings = [];
  String fullStorageString = await storage.readPlants();
  List<String> allRooms = fullStorageString.split("/");
  for(var roomListString in allRooms){
    if(roomListString != ""){
      List<String> roomList = roomListString.split(";");
      String room = roomList[0];
      String roomWarning = room;
      roomList.remove(room);
      for(var plantString in roomList){
        List<String> plantList = plantString.split(",");
        print('AMOGUS ' + plantList.toString());
        Map<String, dynamic> plantData = await getLatestPlantInfo(database,table,plantList[2]);

        print('jemoeder' + plantList[1].toString());
        Map<String, dynamic>? plantResult = idealEnvironmentPerSpecies[plantList[1]]!;
        print("jemoeder" + plantData.isEmpty.toString());
        if(plantData.isNotEmpty) {
          String warning = makeWarning(plantResult, plantData);
          if(warning != "") roomWarning = roomWarning + ";"+ plantList[0] + "," + plantList[1] + "," + plantList[2] + "," + warning;
        }
        print("plantList: " + plantList.toString());
        print("roomwarning: " + roomWarning);
      }
      if(roomWarning != room) warnings.add(roomWarning);
    }
  }
  return warnings;
}

String makeWarning(Map<String,dynamic> idealEnvironment,Map<String, dynamic> plantData){
  String warning = "";
  if(plantData["waterniveau"] == 3){
    warning = "Waterreservoir moet bijgevuld worden!";
  }
  else if(plantData["temperatuur"]<idealEnvironment["temperatuurMin"]){
    warning = "Kamer temperatuur te laag voor deze plant!";
  }
  else if(plantData["temperatuur"]>idealEnvironment["temperatuurMax"]){
    warning = "Kamer temperatuur te hoog voor deze plant!";
  }
  //light warnings need to be here
  else if(plantData["luchtvochtigheid"]<idealEnvironment["luchtvochtigheidMin"]){
    warning = "De luchtvochtigheid is te laag voor deze plant!";
  }
  else if(plantData["luchtvochtigheid"]>idealEnvironment["luchtvochtigheidMax"]){
    warning = "De luchtvochtigheid is te hoog voor deze plant";
  }

  return warning;
}