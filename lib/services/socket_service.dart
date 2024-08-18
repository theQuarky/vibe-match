import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get_it/get_it.dart';

class SocketService {
  late IO.Socket socket;
  final String serverUrl;
  bool _isConnected = false;

  // Singleton instance
  static final SocketService _instance = SocketService._internal();

  // Private constructor
  SocketService._internal()
      : serverUrl =
            'https://1fe7-2409-40c1-5025-6d04-1867-c339-b731-605c.ngrok-free.app';

  // Factory constructor
  factory SocketService() {
    return _instance;
  }

  bool get isConnected => _isConnected;

  void connect() {
    if (!_isConnected) {
      socket = IO.io(serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();

      socket.onConnect((_) {
        print('Connected to socket server');
        _isConnected = true;
      });

      socket.onDisconnect((_) {
        print('Disconnected from socket server');
        _isConnected = false;
      });

      socket.on('error', (error) {
        print('Socket error: $error');
      });
    }
  }

  void registerUser(String userId) {
    if (_isConnected) {
      socket.emit('register', userId);
    } else {
      print('Not connected to server. Cannot register user.');
    }
  }

  void initializeChat(String chatId, String userId1, String userId2) {
    if (_isConnected) {
      socket.emit('initializeChat', {
        'chatId': chatId,
        'userId1': userId1,
        'userId2': userId2,
      });
    } else {
      print('Not connected to server. Cannot initialize chat.');
    }
  }

  void listenForChatInitialized(Function(dynamic) callback) {
    socket.on('chatInitialized', callback);
  }

  void disconnect() {
    if (_isConnected) {
      socket.disconnect();
      _isConnected = false;
    }
  }

  // Add more methods as needed for other socket events
}

// Extension for GetIt registration
extension SocketServiceDependency on GetIt {
  void registerSocketService() {
    registerLazySingleton(() => SocketService());
  }
}
