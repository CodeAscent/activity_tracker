import 'dart:async';
import 'package:activity_tracker/features/auth/views/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _inactivityTimer;
  Timer? _warningTimer;
  bool _showWarning = false;
  int _warningCountdown = 30;

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();

    setState(() {
      _showWarning = false;
      _warningCountdown = 30;
    });

    _inactivityTimer = Timer(const Duration(minutes: 1), _showInactivityWarning);
  }

  void _showInactivityWarning() {
    setState(() {
      _showWarning = true;
    });

    _warningTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_warningCountdown > 0) {
        setState(() {
          _warningCountdown--;
        });
      } else {
        timer.cancel();
        _logout();
      }
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _warningTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanUpdate: (_) => _resetInactivityTimer,
      onDoubleTap: _resetInactivityTimer,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Center(
          child: _showWarning
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You have been inactive.',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Logging out in $_warningCountdown seconds...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : Text(
                  'Welcome, ${widget.username}!',
                  style: const TextStyle(fontSize: 24),
                ),
        ),
      ),
    );
  }
}
