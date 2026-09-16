import 'dart:async';

enum BreathingPhase { inhale, holdIn, exhale, holdOut }

class BreathingState {
  final BreathingPhase phase;
  final int secondsRemainingInPhase;
  final String instructionRo;

  BreathingState({
    required this.phase,
    required this.secondsRemainingInPhase,
    required this.instructionRo,
  });
}

class HapticBreathingService {
  Timer? _timer;
  int _currentPhaseIndex = 0;
  int _secondsLeft = 4;
  bool _isRunning = false;

  // Box breathing pattern durations: Inhale 4s, Hold 4s, Exhale 4s, Hold 4s
  final List<int> _durations = [4, 4, 4, 4];
  final List<BreathingPhase> _phases = [
    BreathingPhase.inhale,
    BreathingPhase.holdIn,
    BreathingPhase.exhale,
    BreathingPhase.holdOut,
  ];

  final StreamController<BreathingState> _controller =
      StreamController<BreathingState>.broadcast();

  Stream<BreathingState> get stateStream => _controller.stream;
  bool get isRunning => _isRunning;

  void start() {
    _isRunning = true;
    _currentPhaseIndex = 0;
    _secondsLeft = _durations[0];
    _emitCurrent();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsLeft--;
      if (_secondsLeft <= 0) {
        _currentPhaseIndex = (_currentPhaseIndex + 1) % _phases.length;
        _secondsLeft = _durations[_currentPhaseIndex];
        _triggerHapticForPhase(_phases[_currentPhaseIndex]);
      }
      _emitCurrent();
    });
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    _timer = null;
  }

  void _triggerHapticForPhase(BreathingPhase phase) {
    // In Flutter, will invoke Vibration / HapticFeedback
    // e.g. HapticFeedback.mediumImpact() or Vibration.vibrate()
  }

  void _emitCurrent() {
    final phase = _phases[_currentPhaseIndex];
    String instruction;
    switch (phase) {
      case BreathingPhase.inhale:
        instruction = 'Inhale gently through your nose';
        break;
      case BreathingPhase.holdIn:
        instruction = 'Hold comfortably in your chest';
        break;
      case BreathingPhase.exhale:
        instruction = 'Exhale slowly through your mouth';
        break;
      case BreathingPhase.holdOut:
        instruction = 'Relaxed rest';
        break;
    }

    _controller.add(BreathingState(
      phase: phase,
      secondsRemainingInPhase: _secondsLeft,
      instructionRo: instruction,
    ));
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
