import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveString(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('saved_string', value);
}

Future<String?> getString() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('saved_string');
}
