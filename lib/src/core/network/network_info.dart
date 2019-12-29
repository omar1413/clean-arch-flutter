import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;
  bool status = false;
  NetworkInfoImpl(this.dataConnectionChecker) {
    check();
  }

  Future<void> check() async {
    dataConnectionChecker.checkInterval = Duration(seconds: 1);

    status = await dataConnectionChecker.hasConnection;

    dataConnectionChecker.onStatusChange.listen((connectionStatus) {
      if (connectionStatus == DataConnectionStatus.connected) {
        print('connected');
        status = true;
      } else {
        print('disconnected');
        status = false;
      }
    });
  }

  @override
  Future<bool> get isConnected async => status;
}
