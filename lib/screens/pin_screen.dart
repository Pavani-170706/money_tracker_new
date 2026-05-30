import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'dashboard_screen.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String pin = '';

  Future<void> checkPin() async {
    final savedPin = await StorageService.getPin();

    if (pin == savedPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong PIN')),
      );
      setState(() => pin = '');
    }
  }

  void addNumber(String number) {
    if (pin.length < 4) {
      setState(() => pin += number);
    }
    if (pin.length == 4) checkPin();
  }

  void deleteNumber() {
    if (pin.isNotEmpty) {
      setState(() => pin = pin.substring(0, pin.length - 1));
    }
  }

  Widget numberButton(String number) {
    return InkWell(
      onTap: () => addNumber(number),
      child: Container(
        width: 78,
        height: 58,
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF0066D6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/wallet.png', height: 180),
              const SizedBox(height: 18),
              const Text(
                'Money Tracker',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066D6),
                ),
              ),
              const Text(
                'Your Secret Savings',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 32),
              const Text(
                'Enter 4-digit PIN',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF004FA8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '● ' * pin.length + '○ ' * (4 - pin.length),
                style: const TextStyle(
                  fontSize: 28,
                  letterSpacing: 8,
                  color: Color(0xFF0066D6),
                ),
              ),
              const SizedBox(height: 22),
              for (var row in [
                ['1', '2', '3'],
                ['4', '5', '6'],
                ['7', '8', '9'],
              ])
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map(numberButton).toList(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 92),
                  numberButton('0'),
                  IconButton(
                    onPressed: deleteNumber,
                    icon: const Icon(Icons.backspace_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}