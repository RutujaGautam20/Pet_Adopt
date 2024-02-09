import 'package:adopt_app/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:timeline_tile/timeline_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatelessWidget {
  final List<Pet> adoptedPets;

  HistoryScreen({required this.adoptedPets});

  @override
  Widget build(BuildContext context) {
    // Sort adopted pets by adoption date in descending order
    adoptedPets.sort((a, b) => b.adoptionDate!.compareTo(a.adoptionDate!));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Adoption History',
          style: TextStyle(
              fontFamily: 'ProtestRevolution',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
        ),
      ),
      body: ListView.builder(
        itemCount: adoptedPets.length,
        itemBuilder: (context, index) {
          return TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY:
                0.1, // Adjust this value to control the position of the line
            indicatorStyle: IndicatorStyle(
              width: 20,
              color: Colors.indigo,
              padding: EdgeInsets.all(6),
            ),

            endChild: ListTile(
              //    leading: Text('Adopted on'),
              title: Text(
                '${adoptedPets[index].name}\n${adoptedPets[index].adoptionDate}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'ProtestRevolution',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
