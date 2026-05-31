import 'package:flutter/material.dart';
import '../app_style.dart';
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
      decoration: softCard(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4AA8FF),
                  Color(0xFF0F73F6),
                ],
              ),
            ),
            child: Icon(
              icon,
              size: 34,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
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
      backgroundColor: AppColors.bg,
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
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: blueGradientCard(),
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
                          const Text(
                            'Keep saving! 😊',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: progress,
                            color: Colors.white,
                            backgroundColor: Colors.white30,
                          ),
                        ],
                      ),
                    ),
                    Image.asset('assets/images/piggy.png', height: 140),
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
                    menuCard(Icons.remove, 'Withdraw Money', const WithdrawScreen()),
                    menuCard(Icons.receipt_long, 'History', const HistoryScreen()),
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