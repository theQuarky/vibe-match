import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yoto/services/location_service.dart';
import 'package:yoto/widgets/search_animation.dart';
import 'package:yoto/widgets/search_button.dart';
import 'package:yoto/stores/match_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocationService _locationService = LocationService();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    _currentPosition = await _locationService.getCurrentLocation(context);
  }

  Future<void> startSearch(MatchStore matchStore) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // Immediately update UI
    matchStore.setInQueue(true);

    try {
      Map<String, dynamic> requestBody = {
        'userId': userId,
      };

      if (_currentPosition != null) {
        requestBody['location'] = {
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
        };
      }

      // Perform background operations
      await matchStore.addToMatchQueue(requestBody);
      matchStore.startListeningForMatches(userId, () {
        stopSearch(matchStore);
        Navigator.of(context)
            .pushNamed('/temp_chat', arguments: matchStore.currentMatch);
      });
    } catch (e) {
      print("Error during search process: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting search: $e')),
      );
      // Revert UI state if there's an error
      matchStore.setInQueue(false);
    }
  }

  Future<void> stopSearch(MatchStore matchStore) async {
    // Immediately update UI
    matchStore.setInQueue(false);

    try {
      // Perform background operations
      await matchStore.removeFromMatchQueue();
      matchStore.stopListeningForMatches();
    } catch (e) {
      print('Error stopping search: $e');
      // Optionally revert UI state if there's an error
      // matchStore.setInQueue(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchStore = Provider.of<MatchStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Match'),
      ),
      body: Center(
        child: Observer(
          builder: (_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (matchStore.isInQueue) const SearchAnimation(),
              const SizedBox(height: 20),
              SearchButton(
                isSearching: matchStore.isInQueue,
                onStartSearch: () => startSearch(matchStore),
                onStopSearch: () => stopSearch(matchStore),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final matchStore = Provider.of<MatchStore>(context, listen: false);
    matchStore.stopListeningForMatches();
    super.dispose();
  }
}
