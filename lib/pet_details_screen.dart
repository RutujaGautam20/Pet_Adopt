import 'dart:math';

import 'package:adopt_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:confetti/confetti.dart';

class PetDetailsScreen extends StatelessWidget {
  final Pet pet;
  final Function() onAdopted;
  final ConfettiController _confettiController = ConfettiController();

  PetDetailsScreen({required this.pet, required this.onAdopted});
  static const routeName = '/petdetailsscreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 55),
          child: Text(
            'Details Page',
            style:
                TextStyle(fontFamily: 'ProtestRevolution', color: Colors.grey),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(
                  'Name: ${pet.name}', FontWeight.bold, 20.0, Colors.grey),
              SizedBox(
                height: 5,
              ),
              _buildText(
                  'Breed: ${pet.breed}', FontWeight.bold, 20.0, Colors.grey),
              SizedBox(
                height: 5,
              ),
              _buildText(
                  'Age: ${pet.age} years', FontWeight.bold, 20.0, Colors.grey),
              SizedBox(
                height: 5,
              ),
              _buildText('Price: \$${pet.price.toStringAsFixed(2)}',
                  FontWeight.bold, 20.0, Colors.grey),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(right: 150),
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PhotoViewGallery(
                  pageController: PageController(),
                  backgroundDecoration: BoxDecoration(),
                  pageOptions: [
                    PhotoViewGalleryPageOptions(
                      imageProvider: AssetImage(pet.image),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                maxBlastForce: 100,
                minBlastForce: 80,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink],
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!pet.isAdopted) {
                        showAdoptionMessage(context, pet.name);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: pet.isAdopted ? Colors.grey : Colors.indigo,
                    ),
                    child: Text(
                      pet.isAdopted ? 'Already Adopted' : 'Adopt Me',
                      style: TextStyle(
                          fontFamily: 'ProtestRevolution',
                          fontSize: 18.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(
      String text, FontWeight fontWeight, double fontSize, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'ProtestRevolution',
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  void showAdoptionMessage(BuildContext context, String petName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Congratulations!',
            style: TextStyle(fontFamily: 'ProtestRevolution'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You have now adopted $petName.',
                style: TextStyle(fontFamily: 'ProtestRevolution'),
              ),
              SizedBox(height: 16),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confettiController
                      .play(); // Play confetti when the button is pressed
                  // Update the pet's adoption status
                  pet.isAdopted = true;
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'ProtestRevolution', color: Colors.indigo),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
