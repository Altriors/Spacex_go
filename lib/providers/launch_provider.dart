import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/models/launch_model.dart';

class LaunchProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<LaunchModel> _allLaunches = [];
  List<LaunchModel> _upcomingLaunches = [];
  List<LaunchModel> _pastLaunches = [];
  LaunchModel? _latestLaunch;

  bool _isLoading = false;
  String? _errorMessage;

  List<LaunchModel> get allLaunches => _allLaunches;
  List<LaunchModel> get upcomingLaunches => _upcomingLaunches;
  List<LaunchModel> get pastLaunches => _pastLaunches;
  LaunchModel? get latestLaunch => _latestLaunch;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all launches (both past + upcoming combined)
  Future<void> fetchAllLaunches() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Fetch past + upcoming separately, merge
      final past = await _apiService.fetchLaunches(upcoming: false);
      final upcoming = await _apiService.fetchLaunches(upcoming: true);

      _allLaunches = [...upcoming, ...past];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch only upcoming launches
  Future<void> fetchUpcomingLaunches() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final allUpcoming = await _apiService.fetchLaunches(upcoming: true);

      // Filter to show only launches with future or TBD dates
      final now = DateTime.now();
      _upcomingLaunches = allUpcoming.where((launch) {
        if (launch.dateUtc == null) return true;
        return launch.dateUtc!.isAfter(now);
      }).toList();

      // Sort by date
      _upcomingLaunches.sort((a, b) {
        if (a.dateUtc == null && b.dateUtc == null) return 0;
        if (a.dateUtc == null) return 1;
        if (b.dateUtc == null) return -1;
        return a.dateUtc!.compareTo(b.dateUtc!);
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch past launches
  Future<void> fetchPastLaunches() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _pastLaunches = await _apiService.fetchLaunches(upcoming: false);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch the next (latest) launch
  Future<void> fetchLatestLaunch() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _latestLaunch = await _apiService.fetchNextLaunch();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Find a launch by its ID
  LaunchModel? getLaunchById(String id) {
    try {
      return _allLaunches.firstWhere((launch) => launch.id == id);
    } catch (_) {
      return null;
    }
  }
}
