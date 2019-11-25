import 'package:clean_arch/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  group('isConnected', () {
    final MockDataConnectionChecker mockDataConnectionChecker =
        MockDataConnectionChecker();
    final NetworkInfoImpl networkInfo =
        NetworkInfoImpl(mockDataConnectionChecker);

    test(
        'should networkinfo forward the call to DataConnectionChecker.hasConnection',
        () async {
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      final result = networkInfo.isConnected;

      expect(result, tHasConnectionFuture);
      verify(mockDataConnectionChecker.hasConnection);
    });
  });
}
