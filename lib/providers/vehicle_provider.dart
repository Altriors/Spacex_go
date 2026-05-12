import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/models/rocket_model.dart';
import '../data/models/capsule_model.dart';
import '../data/models/ship_model.dart';

class VehicleProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<RocketModel> _rockets = [];
  List<CapsuleModel> _capsules = [];
  List<ShipModel> _ships = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<RocketModel> get rockets => _rockets;
  List<CapsuleModel> get capsules => _capsules;
  List<ShipModel> get ships => _ships;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  
Future<void> fetchRockets() async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _rockets = await _apiService.fetchRockets(); 
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _isLoading = false;
    notifyListeners();
  }
}



  /// Placeholder Capsule fetch (if added later)
  Future<void> fetchCapsules() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _capsules = []; // No capsule API implemented yet
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Placeholder Ship fetch (if added later)
  Future<void> fetchShips() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _ships = []; // No ship API implemented yet
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
