import 'dart:async';

class TimerManager {
  int _timeRemaining;
  late Timer _timer;
  final Function onTimerUpdate;
  final Function onTimeExpired;

  TimerManager(this._timeRemaining,
      {required this.onTimerUpdate, required this.onTimeExpired});

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        onTimerUpdate(_timeRemaining);
      } else {
        _timer.cancel();
        onTimeExpired();
      }
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }

  String getFormattedTime() {
    final minutes = (_timeRemaining ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (_timeRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }
}
