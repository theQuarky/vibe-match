import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/profile_store.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:yoto/screens/profile_edit_screen.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ProfileScreen extends StatelessWidget {
  final String? userId;

  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
    );
  }

  void _logout(BuildContext context) async {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    await authStore.signOut();
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final profileStore = Provider.of<ProfileStore>(context);
    final authStore = Provider.of<AuthStore>(context);
    final isCurrentUser =
        userId == null || userId == authStore.currentUser?.uid;

    return Observer(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(profileStore.profileData?['displayName'] ?? 'Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: isCurrentUser
              ? [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _logout(context),
                  ),
                ]
              : null,
        ),
        body: profileStore.profileData == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          profileStore.profileData!['profileImageUrl'] ??
                              'https://via.placeholder.com/400x200',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profileStore.profileData!['displayName'] ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isCurrentUser)
                      Text(
                        authStore.currentUser?.email ?? 'No Email',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 30),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Bio',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        profileStore.profileData!['bio'] ?? 'No bio available',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.cake, color: Colors.grey),
                      title: Text(
                        profileStore.profileData!['birthDate'] != null
                            ? 'Born ${(profileStore.profileData!['birthDate'] as DateTime).toString().split(' ')[0]}'
                            : 'Birth date not set',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        profileStore.profileData!['gender'] == 'Male'
                            ? Icons.male
                            : Icons.female,
                        color: Colors.grey,
                      ),
                      title: Text(
                        profileStore.profileData!['gender'] ?? 'Gender not set',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
        floatingActionButton: isCurrentUser
            ? FloatingActionButton(
                onPressed: () => _editProfile(context),
                child: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}
