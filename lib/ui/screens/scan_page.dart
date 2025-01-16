// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fypapp/models/plants.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fypapp/weather_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fypapp/models/inference_history_provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? imagePath;
  final imagePicker = ImagePicker();
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  late List<CameraDescription> cameraList;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;
  //List<Map<String, dynamic>> inferenceHistory =
  // []; // List to store inference history

  void cleanResult() {
    imagePath = null;
    image = null;
    classification = null;
    setState(() {});
  }

  Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final cameraImage = await _controller.takePicture();
      imagePath = cameraImage.path;
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  // Process picked image
  Future<int> processImage() async {
    // returns -1 if API is inaccessible
    // returns 0 if api returns result
    if (imagePath != null) {
      // Step 2: Create a multipart request using the correct key name expected by the server
      var uri = Uri.parse(
          'https://danish.muniza.fyi/infer/'); // Replace with your API URL
      var request =
          http.MultipartRequest('POST', uri); // Assuming the method is POST
      // Step 3: Add the image to the request with the correct key name
      // If the API expects the key 'image', use that here.
      var imageFile = await http.MultipartFile.fromPath(
          'image', imagePath!); // 'image' is the key here
      request.files.add(imageFile);
      // request.headers["X-API-KEY"] = "myapp_key";

      // Step 4: Send the request
      try {
        var streamedResponse = await request.send();

        // Step 5: Check the response status code
        if (streamedResponse.statusCode == 200) {
          // Step 6: Read the response body
          var responseBody = await streamedResponse.stream.bytesToString();

          // Parse the response body to a Map<String, dynamic>
          Map<String, dynamic> responseMap = jsonDecode(responseBody);

          // Extract the predictions list from the response
          var predictions = responseMap['predictions'];

          // Check if predictions is not empty and is a list of lists
          if (predictions != null &&
              predictions is List &&
              predictions.isNotEmpty) {
            // Flatten the predictions (the inner list is a single list of numbers)
            List<double> predictionValues = List<double>.from(predictions[0]);

            classification = await getSortedPredictionMap(predictionValues);

            //Get highest confidence
            var highestConfidenceEntry = classification!.entries.first;
            Plant matchedPlant = Plant.plantList.firstWhere(
              (plant) => plant.key == highestConfidenceEntry.key,
              orElse: () => Plant(
                key: 'Unknown',
                plantId: -1,
                category: 'Unknown',
                plantName: 'Unknown Plant',
                type: 'Unknown Type',
                rating: 0.0,
                severity: "Unknown",
                temperature: 'N/A',
                imageURL: 'assets/images/unknown.png',
                isFavorated: false,
                description: 'No description available',
                isSelected: false,
              ),
            );

            if (matchedPlant != null) {
              // Add to inference history using the provider
              Provider.of<InferenceHistoryProvider>(context, listen: false)
                  .addInference({
                'plantName': matchedPlant.plantName,
                'confidence': highestConfidenceEntry.value,
                'timestamp': DateTime.now().toString(),
                "imagePath": imagePath!
              });
              // Show plant details in a popup
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(matchedPlant.plantName),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Type: ${matchedPlant.type}'),
                      Text('Severity: ${matchedPlant.severity}'),
                      Text('Temperature: ${matchedPlant.temperature}'),
                      const SizedBox(height: 10),
                      Text(
                        'Description:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(matchedPlant.description),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }

            return 0;
          }
        } else {
          return -1;
        }
      } catch (e) {
        // Catch any errors that might occur during the request
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error during request: $e'),
          ),
        );
      }
    }
    return -1;
  }

  @override
  void initState() {
    super.initState();

    // Initialize the camera controller if cameras are available
    if (cameraIsAvailable) {
      _initializeControllerFuture = _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Get the list of available cameras
      cameraList = await availableCameras();

      // Use the first available camera
      final cameraUsed = cameraList.first;

      // Create the camera controller
      _controller = CameraController(
        cameraUsed,
        ResolutionPreset.medium,
      );

      // Initialize the controller
      await _controller.initialize();
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    // Dispose of the camera controller if initialized
    if (cameraIsAvailable) {
      _controller.dispose();
    }
    super.dispose();
  }

  // Function to get the sorted prediction map based on prediction values

  Future<Map<String, double>> getSortedPredictionMap(
      List<double> predictionValues) async {
    // Load labels from the assets/labels.txt file using rootBundle
    String labelsContent = await rootBundle.loadString('assets/labels.txt');

    // Split the content by lines to get the individual labels
    List<String> labels = LineSplitter.split(labelsContent).toList();

    // Create a map with label as the key and the corresponding prediction value as the value
    Map<String, double> predictionMap = {};

    // Check if the number of labels matches the number of prediction values
    if (labels.length == predictionValues.length) {
      for (int i = 0; i < predictionValues.length; i++) {
        predictionMap[labels[i]] = predictionValues[i];
      }
    } else {
      throw Exception(
          'The number of labels does not match the number of prediction values.');
    }

    // Sort the map by the prediction value in descending order
    var sortedPredictionMap = Map.fromEntries(
      predictionMap.entries.toList()
        ..sort((e1, e2) =>
            e2.value.compareTo(e1.value)), // Sorting in descending order
    );

    return sortedPredictionMap;
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraIsAvailable) {
      return const Center(child: Text("Camera not available on this device."));
    }

    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: Constants().linearGradientBlue),
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _controller.value.isInitialized) {
                  // Camera initialized, show the preview
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // Camera Preview with border radius
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CameraPreview(_controller),
                              ),
                            ),

                            // Positioned widget for centered text at the top
                            // Opacity(
                            //   opacity: 0.7,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(top: 20),
                            //     child: Align(
                            //       alignment: Alignment.topCenter,
                            //       // Align to the right of the Stack
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(5),
                            //             gradient: Constants().linearGradientPurple,
                            //           ),
                            //           child: const Padding(
                            //             padding: EdgeInsets.all(8.0),
                            //             child: Text(
                            //               "Align the food within camera view.",
                            //               textAlign: TextAlign
                            //                   .center, // Center text inside the container
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton.filled(
                                onPressed: () async {
                                  cleanResult();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await takePicture();
                                  var res = await processImage();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (res == -1) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Text("It failed"),
                                      ),
                                    );
                                    return;
                                  }
                                },
                                icon: const Icon(Icons.camera_enhance_sharp),
                                iconSize: 40,
                                padding: const EdgeInsets.all(20),
                              ),
                              const Divider(
                                indent: 100,
                                endIndent: 100,
                              ),
                              TextButton(
                                  onPressed: () async {
                                    cleanResult();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final result = await imagePicker.pickImage(
                                        source: ImageSource.gallery);
                                    imagePath = result?.path;
                                    var res = await processImage();
                                    print(classification);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (res == -1) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Text("It failed"),
                                        ),
                                      );
                                      return;
                                    }
                                  },
                                  child:
                                      const Text("Choose image from gallery"))
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  // Loading state
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned.fill(
              child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _isLoading
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        )),
                  )
                : const SizedBox(),
          ))
        ],
      ),
    );
  }
}