import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save String
  Future<bool> saveString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  // Get String
  String? getString(String key) {
    return _prefs!.getString(key);
  }

  // Save Bool
  Future<bool> saveBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  // Get Bool
  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  // Save Int
  Future<bool> saveInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  // Get Int
  int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  // Save List
  Future<bool> saveList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  // Get List
  List<String>? getList(String key) {
    return _prefs!.getStringList(key);
  }

  // Save Object (as JSON)
  Future<bool> saveObject(String key, Map<String, dynamic> value) async {
    String jsonString = json.encode(value);
    return await _prefs!.setString(key, jsonString);
  }

  // Get Object (from JSON)
  Map<String, dynamic>? getObject(String key) {
    String? jsonString = _prefs!.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  // Remove
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  // Clear All
  Future<bool> clearAll() async {
    return await _prefs!.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}