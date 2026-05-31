import 'package:flutter/material.dart';
import '../app_style.dart';
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wrong PIN')));
      setState(() => pin = '');
    }
  }

  void addNumber(String number) {
    if (pin.length < 4) setState(() => pin += number);
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 78,
        height: 58,
        margin: const EdgeInsets.all(7),
        decoration: softCard(),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget emptyButton() {
    return Container(
      width: 78,
      height: 58,
      margin: const EdgeInsets.all(7),
    );
  }

  Widget backButton() {
    return InkWell(
      onTap: deleteNumber,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 78,
        height: 58,
        margin: const EdgeInsets.all(7),
        child: const Center(
          child: Icon(Icons.backspace_outlined, color: AppColors.textDark),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/wallet.png', height: 150),
              const SizedBox(height: 20),
              const Text(
                'Money Tracker',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your Secret Savings',
                style: TextStyle(fontSize: 17, color: AppColors.textLight),
              ),
              const SizedBox(height: 40),
              const Text(
                'Enter 4-digit PIN',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 34,
                    height: 34,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryDark, width: 2),
                      color: index < pin.length
                          ? AppColors.primaryDark
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
                  emptyButton(),
                  numberButton('0'),
                  backButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}