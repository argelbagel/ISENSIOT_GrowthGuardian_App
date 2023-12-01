import 'package:flutter/material.dart';
import 'package:growth_guardian/views/addPage.dart';
import 'package:growth_guardian/views/homePage.dart';
import 'package:growth_guardian/views/plantPage.dart';
import 'package:growth_guardian/views/problemPage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
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
  Future<File> addPlant(String room, String name, String scientificName) async {
    final file = await _localFile;
        
    //Calls for the existing storage string and waits until its recieved to actually add the plant to the file
    String plantListString = await readPlants();

    List<String> currentContent = plantListString.split("/");

    bool added = false;

    //Takes the split rooms and adds the plant to correct room if it already exists and that name is not already taken
    for(int i=0;i<currentContent.length;i++){
      if(currentContent[i].contains(room)){
        if(!currentContent[i].contains(name)){
          currentContent[i] = currentContent[i]+";"+name+","+scientificName;
        }
        added = true;
      }
    }

    //If the given room does not already exists the function adds the plant and room to the end of the current string
    if(!added){
      currentContent.add(room+";"+name+","+scientificName);
    }

    // Write the file
    return file.writeAsString(currentContent.join("/"));
  }
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
      page_controller.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The pageview holds all the seperate views of the app which contain all the content
      body: PageView(
        controller: page_controller,
        onPageChanged: (index){pageChanged(index);},
        children: [
          HomePage(storage: PlantStorage(),),
          ProblemPage(),
          PlantPage(),
          AddPage(storage: PlantStorage(),),    
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