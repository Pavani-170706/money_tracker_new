import 'package:flutter/material.dart';
import '../app_style.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: clearHistory,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text('No transactions yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final isAdded = item['type'] == 'Added';

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: softCard(),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isAdded ? Colors.green : Colors.red,
                        child: Icon(
                          isAdded ? Icons.add : Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAdded ? 'Added' : 'Withdrawn',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item['date'].toString().substring(0, 16),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textLight,
                              ),
                            ),
                            if (item['note'].toString().isNotEmpty)
                              Text(
                                item['note'],
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        '${isAdded ? '+' : '-'} ₹${item['amount'].toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isAdded ? AppColors.green : AppColors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}