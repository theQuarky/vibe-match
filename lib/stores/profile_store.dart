import 'package:mobx/mobx.dart';
import 'package:intl/intl.dart';
import 'package:yoto/services/serverless_service.dart';
import 'package:yoto/services/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final ServerlessService _serverlessService = ServerlessService();
  final Graphqlservice _graphqlService = Graphqlservice();
  final String _cacheKey = 'profile_cache';

  @observable
  Map<String, dynamic>? profileData;

  @computed
  bool get isProfileComplete =>
      profileData != null && profileData!['profileCompleted'] == true;

  @action
  Future<void> fetchProfileData() async {
    try {
      // First, try to load from cache
      await _loadFromCache();

      // Then, fetch from server
      final fetchedData = await _graphqlService.getUserProfile();
      if (fetchedData != null) {
        profileData = fetchedData;
        // Convert birthDate string to DateTime
        if (profileData!['birthDate'] != null) {
          profileData!['birthDate'] =
              DateFormat('yyyy-MM-dd').parse(profileData!['birthDate']);
        }
        // Save to cache
        await _saveToCache();
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      // If there's an error, we'll use the cached data (if available)
    }
  }

  @action
  Future<void> updateProfile(Map<String, dynamic> newData) async {
    try {
      await _serverlessService.updateProfile(newData,
          isNew: profileData == null || profileData!.isEmpty);
      await fetchProfileData(); // Fetch updated data to ensure consistency
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  @action
  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      profileData = jsonDecode(cachedData);
      if (profileData!['birthDate'] != null) {
        profileData!['birthDate'] = DateTime.parse(profileData!['birthDate']);
      }
    }
  }

  @action
  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final dataToCache = Map<String, dynamic>.from(profileData!);
    if (dataToCache['birthDate'] != null) {
      dataToCache['birthDate'] =
          (dataToCache['birthDate'] as DateTime).toIso8601String();
    }
    await prefs.setString(_cacheKey, jsonEncode(dataToCache));
  }
}
