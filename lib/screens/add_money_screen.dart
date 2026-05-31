import 'package:flutter/material.dart';
import '../app_style.dart';
import '../services/storage_service.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  double newBalance = 0;

  Future<void> previewBalance(String value) async {
    final oldBalance = await StorageService.getBalance();
    final amount = double.tryParse(value) ?? 0;
    setState(() => newBalance = oldBalance + amount);
  }

  Future<void> addMoney() async {
    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) return;

    final oldBalance = await StorageService.getBalance();
    final updatedBalance = oldBalance + amount;

    await StorageService.saveBalance(updatedBalance);
    await StorageService.addHistory({
      'type': 'Added',
      'amount': amount,
      'note': noteController.text,
      'balance': updatedBalance,
      'date': DateTime.now().toString(),
    });

    Navigator.pop(context);
  }

  InputDecoration inputStyle(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: label == 'Amount' ? '₹  ' : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFBFD7F5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFBFD7F5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Add Money'),
        centerTitle: true,
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFFD9ECFF),
              child: Icon(Icons.add, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 35),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: previewBalance,
              decoration: inputStyle('Amount', 'Enter amount'),
            ),
            const SizedBox(height: 22),
            TextField(
              controller: noteController,
              decoration: inputStyle('Note optional', 'Write a note...'),
            ),
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFDCEEFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'New Balance\n₹ ${newBalance.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 23,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: addMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Add Money',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}