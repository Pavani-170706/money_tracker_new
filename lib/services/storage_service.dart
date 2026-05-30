import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('balance') ?? 0.0;
  }

  static Future<void> saveBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('balance', balance);
  }

  static Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> addHistory(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.insert(0, item);
    await prefs.setString('history', jsonEncode(history));
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('history');
  }

  static Future<String> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pin') ?? '1234';
  }

  static Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
  }

  static Future<bool> getHideBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hideBalance') ?? false;
  }

  static Future<void> saveHideBalance(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hideBalance', value);
  }

  static Future<double> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('goal') ?? 0.0;
  }

  static Future<void> saveGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('goal', goal);
  }
}