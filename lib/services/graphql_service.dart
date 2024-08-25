import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class Graphqlservice {
  static const String url =
      'https://d9cuoxk4x9.execute-api.ap-south-1.amazonaws.com/Prod/graphql/';

  static Future<String?> _getToken() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    return await user?.getIdToken();
  }

  static Future<Map<String, dynamic>?> _sendRequest(String query,
      {Map<String, dynamic>? variables}) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    print('Token (first 10 chars): ${token.substring(0, 10)}...');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final body = jsonEncode({'query': query, 'variables': variables ?? {}});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    const String query = '''
      query {
        getUserProfile {
          displayName
          bio
          profileCompleted
          birthDate
          profileImageUrl
          gender
        }
      }
    ''';

    final result = await _sendRequest(query);

    if (result == null || result['errors'] != null) {
      print('GraphQL query error: ${result?['errors']}');
      return null;
    }

    if (result['data'] == null || result['data']['getUserProfile'] == null) {
      print('No data returned from the query');
      return null;
    }

    final Map<String, dynamic> userProfile = result['data']['getUserProfile'];

    // Transform the data into the desired shape
    Map<String, dynamic> transformedProfile = {
      'profileImageUrl': userProfile['profileImageUrl'],
      'gender': userProfile['gender'] == 'female' ? 'Female' : 'Male',
      'displayName': userProfile['displayName'],
      'profileCompleted': userProfile['profileCompleted'],
      'bio': userProfile['bio'],
      'birthDate': _formatDate(userProfile['birthDate']),
    };
    print('Transformed profile: $transformedProfile');
    return transformedProfile;
  }

  Future<Map<String, dynamic>?> getFriendProfile(String friendId) async {
    final String query = '''
      query {
        getFriendProfile(friendId: "$friendId") {
          displayName
          bio
          profileCompleted
          birthDate
          profileImageUrl
          gender
        }
      }
    ''';

    final result = await _sendRequest(query);

    if (result == null || result['errors'] != null) {
      print('GraphQL query error: ${result?['errors']}');
      return null;
    }

    if (result['data'] == null || result['data']['getFriendProfile'] == null) {
      print('No data returned from the query');
      return null;
    }

    final Map<String, dynamic> friendProfile =
        result['data']['getFriendProfile'];

    // Transform the data into the desired shape
    Map<String, dynamic> transformedProfile = {
      'profileImageUrl': friendProfile['profileImageUrl'],
      'gender': friendProfile['gender'] == 'female' ? 'Female' : 'Male',
      'displayName': friendProfile['displayName'],
      'profileCompleted': friendProfile['profileCompleted'],
      'bio': friendProfile['bio'],
      'birthDate': _formatDate(friendProfile['birthDate']),
    };
    print('Transformed profile: $transformedProfile');
    return transformedProfile;
  }

  String _formatDate(String timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
