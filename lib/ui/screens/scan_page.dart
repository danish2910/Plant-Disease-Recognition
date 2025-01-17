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

  Future<int> processImage() async {
    if (imagePath != null) {
      var uri = Uri.parse(
          'https://danish.muniza.fyi/infer/'); // Replace with your API URL
      var request =
          http.MultipartRequest('POST', uri); // Assuming the method is POST
      var imageFile = await http.MultipartFile.fromPath(
          'image', imagePath!); // 'image' is the key here
      request.files.add(imageFile);

      try {
        var streamedResponse = await request.send();

        if (streamedResponse.statusCode == 200) {
          var responseBody = await streamedResponse.stream.bytesToString();

          Map<String, dynamic> responseMap = jsonDecode(responseBody);
          var predictions = responseMap['predictions'];

          if (predictions != null && predictions is List && predictions.isNotEmpty) {
            List<double> predictionValues = List<double>.from(predictions[0]);
            classification = await getSortedPredictionMap(predictionValues);

            var highestConfidenceEntry = classification!.entries.first;
            if (highestConfidenceEntry.value < 0.8) {
              Plant matchedPlant = Plant(
                key: 'Unknown',
                plantId: -1,
                category: 'Unknown',
                plantName: 'Unknown Plant',
                type: 'Unknown Type',
                rating: 0.0,
                severity: "Unknown",
                temperature: 'N/A',
                imageURL: 'assets/images/unknown.png',
                // isFavorated: false,
                description: 'No description available',
                careTips:'',
                // isSelected: false,
              );

              // Add to inference history using the provider
              Provider.of<InferenceHistoryProvider>(context, listen: false)
                  .addInference({
                'plantName': matchedPlant.plantName,
                'confidence': highestConfidenceEntry.value,
                'timestamp': DateTime.now().toString(),
                "imagePath": imagePath!
              });

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

            } else {
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
                  // isFavorated: false,
                  description: 'No description available',
                  careTips:'',
                  // isSelected: false,
                ),
              );

              // Add to inference history using the provider
              Provider.of<InferenceHistoryProvider>(context, listen: false)
                  .addInference({
                'plantName': matchedPlant.plantName,
                'confidence': highestConfidenceEntry.value,
                'timestamp': DateTime.now().toString(),
                "imagePath": imagePath!
              });

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
    if (cameraIsAvailable) {
      _initializeControllerFuture = _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      cameraList = await availableCameras();
      final cameraUsed = cameraList.first;
      _controller = CameraController(
        cameraUsed,
        ResolutionPreset.medium,
      );
      await _controller.initialize();
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    if (cameraIsAvailable) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<Map<String, double>> getSortedPredictionMap(List<double> predictionValues) async {
    String labelsContent = await rootBundle.loadString('assets/labels.txt');
    List<String> labels = LineSplitter.split(labelsContent).toList();

    Map<String, double> predictionMap = {};
    if (labels.length == predictionValues.length) {
      for (int i = 0; i < predictionValues.length; i++) {
        predictionMap[labels[i]] = predictionValues[i];
      }
    } else {
      throw Exception('The number of labels does not match the number of prediction values.');
    }

    var sortedPredictionMap = Map.fromEntries(
      predictionMap.entries.toList()
        ..sort((e1, e2) => e2.value.compareTo(e1.value)),
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
            decoration: BoxDecoration(/*gradient: Constants().linearGradientBlue*/color: Colors.white),
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && _controller.value.isInitialized) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: CameraPreview(_controller),
                              ),
                            ),
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
                                        content: Text("Check your internet connection and try again."),
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
                                    final result = await imagePicker.pickImage(source: ImageSource.gallery);
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
                                          content: Text("Check your internet connection and try again."),
                                        ),
                                      );
                                      return;
                                    }
                                  },
                                  child: const Text("Choose image from gallery"))
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
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
