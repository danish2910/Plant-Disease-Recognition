// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/models/plants.dart';
import 'package:fypapp/ui/screens/detail_page.dart';
import 'package:fypapp/ui/screens/widgets/plant_widget.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; // Keeps track of selected category
  List<Plant> _plantList = Plant.plantList;
  String searchQuery = ""; // Tracks search input

  // Plants categories
  List<String> _plantTypes = [
    'All',
    'Bacterial',
    'Fungal',
    'Pest',
    'Viral',
  ];

  // Toggle Favorite button
  bool toggleIsFavorated(bool isFavorited) {
    return !isFavorited;
  }

  // Filter the plants based on selected category and search query
  List<Plant> _getFilteredPlants() {
    List<Plant> filteredPlants;
    if (selectedIndex == 0) {
      filteredPlants = _plantList; // Show all plants for 'All'
    } else {
      String selectedCategory = _plantTypes[selectedIndex];
      filteredPlants = _plantList
          .where((plant) => plant.category == selectedCategory)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredPlants = filteredPlants
          .where((plant) =>
              plant.plantName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filteredPlants;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value; // Update the search query
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black54.withOpacity(.6),
                        ),
                        hintText: 'Search Plant Disease',
                        filled: true,
                        fillColor: Constants.primaryColor.withOpacity(.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            // Category Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 50.0,
              width: size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _plantTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index; // Update selected category
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Constants.primaryColor
                              : Constants.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _plantTypes[index],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Constants.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Horizontal List of Plants
            SizedBox(
              height: size.height * .3,
              child: ListView.builder(
                itemCount: _getFilteredPlants().length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  List<Plant> filteredPlants = _getFilteredPlants();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: DetailPage(
                            plantId: filteredPlants[index].plantId,
                          ),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            right: 20,
                            child: Container(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    bool isFavorited = toggleIsFavorated(
                                        filteredPlants[index].isFavorated);
                                    filteredPlants[index].isFavorated =
                                        isFavorited;
                                  });
                                },
                                icon: Icon(
                                  filteredPlants[index].isFavorated == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Constants.primaryColor,
                                ),
                                iconSize: 30,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 30, // Adjust as needed for positioning
                            right: 30, // Adjust as needed for positioning
                            top: 30, // Adjust as needed for positioning
                            bottom: 30, // Adjust as needed for positioning
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors
                                    .white70, // Replace with desired background color
                              ),
                              padding: const EdgeInsets.all(
                                  5), // Adjust padding for image size
                              child:
                                  Image.asset(filteredPlants[index].imageURL),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredPlants[index].category,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  filteredPlants[index].plantName,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Constants.primaryColor.withOpacity(.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Vertical List of New Plants
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'New Plants',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: size.height * .5,
              child: ListView.builder(
                itemCount: _getFilteredPlants().length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  List<Plant> filteredPlants = _getFilteredPlants();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: DetailPage(
                            plantId: filteredPlants[index].plantId,
                          ),
                          type: PageTransitionType.bottomToTop,
                        ),
                      );
                    },
                    child: PlantWidget(
                      index: index,
                      plantList: filteredPlants,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
