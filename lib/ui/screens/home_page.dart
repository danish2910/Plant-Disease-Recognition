// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/models/inference_history_provider.dart';
import 'package:fypapp/models/diseases.dart';
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
  List<Disease> _diseaseList = Disease.diseaseList;
  String searchQuery = ""; // Tracks search input

  // Diseases categories
  List<String> _diseaseTypes = [
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

  // Filter the diseases based on selected category and search query
  List<Disease> _getFilteredDiseases() {
    List<Disease> filteredDiseases;
    if (selectedIndex == 0) {
      filteredDiseases = _diseaseList; // Show all diseases for 'All'
    } else {
      String selectedCategory = _diseaseTypes[selectedIndex];
      filteredDiseases = _diseaseList
          .where((disease) => disease.category == selectedCategory)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredDiseases = filteredDiseases
          .where((disease) =>
              disease.diseaseName.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return filteredDiseases;
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

    // Wrap imageWidget with ClipRRect to apply rounded corners
    imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
      child: imageWidget,
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: timestamp,
                child: imageWidget, // Hero with rounded corners
              ),
              SizedBox(
                height: 10,
              ),
              Text(history["diseaseName"],
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      )),
      child: Hero(
        tag: timestamp,
        child: imageWidget, // Hero with rounded corners
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
                itemCount: _diseaseTypes.length,
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
                            _diseaseTypes[index],
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
            // Horizontal List of Diseases
            SizedBox(
              height: size.height * .3,
              child: ListView.builder(
                itemCount: _getFilteredDiseases().length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  List<Disease> filteredDiseases = _getFilteredDiseases();
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: DetailPage(
                            diseaseId: filteredDiseases[index].diseaseId,
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
                                  Image.asset(filteredDiseases[index].imageURL),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filteredDiseases[index].category,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  filteredDiseases[index].diseaseName,
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
                            history["timestamp"] is String
                                ? Timestamp.fromDate(
                                    DateTime.parse(history["timestamp"]))
                                : history["timestamp"], // unique tag for Hero
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
                            history['diseaseName'].toString(),
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
