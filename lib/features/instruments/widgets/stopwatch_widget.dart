import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

enum StopwatchState { reset, running, stopped }

class StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({super.key});

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _displayTime = "00:00";
  Color _textColor = AppColors.white;
  StopwatchState _state = StopwatchState.reset;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      switch (_state) {
        case StopwatchState.reset:
          _stopwatch.start();
          _startTimer();
          _state = StopwatchState.running;
          _textColor = AppColors.orange;
          break;
        case StopwatchState.running:
          _stopwatch.stop();
          _timer?.cancel();
          _state = StopwatchState.stopped;
          _textColor = AppColors.white;
          break;
        case StopwatchState.stopped:
          _stopwatch.reset();
          _displayTime = "00:00";
          _state = StopwatchState.reset;
          break;
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _displayTime = _formatTime(_stopwatch.elapsed);
        });
      }
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: ShapeDecoration(
          color: Colors.black,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: AppColors.instrumentGrey, width: 1),
          ),
        ),
        child: Text(
          _displayTime,
          style: TextStyle(
            color: _textColor,
            fontSize: 16,
            fontFamily: 'Courier',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
