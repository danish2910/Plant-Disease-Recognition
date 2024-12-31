import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  // Function to submit feedback to Firebase
  Future<void> _submitFeedback() async {
    String feedbackText = _feedbackController.text.trim();
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? 'Anonymous';  // Default to 'Anonymous' if no user is logged in

    if (feedbackText.isNotEmpty) {
      try {
        // Sending the feedback to Firebase Firestore
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'feedback': feedbackText,
          'email': userEmail,  // Include the user's email in the feedback
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
        _feedbackController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Give Feedback'),
      //   backgroundColor: Constants.primaryColor,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Image.asset('assets/images/feedback.png'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
              ),
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
