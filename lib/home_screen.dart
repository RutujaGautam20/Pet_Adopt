import 'package:adopt_app/history_screen.dart';
import 'package:adopt_app/pet_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pet {
  final String id;
  final String name;
  final String breed;
  final int age;
  final double price;
  final String image;
  bool isAdopted;
  DateTime? adoptionDate;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.price,
    required this.image,
    this.isAdopted = false,
    DateTime? adoptionDate,
  }) : adoptionDate = adoptionDate ?? DateTime.now();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Pet> allPets = [
    Pet(
      name: 'Buddy',
      breed: 'Labrador Retriever',
      age: 2,
      price: 600.0,
      image: 'assets/image/pet_image/pet1.jpg',
      id: '1',
    ),
    Pet(
      name: 'Max',
      breed: 'German Shepherd',
      age: 1,
      price: 500.0,
      image: 'assets/image/pet_image/pet2.jpg',
      id: '2',
    ),
    Pet(
      name: 'Tuffy',
      breed: 'French Bulldog',
      age: 3,
      price: 900.0,
      image: 'assets/image/pet_image/pet3.jpg',
      id: '3',
    ),
    Pet(
      name: 'Boss',
      breed: 'Golden Retriever',
      age: 1,
      price: 800.0,
      image: 'assets/image/pet_image/pet4.jpg',
      id: '4',
    ),
    Pet(
      name: 'Champ',
      breed: 'Poodle',
      age: 2,
      price: 700.0,
      image: 'assets/image/pet_image/pet5.jpg',
      id: '5',
    ),
    Pet(
      name: 'Biscuit',
      breed: 'Bulldog',
      age: 4,
      price: 700.0,
      image: 'assets/image/pet_image/pet6.jpg',
      id: '6',
    ),
    Pet(
      name: 'Butterball',
      breed: 'Rottweiler',
      age: 2,
      price: 800.0,
      image: 'assets/image/pet_image/pet7.jpg',
      id: '7',
    ),
    Pet(
      name: 'Boo',
      breed: 'Beagle',
      age: 2,
      price: 600.0,
      image: 'assets/image/pet_image/pet8.jpg',
      id: '8',
    ),
    Pet(
      name: ' Pony Bear',
      breed: 'Australian Shepherd',
      age: 1,
      price: 900.0,
      image: 'assets/image/pet_image/pet9.jpg',
      id: '9',
    ),
    Pet(
      name: 'Peanut',
      breed: 'Boxer',
      age: 1,
      price: 500.0,
      image: 'assets/image/pet_image/pet10.jpg',
      id: '10',
    ),
    Pet(
      name: ' Pupper',
      breed: 'Great Dane',
      age: 2,
      price: 400.0,
      image: 'assets/image/pet_image/pet11.jpg',
      id: '11',
    ),
    Pet(
      name: 'Tater',
      breed: 'Cane Corso',
      age: 3,
      price: 900.0,
      image: 'assets/image/pet_image/pet12.jpg',
      id: '12',
    ),
    Pet(
      name: 'Tiny',
      breed: 'Doberman Pinscher',
      age: 1,
      price: 500.0,
      image: 'assets/image/pet_image/pet13.jpg',
      id: '13',
    ),
    Pet(
      name: ' Moose',
      breed: 'Dachshund',
      age: 2,
      price: 600.0,
      image: 'assets/image/pet_image/pet14.jpg',
      id: '14',
    ),
    Pet(
      name: 'Tootsie',
      breed: 'Pug',
      age: 1,
      price: 800.0,
      image: 'assets/image/pet_image/pet15.jpg',
      id: '15',
    ),
  ];
  List<Pet> adoptedPets = [];

  List<Pet> displayedPets = [];
  int itemsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    filterPets('');
    loadAdoptionState();
    printSharedPreferences();
  }

  void loadAdoptionState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      allPets.forEach((pet) {
        pet.isAdopted = prefs.getBool(pet.id) ?? false;
      });
    });
  }

  void saveAdoptionState(String petId, bool isAdopted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(petId, isAdopted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Home Page',
            style:
                TextStyle(fontFamily: 'ProtestRevolution', color: Colors.grey),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              navigateToHistoryScreen();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: Text(
              'Go to History',
              style: TextStyle(
                fontFamily: 'ProtestRevolution',
                color: Colors.indigo,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                currentPage = 0; // Reset page when search changes
                filterPets(value);
              },
              style: TextStyle(
                  fontFamily: 'ProtestRevolution', color: Colors.grey),
              decoration: InputDecoration(
                  labelText: 'Search pets by name',
                  labelStyle: TextStyle(
                      fontFamily: 'ProtestRevolution', color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              cursorColor: Colors.grey,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedPets.length + 1,
              itemBuilder: (context, index) {
                if (index == displayedPets.length) {
                  return buildLoadMoreButton();
                } else {
                  return ListTile(
                    title: Text(
                      displayedPets[index].name,
                      style: TextStyle(
                          fontFamily: 'ProtestRevolution', color: Colors.grey),
                    ),
                    subtitle: Text(
                      displayedPets[index].breed,
                      style: TextStyle(
                          fontFamily: 'ProtestRevolution', color: Colors.grey),
                    ),
                    onTap: () {
                      onPetSelected(displayedPets[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadMoreButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            currentPage++;
            filterPets(searchController.text);
          });
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        child: Text(
          'Load More',
          style:
              TextStyle(fontFamily: 'ProtestRevolution', color: Colors.indigo),
        ),
      ),
    );
  }

  void printSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Adoption State for each pet:');
    for (Pet pet in allPets) {
      bool isAdopted = prefs.getBool(pet.id) ?? false;
      print('${pet.name}: $isAdopted');
    }
  }

  void navigateToHistoryScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
            adoptedPets: allPets.where((p) => p.isAdopted).toList()),
      ),
    );
  }

  void filterPets(String query) {
    query = query.toLowerCase();
    List<Pet> filteredPets =
        allPets.where((pet) => pet.name.toLowerCase().contains(query)).toList();

    int startIndex = currentPage * itemsPerPage;
    int endIndex = (currentPage + 1) * itemsPerPage;

    setState(() {
      displayedPets =
          filteredPets.sublist(0, endIndex.clamp(0, filteredPets.length));
    });
  }

  void onPetSelected(Pet selectedPet) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PetDetailsScreen(
                pet: selectedPet,
                onAdopted: () {
                  setState(() {
                    selectedPet.isAdopted = true;
                    saveAdoptionState(selectedPet.id, true);
                  });
                })));
  }
}
