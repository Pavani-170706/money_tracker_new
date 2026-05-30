import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    history = await StorageService.getHistory();
    setState(() {});
  }

  Future<void> clearHistory() async {
    await StorageService.clearHistory();
    await loadHistory();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: const Color(0xFFEAF7FF),
        actions: [
          IconButton(
            onPressed: clearHistory,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final isAdded = item['type'] == 'Added';

                return Card(
                  child: ListTile(
                    leading: Icon(
                      isAdded ? Icons.add_circle : Icons.remove_circle,
                      color: isAdded ? Colors.green : Colors.red,
                    ),
                    title: Text('${item['type']} ₹${item['amount']}'),
                    subtitle: Text(
                      '${item['note']}\nBalance: ₹${item['balance']}',
                    ),
                    trailing: Text(
                      item['date'].toString().substring(0, 10),
                    ),
                  ),
                );
              },
            ),
    );
  }
}