import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task7/core/network/network_info_impl.dart';

@GenerateMocks([InternetConnectionChecker])
import 'network_info_impl_test.mocks.dart';

void main() {
  late MockInternetConnectionChecker mockConnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockConnectionChecker);
  });

  group('NetworkInfoImpl', () {
    test('should forward the call to InternetConnectionChecker.hasConnection when connected', () async {
      // arrange
      when(mockConnectionChecker.hasConnection).thenAnswer((_) async => true);

      // act
      final result = await networkInfo.isConnected;

      // assert
      verify(mockConnectionChecker.hasConnection);
      expect(result, true);
    });

    test('should forward the call to InternetConnectionChecker.hasConnection when disconnected', () async {
      // arrange
      when(mockConnectionChecker.hasConnection).thenAnswer((_) async => false);

      // act
      final result = await networkInfo.isConnected;

      // assert
      verify(mockConnectionChecker.hasConnection);
      expect(result, false);
    });
  });
}
