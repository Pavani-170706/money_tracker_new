import 'package:flutter/material.dart';
import '../app_style.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hideBalance = false;
  final pinController = TextEditingController();
  final goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    hideBalance = await StorageService.getHideBalance();
    final goal = await StorageService.getGoal();
    goalController.text = goal == 0 ? '' : goal.toStringAsFixed(0);
    setState(() {});
  }

  Future<void> savePin() async {
    if (pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN must be 4 digits')),
      );
      return;
    }

    await StorageService.savePin(pinController.text);
    pinController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN changed successfully')),
    );
  }

  Future<void> saveGoal() async {
    final goal = double.tryParse(goalController.text);

    if (goal == null || goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid goal amount')),
      );
      return;
    }

    await StorageService.saveGoal(goal);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Savings goal saved')),
    );
  }

  Future<void> changeHideBalance(bool value) async {
    await StorageService.saveHideBalance(value);
    setState(() => hideBalance = value);
  }

  Widget settingCard(Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: softCard(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          settingCard(
            SwitchListTile(
              title: const Text('Hide Balance'),
              subtitle: const Text('Show balance as ₹ ****'),
              value: hideBalance,
              onChanged: changeHideBalance,
            ),
          ),
          settingCard(
            Column(
              children: [
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    labelText: 'New 4-digit PIN',
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: savePin,
                  child: const Text('Change PIN'),
                ),
              ],
            ),
          ),
          settingCard(
            Column(
              children: [
                TextField(
                  controller: goalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Savings Goal',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: saveGoal,
                  child: const Text('Save Goal'),
                ),
              ],
            ),
          ),
          settingCard(
            const ListTile(
              leading: Icon(Icons.info_outline, color: AppColors.primary),
              title: Text('About App'),
              subtitle: Text('Money Tracker - Private savings app'),
            ),
          ),
        ],
      ),
    );
  }
}