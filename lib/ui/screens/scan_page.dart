import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  String? imagePath;
  final imagePicker = ImagePicker();
  img.Image? image;
  Map<String, double>? classification;
  bool cameraIsAvailable = Platform.isAndroid || Platform.isIOS;
  late List<CameraDescription> cameraList;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;

  void cleanResult(){
    imagePath = null;
    image = null;
    classification = null;
    setState(() {
    });
  }

  Future<void> takePicture() async {
    try{
      await _initializeControllerFuture;
      final cameraImage = await _controller.takePicture();
      imagePath = cameraImage.path;
    }catch (e) {
      print(e);
    }
  }

  //Process picked image
  Future<int> processImage() async {
    // returns -1 if API is inaccessible
    // returns 0 if API returns result
    if (imagePath != null){
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
      request.headers["X-API-KEY"] = "myapp_key";
    }
  }