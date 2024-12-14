import 'package:flutter/material.dart';

class InferenceHistoryProvider with ChangeNotifier {
  // The list of inference history
  List<Map<String, dynamic>> _inferenceHistory = [];

  // Getter to access the history
  List<Map<String, dynamic>> get inferenceHistory => _inferenceHistory;

  // Method to add a new inference to the history
  void addInference(Map<String, dynamic> inference) {
    _inferenceHistory.add(inference);
    notifyListeners();  // Notify listeners to update the UI
  }
}
