import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:yoto/auth_screen.dart';
import 'package:yoto/firebase_options.dart';
import 'package:yoto/screens/anonymous_chat_screen.dart';
import 'package:yoto/services/serverless_service.dart';
import 'package:yoto/stores/auth_store.dart';
import 'package:yoto/stores/profile_store.dart';
import 'package:yoto/stores/match_store.dart';
import 'package:yoto/stores/chat_store.dart';
import 'package:yoto/services/socket_service.dart';
import 'package:yoto/screens/home_screen.dart';
import 'package:yoto/screens/profile_edit_screen.dart';
import 'package:yoto/screens/search_screen.dart';
import 'package:yoto/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final socketService = SocketService();
  final serverlessService = ServerlessService();
  final firestore = FirebaseFirestore.instance;
  final authStore = AuthStore();
  await authStore.init();

  final profileStore = ProfileStore();
  final matchStore = MatchStore(socketService, serverlessService, firestore);
  final chatStore = ChatStore(socketService);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthStore>(create: (_) => authStore),
        Provider<ProfileStore>(create: (_) => profileStore),
        Provider<MatchStore>(create: (_) => matchStore),
        Provider<ChatStore>(
          create: (_) => chatStore,
          dispose: (_, store) => store.dispose(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoto Chat App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/profile_edit': (context) => const ProfileEditScreen(),
        '/search': (context) => const SearchScreen(),
        '/anonymous_chat': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return AnonymousChatScreen(
            chatId: args['chatId'],
            otherUserId: args['otherUserId'],
          );
        },
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    final profileStore = Provider.of<ProfileStore>(context);
    final chatStore = Provider.of<ChatStore>(context, listen: false);

    return Observer(
      builder: (_) {
        if (authStore.isLoggedIn) {
          profileStore.fetchProfileData();
          if (!profileStore.isProfileComplete) {
            return ProfileEditScreen(
                isNewUser: profileStore.profileData == null);
          } else {
            // Register the user with the socket server when logged in
            chatStore.registerUser(authStore.currentUser!.uid);
            return const HomeScreen();
          }
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
