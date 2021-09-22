import 'package:connectivity/connectivity.dart';

abstract class NetworkMethods {
  static Future<bool> isNetworkConnected() async {
    try {
      ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      return (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile);
    } on Error {
      return false;
    }
  }
}
