import 'dart:async';
import 'package:flutter/foundation.dart';

class ChatTimerService {
  final bool isFriend;
  final VoidCallback onTimerEnd;
  Timer? _timer;
  final ValueNotifier<int> _secondsRemaining = ValueNotifier(15 * 60); // 15 minutes for anonymous chat

  ChatTimerService({required this.isFriend, required this.onTimerEnd}) {
    if (!isFriend) {
      _startTimer();
    }
  }

  ValueNotifier<int> get secondsRemaining => _secondsRemaining;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        onTimerEnd();
        _timer?.cancel();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _secondsRemaining.dispose();
  }
}