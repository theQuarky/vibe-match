import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yoto/stores/profile_store.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';

class ProfileEditScreen extends StatefulWidget {
  final bool isNewUser;

  const ProfileEditScreen({Key? key, this.isNewUser = false}) : super(key: key);

  @override
  ProfileEditScreenState createState() => ProfileEditScreenState();
}

class ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  DateTime? _birthDate;
  String? _gender;
  XFile? _imageFile;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return; // Add this check
    final profileStore = Provider.of<ProfileStore>(context, listen: false);
    if (profileStore.profileData != null) {
      if (!mounted) return; // Add this check
      setState(() {
        _nameController.text = profileStore.profileData!['displayName'] ?? '';
        _bioController.text = profileStore.profileData!['bio'] ?? '';
        _birthDate = (profileStore.profileData!['birthDate'] as DateTime?);
        _gender = profileStore.profileData!['gender'];
        _imageUrl = profileStore.profileData!['profileImageUrl'];
      });
    } else {
      await profileStore.fetchProfileData();
      if (!mounted) return; // Add this check
      setState(() {
        _nameController.text = profileStore.profileData!['displayName'] ?? '';
        _bioController.text = profileStore.profileData!['bio'] ?? '';
        _birthDate = (profileStore.profileData!['birthDate'] as DateTime?);
        _gender = profileStore.profileData!['gender'];
        _imageUrl = profileStore.profileData!['profileImageUrl'];
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final profileStore = Provider.of<ProfileStore>(context, listen: false);
        final authStore = Provider.of<AuthStore>(context, listen: false);

        String? imageUrl = _imageUrl;
        if (_imageFile != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_profiles/${authStore.currentUser!.uid}');
          await ref.putFile(File(_imageFile!.path));
          imageUrl = await ref.getDownloadURL();
        }

        final updatedData = {
          'displayName': _nameController.text,
          'bio': _bioController.text,
          'birthDate': _birthDate,
          'gender': _gender.toString().toLowerCase(),
          'profileImageUrl': imageUrl,
          'profileCompleted': true,
        };

        await profileStore.updateProfile(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Please select a birth date';
    }

    final today = DateTime.now();
    final age = today.year - birthDate.year;
    final isBirthdayPassedThisYear = (today.month > birthDate.month) ||
        (today.month == birthDate.month && today.day >= birthDate.day);

    if (age > 18 || (age == 18 && isBirthdayPassedThisYear)) {
      return null; // User is 18 or older
    } else {
      return 'You must be at least 18 years old';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.isNewUser ? 'Create Profile' : 'Edit Profile'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        leading: const SizedBox(width: 0, height: 0),
      ),
      body: Observer(
        builder: (_) {
          final profileStore = Provider.of<ProfileStore>(context);
          if (profileStore.profileData == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _imageFile != null
                                ? FileImage(File(_imageFile!.path))
                                : (_imageUrl != null
                                    ? NetworkImage(_imageUrl!)
                                    : null) as ImageProvider?,
                            child: _imageFile == null && _imageUrl == null
                                ? const Icon(Icons.add_a_photo,
                                    size: 50, color: Colors.white)
                                : null,
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.edit, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a display name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: const Icon(Icons.info),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _birthDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != _birthDate) {
                        setState(() {
                          _birthDate = picked;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: _birthDate == null
                          ? 'Select Birth Date'
                          : 'Birth Date: ${_birthDate!.toLocal().toString().split(' ')[0]}',
                      prefixIcon: const Icon(Icons.calendar_today),
                      suffixIcon: _birthDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _birthDate = null;
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_birthDate != null)
                    Text(
                      _validateAge(_birthDate) ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: const Icon(Icons.wc),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a gender' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate() &&
                                _validateAge(_birthDate) == null) {
                              _saveProfile();
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Save Profile'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
