// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/models/inference_history_provider.dart';
import 'package:fypapp/models/plants.dart';
import 'package:fypapp/ui/screens/detail_page.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    // Fetch inference history when the page is loaded
    Provider.of<InferenceHistoryProvider>(context, listen: false)
        .fetchInferenceHistory();
  }

  Widget buildImage(BuildContext context, String? imageBase64,
      String? imagePath, Timestamp timestamp, Map<String, dynamic> history) {
    Widget imageWidget;

    if (imageBase64 != null) {
      imageWidget = Image.memory(base64Decode(imageBase64));
    } else if (imagePath != null) {
      imageWidget = Image.file(File(imagePath));
    } else {
      return SizedBox.shrink(); // Return empty widget if no image
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: timestamp,
                child: imageWidget,
              ),
              Text(history["plantName"]),
            ],
          ),
        ),
      )),
      child: Hero(
        tag: timestamp,
        child: imageWidget,
      ),
    );
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
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                          // Positioned(
                          //   top: 10,
                          //   right: 20,
                          //   child: Container(
                          //     height: 50,
                          //     width: 50,
                          //     child: IconButton(
                          //       onPressed: () {
                          //         setState(() {
                          //           bool isFavorited = toggleIsFavorated(
                          //               filteredPlants[index].isFavorated);
                          //           filteredPlants[index].isFavorated =
                          //               isFavorited;
                          //         });
                          //       },
                          //       icon: Icon(
                          //         filteredPlants[index].isFavorated == true
                          //             ? Icons.favorite
                          //             : Icons.favorite_border,
                          //         color: Constants.primaryColor,
                          //       ),
                          //       iconSize: 30,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(50),
                          //     ),
                          //   ),
                          // ),
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
            // Inference History Section
            Container(
              padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: const Text(
                'Inference History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            // Display Inference History
            Consumer<InferenceHistoryProvider>(
              builder: (context, inferenceHistoryProvider, child) {
                List<Map<String, dynamic>> inferenceHistory =
                    inferenceHistoryProvider.inferenceHistory;
                // DateTime parseCustomTimestamp(String timestamp) {
                //   // Define the format of the timestamp string
                //   DateFormat customFormat =
                //       DateFormat("d MMMM yyyy 'at' HH:mm:ss 'UTC'Z");

                //   // Remove the " UTC+8" part from the string
                //   timestamp = timestamp.replaceAll(RegExp(r' UTC.*'), ' UTC+0');

                //   // Parse the timestamp string into a DateTime object
                //   return customFormat.parse(timestamp);
                // }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: size.height * .3,
                  child: ListView.builder(
                    itemCount: inferenceHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      var history = inferenceHistory[index];

                      // Check if the timestamp is of type Firestore Timestamp
                      DateTime takeTime;
                      if (history['timestamp'] is Timestamp) {
                        // Convert Firestore Timestamp to DateTime
                        takeTime = (history['timestamp'] as Timestamp).toDate();
                      } else {
                        // If timestamp is already a string (parse the string into DateTime)
                        takeTime =
                            DateTime.parse(history['timestamp'].toString());
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        child: ListTile(
                          leading: buildImage(
                            context,
                            history['image'], // image in base64 format
                            history['imagePath'], // image from file path
                            history["timestamp"] is String ?  Timestamp.fromDate(DateTime.parse(history["timestamp"])) : history["timestamp"], // unique tag for Hero
                            history,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            "Inference on ${DateFormat("h:m:s a, d MMM yyyy").format(takeTime)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            history['plantName'].toString(),
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
