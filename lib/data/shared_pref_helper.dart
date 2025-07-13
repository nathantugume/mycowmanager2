import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPrefHelper? _instance;
  late SharedPreferences _prefs;

  SharedPrefHelper._internal();

  static Future<SharedPrefHelper> getInstance(BuildContext context) async {
    if (_instance == null) {
      _instance = SharedPrefHelper._internal();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  // ────── Getters ──────
  String? getString(String key, [String? defaultValue]) {
    return _prefs.getString(key) ?? defaultValue;
  }

  int? getInt(String key, [int? defaultValue]) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  bool? getBool(String key, [bool? defaultValue]) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  double? getDouble(String key, [double? defaultValue]) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // ────── Setters ──────
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  // ────── Clear ──────
  Future<void> clear() async {
    await _prefs.clear();
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
