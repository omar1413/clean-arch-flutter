import 'package:clean_arch/src/core/base/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MockHttpClient mockClient;
  ApiImpl api;

  setUp(() {
    mockClient = MockHttpClient();
    api = ApiImpl(mockClient);
  });

  group('get', () {
    test('should forward call to mockCLinet.get', () async {
      Future<http.Response> tFutureRes =
          Future.value(http.Response('test body', 200));

      final tUrl = 'endpoint';
      final tHeaders = {'test': 'test'};

      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) => tFutureRes);

      final result = api.get(tUrl, headers: tHeaders);

      expect(result, tFutureRes);
      verify(mockClient.get(tUrl, headers: tHeaders));
    });
  });
}
