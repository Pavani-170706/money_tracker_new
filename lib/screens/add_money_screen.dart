import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  Future<void> addMoney() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid amount')),
      );
      return;
    }

    final oldBalance = await StorageService.getBalance();
    final newBalance = oldBalance + amount;

    await StorageService.saveBalance(newBalance);

    await StorageService.addHistory({
      'type': 'Added',
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
        title: const Text('Add Money'),
        backgroundColor: const Color(0xFFEAF7FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(Icons.add_circle, size: 90, color: Colors.blue),
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
                labelText: 'Note optional',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: addMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: const Text(
                'Add Money',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}