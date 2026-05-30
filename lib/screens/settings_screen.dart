import 'package:flutter/material.dart';
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN changed successfully')),
    );

    pinController.clear();
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
    setState(() {
      hideBalance = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFEAF7FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Hide Balance'),
            subtitle: const Text('Show balance as ₹ ****'),
            value: hideBalance,
            onChanged: changeHideBalance,
          ),
          const SizedBox(height: 15),
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
          const SizedBox(height: 25),
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
          const SizedBox(height: 25),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About App'),
            subtitle: Text('Private personal money tracker'),
          ),
        ],
      ),
    );
  }
}