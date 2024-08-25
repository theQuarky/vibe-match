import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  SocketService() {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io('https://f7e2-2409-40c1-10fa-cfbd-51c2-d311-efc1-d768.ngrok-free.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connection established');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onError((error) {
      print('Socket error: $error');
    });
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void on(String event, Function(dynamic) handler) {
    socket.on(event, handler);
  }

  void off(String event) {
    socket.off(event);
  }

  void disconnect() {
    socket.disconnect();
  }

  bool get isConnected => socket.connected;
}
