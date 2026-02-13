import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pretty_logger/pretty_logger.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
  // StreamSubscription<InternetStatus> get onStatusChange;
}

class ConnectionCheckerImplementation implements ConnectionChecker {
  final InternetConnection internetConnection;
  ConnectionCheckerImplementation({required this.internetConnection});
  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
  // StreamSubscription<InternetStatus> get onStatusChange =>
  //     internetConnection.onStatusChange.listen((InternetStatus status) {
  //       if (status == InternetStatus.connected) {
  //         // Internet is connected
  //         PLog.green('Internet is connected');
  //       } else {
  //         // Internet is disconnected
  //         PLog.red('Internet is disconnected');
  //       }
  //     });
}
