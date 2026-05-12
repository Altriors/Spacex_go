import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../../core/constants/api_constants.dart';
import '../models/launch_model.dart';
import '../models/rocket_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();

  final Box _launchesCache = Hive.box('launches_cache');
  final Box _vehiclesCache = Hive.box('vehicles_cache');

  // ===================================================
  // 🚀 FETCH LAUNCHES (Cached + Retry + Rate Limit Safe)
  // ===================================================
  Future<List<LaunchModel>> fetchLaunches({bool upcoming = false}) async {
    final cacheKey = upcoming ? 'upcoming_launches' : 'past_launches';
    final cacheTimestampKey = '${cacheKey}_timestamp';

    // Try cache first
    final cachedData = _launchesCache.get(cacheKey);
    final cachedTimestamp = _launchesCache.get(cacheTimestampKey);

    if (cachedData != null && cachedTimestamp != null) {
      final cacheAge = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(cachedTimestamp));
      final maxAge = upcoming
          ? const Duration(hours: 2)
          : const Duration(hours: 12);

      if (cacheAge < maxAge) {
        print('✅ Using cached ${upcoming ? "upcoming" : "past"} launches');
        final Map<String, dynamic> jsonData = jsonDecode(cachedData);
        final List<dynamic> results = jsonData['results'] ?? [];
        return results.map((json) => LaunchModel.fromJson(json)).toList();
      }
    }

    // API request
    final url =
        upcoming ? ApiConstants.launchesUpcoming : ApiConstants.launchesPast;
    final uri = Uri.parse('$url?limit=50');

    try {
      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> results = jsonData['results'] ?? [];

        await _launchesCache.put(cacheKey, response.body);
        await _launchesCache.put(
          cacheTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        print('✅ Launch data fetched successfully (${results.length} items)');
        return results.map((json) => LaunchModel.fromJson(json)).toList();
      } else if (response.statusCode == 429) {
        print('⚠️ Rate limit (429) — using cached data if available.');
        if (cachedData != null) {
          final Map<String, dynamic> jsonData = jsonDecode(cachedData);
          final List<dynamic> results = jsonData['results'] ?? [];
          return results.map((json) => LaunchModel.fromJson(json)).toList();
        }
        throw Exception('Rate limit hit (429). Try again later.');
      } else {
        throw Exception('Failed to load launches: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching launches: $e');
      if (cachedData != null) {
        print('⚠️ Using cached data due to error.');
        final Map<String, dynamic> jsonData = jsonDecode(cachedData);
        final List<dynamic> results = jsonData['results'] ?? [];
        return results.map((json) => LaunchModel.fromJson(json)).toList();
      }
      rethrow;
    }
  }

  // ===================================================
  // 🚀 FETCH NEXT LAUNCH
  // ===================================================
  Future<LaunchModel?> fetchNextLaunch() async {
    try {
      final uri = Uri.parse('${ApiConstants.launchesNext}?limit=1');
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final List<dynamic> results = jsonData['results'] ?? [];
        return results.isNotEmpty ? LaunchModel.fromJson(results.first) : null;
      } else if (response.statusCode == 429) {
        print('⚠️ Rate limited (429) on next launch — skipping.');
        return null;
      } else {
        throw Exception('Failed to load next launch');
      }
    } catch (e) {
      print('❌ Error fetching next launch: $e');
      return null;
    }
  }

  // ===================================================
  // 🚀 FETCH ROCKETS (Uses SpaceX API)
  // ===================================================
  Future<List<RocketModel>> fetchRockets() async {
    const cacheKey = 'rockets';
    const cacheTimestampKey = 'rockets_timestamp';

    final cachedData = _vehiclesCache.get(cacheKey);
    final cachedTimestamp = _vehiclesCache.get(cacheTimestampKey);

    if (cachedData != null && cachedTimestamp != null) {
      final cacheAge = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(cachedTimestamp));
      if (cacheAge < const Duration(hours: 6)) {
        print('✅ Using cached rockets data');
        final dynamic decoded = jsonDecode(cachedData);
        if (decoded is List) {
          return decoded.map((json) => RocketModel.fromJson(json)).toList();
        } else if (decoded is Map && decoded.containsKey('results')) {
          return (decoded['results'] as List)
              .map((json) => RocketModel.fromJson(json))
              .toList();
        }
      }
    }

    try {
      final uri = Uri.parse(ApiConstants.rockets);
      print('🌍 Fetching rockets from: $uri');

      final response = await _client.get(uri);
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        final rockets =
            decoded.map((json) => RocketModel.fromJson(json)).toList();

        await _vehiclesCache.put(cacheKey, response.body);
        await _vehiclesCache.put(
          cacheTimestampKey,
          DateTime.now().millisecondsSinceEpoch,
        );

        print('✅ Rockets data fetched successfully');
        return rockets;
      } else {
        throw Exception('Failed to load rockets: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching rockets: $e');
      if (cachedData != null) {
        final dynamic decoded = jsonDecode(cachedData);
        if (decoded is List) {
          return decoded.map((json) => RocketModel.fromJson(json)).toList();
        }
      }
      rethrow;
    }
  }

  // ===================================================
  // 🧹 CLEAR CACHE
  // ===================================================
  Future<void> clearCache() async {
    await _launchesCache.clear();
    await _vehiclesCache.clear();
    print('🧹 Cache cleared successfully');
  }
}
