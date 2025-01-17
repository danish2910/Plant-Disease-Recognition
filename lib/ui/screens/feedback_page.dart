import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fypapp/constants.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  File? _imageFile;  // To hold the image file

  // Function to pick an image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to convert the image to base64
  Future<String?> _convertImageToBase64() async {
    if (_imageFile == null) return null;

    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String base64String = base64Encode(imageBytes);
      return base64String;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error converting image: $e')),
      );
      return null;
    }
  }

  // Function to submit feedback to Firebase
  Future<void> _submitFeedback() async {
    String titleText = _titleController.text.trim();
    String feedbackText = _feedbackController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? 'Anonymous';  // Default to 'Anonymous' if no user is logged in

    if (titleText.isNotEmpty && feedbackText.isNotEmpty) {
      try {
        // Convert the image to base64 if selected
        String? base64Image = await _convertImageToBase64();

        // Sending the feedback to Firebase Firestore
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'title': titleText,
          'feedback': feedbackText,
          'email': userEmail,
          'timestamp': FieldValue.serverTimestamp(),
          'image': base64Image,  // Store the base64 image string
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
        _titleController.clear();
        _feedbackController.clear();
        setState(() {
          _imageFile = null;  // Clear the image after submission
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out both title and feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Image.asset('assets/images/feedbackphoto.png'),
              ),
              const SizedBox(height: 10),
              Text(
                'We value your feedback!',
                style: TextStyle(
                  color: Constants.primaryColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              // Title Section
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter a title for your feedback...',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Feedback Section
              TextField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Constants.primaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              // Image Section
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt),  // Camera icon for picking image
                    const SizedBox(width: 8),
                    //Text('Pick an Image'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Display the selected image preview
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 10),
              // Submit Button
              ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primaryColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send),  // Send icon
                    const SizedBox(width: 8),
                    Text('Submit'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
