import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'dart:io' as io;
import '../main.dart' show PlantStorage;
import 'package:growth_guardian/widget/clasifier.dart';
import 'package:image/image.dart' as img;
import 'dart:math';

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.storage, required this.goToPage, required this.idealEnvironmentPerSpecies});

  final PlantStorage storage;
  final Function goToPage;
  final Map<String,Map<String,dynamic>> idealEnvironmentPerSpecies;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String imagePath = "";

  bool pictureActive = false;
  bool loadingPrediction = false;

  String plantWetenschappelijk = 'Wetenschappelijke naam';

  CameraController? _cameraController;

  bool cameraInitialised = false;

  String idealTemp = "...";
  String idealHumid = "...";
  String idealLight = "...";

  @override
  void initState() {
    super.initState();

    initializeCamera();
  }

  Future<void> initializeCamera() async{
    final cameras = await availableCameras();
    print("Available Cameras:");
    for (final camera in cameras) {
      print("Camera ${camera.name}");
    }

    if (cameras.isNotEmpty) {
      _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      //_initializeControllerFuture = _cameraController?.initialize();
      await _cameraController?.initialize();
      setState(() {
        cameraInitialised = true;
      });
    }
  }

  Future<void> takePicture() async{
    try {
      final image = await _cameraController!.takePicture();
      String picturePath = image.path;
      await cropSquare(picturePath, picturePath, false);
      img.Image convertedImage = img.decodeImage(await File(picturePath).readAsBytes())!;
      
      // CameraImage temp = image;
      // img.Image? convertedImage = await img.decodeImageFile(image.path);
      print("taken picture");
      setState(() {
        imagePath = picturePath;
        loadingPrediction = true;
        pictureActive = true;
      });
      String prediction =  await classifyImage(convertedImage);
      setState(() {
        plantWetenschappelijk = prediction;
        loadingPrediction = false;
      });
      setIdealValues();
    } 
    catch (e) {
      print(e);
    }
  }

  void resetPicture(){
    File(imagePath).delete();
    setState(() {
      pictureActive = false;
      imagePath = "";
      plantWetenschappelijk = 'Wetenschappelijke naam';
    });
    removeIdealValues();
  }

  void setIdealValues(){
    setState(() {
      final speciesInfo = widget.idealEnvironmentPerSpecies[plantWetenschappelijk]!;
      idealTemp = speciesInfo["temperatuurMin"].toString() + " - " + speciesInfo["temperatuurMax"].toString() + " C";
      idealHumid = speciesInfo["luchtvochtigheidMin"].toString() + " - " + speciesInfo["luchtvochtigheidMax"].toString() + " %";
      idealLight = speciesInfo["lichtintensiteitMin"].toString() + " - " + speciesInfo["lichtintensiteitMax"].toString() + " Lux";
    });
  }

  void removeIdealValues(){
    setState(() {
      idealTemp = "...";
      idealHumid = "...";
      idealLight = "...";
    });
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _plantNaam = TextEditingController();
    TextEditingController _plantCode = TextEditingController();
    TextEditingController _plantLocatie = TextEditingController();

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
                  
                  child: pictureActive
                  ? Image(image: FileImage(File(imagePath)))
                  : cameraInitialised
                  ? CameraPreview(_cameraController!)
                  : Center(child: CircularProgressIndicator())
                  // FutureBuilder<void>(
                  //   future: _initializeControllerFuture,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       return CameraPreview(_cameraController!);
                  //     } else {
                  //       return Center(child: CircularProgressIndicator());
                  //     }
                  //   },
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        '$plantWetenschappelijk',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      IconButton(onPressed: (){
                        if(!pictureActive) takePicture();
                        else{
                          if(!loadingPrediction) resetPicture();
                        }
                      }, icon: loadingPrediction
                      ?  CircularProgressIndicator()
                      : pictureActive
                      ? Icon(Icons.undo)
                      : Icon(Icons.add_a_photo)
                      )
                    ],
                  ),
                ),
              ),
            ),
            addTextField(fieldController: _plantNaam, labelText: 'Geef de plant een herkenbare naam',),
            addTextField(fieldController: _plantLocatie, labelText: 'Waar staat de plant in het huis?',),
            addTextField(fieldController: _plantCode, labelText: 'Wat is de code van de plantenpot?',),
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
                          Text(idealTemp),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 75.0, top: 10.0),
                      child: Row(
                        children: [
                          Text('Luchtvochtigheid: '),
                          Text(idealHumid),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 75.0,top: 10.0),
                      child: Row(
                        children: [
                          Text('Lichtniveau: '),
                        Text(idealLight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
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
                    onPressed: () async {
                      //widget.storage.testSetup(); // Purge local storage/reset data
                      if (_plantLocatie.text.isEmpty || _plantNaam.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error!"),
                              content: Text("Can't add plant without plant name and location."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } 
                      else {
                        
                        print('Original path: ${imagePath}');
                        String dir = path.dirname(imagePath);
                        String newFile = path.join(dir, _plantLocatie.text, '_${_plantNaam.text.toLowerCase()}.jpg');
                        String newDirectoryPath  = path.join(dir, _plantLocatie.text);
                        print('NewPath: ${newDirectoryPath}');   

                        Directory newDirectory = Directory(newDirectoryPath);
                        print('newDirectory: ${newDirectory}');

                        if (!(await newDirectory.exists())) {
                          await newDirectory.create(recursive: true);
                          print('Directory doesnt exists');
                          try {
                            io.File(imagePath).renameSync(newFile);
                            print('File renamed successfully.');
                          } 
                          catch (e) {
                            print('Error while renaming the file: $e');
                          }    
                        }
                        else {
                          try {
                            io.File(imagePath).renameSync(newFile);
                            print('File renamed successfully.');
                          } 
                          catch (e) {
                            print('Error while renaming the file: $e');
                          }    
                        }



                        widget.storage.addPlant(_plantLocatie.text, _plantNaam.text, plantWetenschappelijk, _plantCode.text);
                        
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Plant Added!"),
                              content: Text("Go back to your home screen to see your newly added plant."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget.goToPage(0);
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class addTextField extends StatelessWidget {
  const addTextField({super.key, required this.fieldController, required this.labelText});

  final TextEditingController fieldController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Container(
        height: 50,
        child: TextField(
          controller: fieldController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            labelText: labelText,
          ),
        ),
      ),
    );
  }
}

Future cropSquare(String srcFilePath, String destFilePath, bool flip) async {
  var bytes = await File(srcFilePath).readAsBytes();
  img.Image src = img.decodeImage(bytes)!;

  src = img.copyRotate(src, 90);

  var cropSize = min(src.width, src.height);
  int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
  int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

  img.Image destImage =
    img.copyCrop(src, offsetX, offsetY, cropSize, cropSize);

  if (flip) {
      destImage = img.flipVertical(destImage);
  }

  var jpg = img.encodeJpg(destImage);
  await File(destFilePath).writeAsBytes(jpg);
}

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
),
Padding(
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
),
*/

// class PlantDropdownTextInput extends StatelessWidget {
//   PlantDropdownTextInput({super.key, required this.changeSelectedSpecies});


//   final Function changeSelectedSpecies;

//   final String labelText = "Wat voor soort plant is het?";
//   final List<String> plantSpecies = ["Andiantum","Cactus", "Varen"];
  

//   @override
//   Widget build(BuildContext context) {
//     return FormField<T>(
//       builder: (FormFieldState<T> state) {
//         return InputDecorator(
//           decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(
//                 horizontal: 20.0, vertical: 15.0),
//             labelText: labelText,
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
//           ),
//           isEmpty: value == null || value == '',
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isDense: true,
//               onChanged: (value){},
//               items: options.map((String value) {
//                 return DropdownMenuItem<T>(
//                   value: value,
//                   child: Text(getLabel(value)),
//                 );
//               }).toList(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }