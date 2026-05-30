import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> withdrawMoney() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid amount')),
      );
      return;
    }

    final oldBalance = await StorageService.getBalance();

    if (amount > oldBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient Balance')),
      );
      return;
    }

    final newBalance = oldBalance - amount;

    await StorageService.saveBalance(newBalance);

    await StorageService.addHistory({
      'type': 'Withdrawn',
      'amount': amount,
      'note': noteController.text,
      'balance': newBalance,
      'date': DateTime.now().toString(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      appBar: AppBar(
        title: const Text('Withdraw Money'),
        backgroundColor: const Color(0xFFEAF7FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(
              Icons.remove_circle,
              size: 90,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Reason optional',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: withdrawMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: const Text(
                'Withdraw',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}