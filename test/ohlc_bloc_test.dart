import 'package:flutter_test/flutter_test.dart';
import 'package:real_time_trading_app/feature/chart/presentation/bloc/ohlc_bloc.dart';
import 'package:real_time_trading_app/feature/chart/domain/entities/candle.dart';
import 'package:real_time_trading_app/feature/chart/presentation/bloc/ohlc_event.dart';

void main() {
  group('OhlcBloc Candle Generation Tests', () {
    late OhlcBloc bloc;
    late DateTime mockTime;

    setUp(() {
      mockTime = DateTime(2025, 1, 1, 10, 0);
      bloc = OhlcBloc(timeProvider: () => mockTime);
      bloc.add(TickReceived(3600.0));
    });

    tearDown(() async {
      await bloc.close();
    });

    test('Initial candle list should contain exactly one candle after generateInitialData()', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.allCandles.length, 1);
      final Candle candle = bloc.allCandles.first;

      expect(candle.open, isNonZero);
      expect(candle.close, isNonZero);
      expect(candle.high, greaterThanOrEqualTo(candle.open));
      expect(candle.low, lessThanOrEqualTo(candle.open));
    });

    test('TickReceived should update current candle correctly within same minute', () async {
      bloc.add(TickReceived(3620.0));
      await Future.delayed(const Duration(milliseconds: 100));

      final updatedCandle = bloc.currentCandle;

      expect(updatedCandle, isNotNull);
      expect(updatedCandle!.open, isNonZero);
      expect(updatedCandle.close, 3620.0);
      expect(updatedCandle.high, greaterThanOrEqualTo(3620.0));
      expect(updatedCandle.low, lessThanOrEqualTo(3620.0));
    });

    test('New minute should create a new candle', () async {
      await Future.delayed(const Duration(milliseconds: 100));
      final firstMinute = bloc.currentCandle!.time;
      mockTime = firstMinute.add(const Duration(minutes: 1));

      bloc.add(TickReceived(3700.0));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(bloc.allCandles.length, greaterThan(1));
      expect(bloc.currentCandle?.time.isAfter(firstMinute), true);
    });

    test('Dragged line should reset after 3 seconds', () async {
      bloc.add(LineDragged(const Offset(0, 100)));
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.state.draggedPosition, isNotNull);

      await Future.delayed(const Duration(seconds: 4));
      expect(bloc.state.draggedPosition, isNull);
    });

    test('Should keep only last 30 candles in the list', () async {
      final start = DateTime(2025, 1, 1, 10, 0);
      for (int i = 0; i < 35; i++) {
        mockTime = start.add(Duration(minutes: i + 1));
        bloc.add(TickReceived(3000.0 + i));
        await Future.delayed(const Duration(milliseconds: 10));
      }

      expect(bloc.allCandles.length, lessThanOrEqualTo(30));
    });
  });
}