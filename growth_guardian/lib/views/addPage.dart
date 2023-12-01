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
    return Container();
  }
}