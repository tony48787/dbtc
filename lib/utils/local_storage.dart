
import 'package:shared_preferences/shared_preferences.dart';

class LS_KEY {
  final _value;
  const LS_KEY._internal(this._value);
  toString() => '$_value';

  static const NOTIFICATION_HOUR = const LS_KEY._internal('NOTIFICATION_HOUR');
  static const NOTIFICATION_MINUTE = const LS_KEY._internal('NOTIFICATION_MINUTE');
}

class LocalStorage {
  LocalStorage._();

  static final LocalStorage instance = LocalStorage._();

  setItem(LS_KEY localStorageKey, dynamic value) async {
    String key = localStorageKey.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (value.runtimeType) {
      case int:
        prefs.setInt(key, value);
        break;
      case bool:
        prefs.setBool(key, value);
        break;
      case double:
        prefs.setDouble(key, value);
        break;
      case List:
        prefs.setStringList(key, value);
        break;
      default:
        prefs.setString(key, value);
    }
  }

  dynamic getItem(LS_KEY localStorageKey) async {
    String key = localStorageKey.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

}