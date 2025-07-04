// lib/provider/detection_provider.dart
import 'package:flutter/material.dart';

class DetectionProvider with ChangeNotifier {
  String token = '';
  String detectionId = '';

  void setDetectionInfo({
    required String newToken,
    required String newDetectionId,
  }) {
    token = newToken;
    detectionId = newDetectionId;
    notifyListeners();
  }

  void clear() {
    token = '';
    detectionId = '';
    notifyListeners();
  }
}
