import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InferenceHistoryProvider with ChangeNotifier {
  // The list of inference history
  List<Map<String, dynamic>> _inferenceHistory = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter to access the history
  List<Map<String, dynamic>> get inferenceHistory => _inferenceHistory;

  // Fetch inference history from Firestore
  Future<void> fetchInferenceHistory() async {
  if (_auth.currentUser != null) {
    try {
      // Get current user's uid
      String uid = _auth.currentUser!.uid;

      // Fetch the user's inference history from Firestore
      var querySnapshot = await _firestore
          .collection('inference_history')
          .doc(uid)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .get();

      _inferenceHistory = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // Ensure the timestamp is properly converted
        if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
          data['timestamp'] = DateFormat('yyyy-MM-dd - HH:mm')
              .format((data['timestamp'] as Timestamp).toDate());
        } else {
          data['timestamp'] = 'Unknown Time'; // Handle missing or invalid timestamp
        }

        return data;
      }).toList();
      
      notifyListeners(); // Notify listeners about the update
    } catch (e) {
      print('Error fetching inference history: $e');
    }
  }
}

  // Add a new inference to Firestore
  Future<void> addInference(Map<String, dynamic> inference) async {
    if (_auth.currentUser != null) {
      try {
        // Get current user's uid
        String uid = _auth.currentUser!.uid;

        // Add the inference data to Firestore
        await _firestore
            .collection('inference_history')
            .doc(uid)
            .collection('history')
            .add({
          'timestamp': FieldValue.serverTimestamp(),
          'plantName': inference['plantName'],
          'result': inference['result'],
        });

        // Optionally, update local state after successful addition
        _inferenceHistory.insert(0, inference);  // Add to the top
        notifyListeners();
      } catch (e) {
        print('Error adding inference: $e');
      }
    }
  }
}
