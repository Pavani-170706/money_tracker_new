import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'add_money_screen.dart';
import 'withdraw_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double balance = 0;
  double goal = 0;
  bool hideBalance = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    balance = await StorageService.getBalance();
    goal = await StorageService.getGoal();
    hideBalance = await StorageService.getHideBalance();
    setState(() {});
  }

  Future<void> openScreen(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    loadData();
  }

  Widget menuCard(IconData icon, String title, Widget screen) {
    return InkWell(
      onTap: () => openScreen(screen),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFEAF7FF),
              child: Icon(icon, size: 32, color: Colors.blue),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = goal == 0 ? 0 : balance / goal;
    if (progress > 1) progress = 1;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0066D6),
                ),
              ),
              const SizedBox(height: 22),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D8CFF), Color(0xFF0066D6)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Balance',
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 8),
                          Text(
                            hideBalance
                                ? '₹ ****'
                                : '₹ ${balance.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            goal == 0
                                ? 'No savings goal set'
                                : 'Goal: ₹${goal.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            color: Colors.white,
                            backgroundColor: Colors.white30,
                          ),
                        ],
                      ),
                    ),
                    Image.asset('assets/images/piggy.png', height: 110),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    menuCard(Icons.add, 'Add Money', const AddMoneyScreen()),
                    menuCard(Icons.remove, 'Withdraw', const WithdrawScreen()),
                    menuCard(Icons.history, 'History', const HistoryScreen()),
                    menuCard(Icons.settings, 'Settings', const SettingsScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}