import 'package:flutter/material.dart';
import 'package:growth_guardian/views/addPage.dart';
import 'package:growth_guardian/views/homePage.dart';
import 'package:growth_guardian/views/plantPage.dart';
import 'package:growth_guardian/views/problemPage.dart';

void main() {
  runApp(const GrowthGuardianApp());
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
  final page_controller = PageController(initialPage: 0,);

  int selectedPage = 0;

  @override
  void dispose() {
    page_controller.dispose();
    super.dispose();
  }

  void pageChanged(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  void navigationTapped(int index) {
    setState(() {
      selectedPage = index;
      page_controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: page_controller,
        onPageChanged: (index){pageChanged(index);},
        children: [
          HomePage(),
          ProblemPage(),
          PlantPage(),
          AddPage(),    
        ]
      ),
      bottomNavigationBar: NavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      indicatorColor: Theme.of(context).colorScheme.onPrimary,
      selectedIndex: selectedPage,
      onDestinationSelected: (index){navigationTapped(index);},
      destinations:  [
        NavigationDestination(
          icon: Icon(Icons.home, color: Theme.of(context).colorScheme.secondary,), 
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