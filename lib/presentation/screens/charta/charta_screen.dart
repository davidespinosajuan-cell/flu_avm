import 'package:flutter/material.dart';

class ChartaScreen extends StatefulWidget {
  const ChartaScreen({super.key});

  @override
  State<ChartaScreen> createState() => _ChartaScreenState();
}

class _ChartaScreenState extends State<ChartaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text('Mapas'),
        ),
       );
    }
  }