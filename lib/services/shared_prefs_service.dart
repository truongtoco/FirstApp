import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  // --- SINGLETON ---
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;
  SharedPrefsService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter & Setter cho Onboarding
  bool get isFirstLaunch => _prefs.getBool('isFirstLaunch') ?? true;

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool('isFirstLaunch', value);
  }
}