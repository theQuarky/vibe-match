import 'package:mobx/mobx.dart';
import 'package:intl/intl.dart';
import 'package:yoto/services/serverless_service.dart';
import 'package:yoto/services/graphql_service.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStore with _$ProfileStore;

abstract class _ProfileStore with Store {
  final ServerlessService _serverlessService = ServerlessService();
  final Graphqlservice _graphqlService = Graphqlservice();

  @observable
  Map<String, dynamic>? profileData;

  @computed
  bool get isProfileComplete =>
      profileData != null && profileData!['profileCompleted'] == true;

  @action
  Future<void> fetchProfileData() async {
    try {
      final fetchedData = await _graphqlService.getUserProfile();
      if (fetchedData != null) {
        profileData = fetchedData;
        // Convert birthDate string to DateTime
        if (profileData!['birthDate'] != null) {
          profileData!['birthDate'] =
              DateFormat('yyyy-MM-dd').parse(profileData!['birthDate']);
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      profileData = null;
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
}
