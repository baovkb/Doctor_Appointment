import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  static Future<bool?> checkFirstLaunch() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isFirst = prefs.getBool('first_launch') ?? true;
      
      return isFirst;
    } catch (e) {
      return null;
    }
    
  }

  static Future<void> setFirstLaunch(bool isFirstLaunch) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('first_launch', isFirstLaunch);
    } catch (e) {
    }
  }
}