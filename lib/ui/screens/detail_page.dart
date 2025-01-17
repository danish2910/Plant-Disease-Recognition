import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/models/plants.dart';

class DetailPage extends StatefulWidget {
  final int plantId;
  const DetailPage({Key? key, required this.plantId}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Toggle Favorite button
  // bool toggleIsFavorited(bool isFavorited) {
  //   return !isFavorited;
  // }

  // Toggle add/remove from cart
  // bool toggleIsSelected(bool isSelected) {
  //   return !isSelected;
  // }

  // Expandable sections states
  bool isDescriptionExpanded = true;
  bool isCareTipsExpanded = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Plant> _plantList = Plant.plantList;
    return Scaffold(
      body: Stack(
        children: [
          // Close and Favorite Buttons
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image and Features Section
          Positioned(
            top: 50,
            left: 50,
            right: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .4, // Adjust height as needed
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image Section
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      _plantList[widget.plantId].imageURL,
                      fit: BoxFit.contain, // Ensures the image scales nicely
                      height: 250, // Adjust height to constrain the image
                    ),
                  ),
                  const SizedBox(width: 20), // Add horizontal spacing between image and features
                  // Plant Features Section
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlantFeature(
                          title: 'Type',
                          plantFeature: _plantList[widget.plantId].type,
                        ),
                        const SizedBox(height: 10), // Add spacing between features
                        PlantFeature(
                          title: 'Severity',
                          plantFeature: _plantList[widget.plantId].severity,
                        ),
                        const SizedBox(height: 10), // Add spacing between features
                        PlantFeature(
                          title: 'Temperature',
                          plantFeature: _plantList[widget.plantId].temperature,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Description Section with Header and Collapsible Panels
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              height: size.height * 0.5,
              width: size.width,
              decoration: BoxDecoration(
                color: Constants.primaryColor.withOpacity(.4),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Disease Name Header
                    Text(
                      _plantList[widget.plantId].plantName, // Replace with disease name
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                      ),
                    ),
                    const SizedBox(height: 5), // Spacing below the header
                    
                    // Description Section
                    ExpansionTile(
                      title: Text(
                        'Description',
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      initiallyExpanded: isDescriptionExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          isDescriptionExpanded = expanded;
                        });
                      },
                      children: [
                        Text(
                          _plantList[widget.plantId].description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 18,
                            color: Constants.blackColor.withOpacity(.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // Care Tips Section
                    ExpansionTile(
                      title: Text(
                        'Disease Management',
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      initiallyExpanded: isCareTipsExpanded,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          isCareTipsExpanded = expanded;
                        });
                      },
                      children: [
                        Text(
                          _plantList[widget.plantId].careTips,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 18,
                            color: Constants.blackColor.withOpacity(.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PlantFeature Widget
class PlantFeature extends StatelessWidget {
  final String plantFeature;
  final String title;
  const PlantFeature({
    Key? key,
    required this.plantFeature,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Constants.blackColor,
          ),
        ),
        Text(
          plantFeature,
          style: TextStyle(
            color: Constants.primaryColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
