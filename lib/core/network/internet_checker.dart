import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetChecker {
  static Future<bool> isInternetConnected() async {
    return await InternetConnection().hasInternetAccess;
  }
}
