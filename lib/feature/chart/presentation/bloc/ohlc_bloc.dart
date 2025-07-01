import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_trading_app/core/utils/timeframe.dart';
import '../../domain/entities/candle.dart';
import 'ohlc_event.dart';
import 'ohlc_state.dart';

class OhlcBloc extends Bloc<OhlcEvent, OhlcState> {
  final DateTime Function() timeProvider;
  Candle? _currentCandle;
  final List<Candle> _candles = [];
  late Timer _timer;
  Timer? _resetTimer;
  double _lastPrice = 3500.0;
  final _random = Random();
  Timeframe _timeframe = Timeframe.oneMinute;

  OhlcBloc({DateTime Function()? timeProvider})
      : timeProvider = timeProvider ?? DateTime.now,
        super(const OhlcState([])) {
    on<TickReceived>(_onTick);
    on<LineDragged>(_onDragged);
    on<ResetLine>(_onReset);
    on<ChangeTimeframe>(_onChangeTimeframe);

    _generateInitialData();
    _startTickGenerator();
  }

  void _generateInitialData() {
    final now = timeProvider();
    final DateTime startMinute = now.subtract(const Duration(minutes: 1));
    final List<double> ticks = [];
    double current = _lastPrice;

    for (int i = 0; i < 60; i++) {
      final delta = (_random.nextDouble() * 200 - 100);
      current += delta;
      current = double.parse(current.clamp(2000, 5000).toStringAsFixed(2));
      ticks.add(current);
    }

    final open = ticks.first;
    final close = ticks.last;
    final high = ticks.reduce(max);
    final low = ticks.reduce(min);

    _candles.add(Candle(
      time: DateTime(startMinute.year, startMinute.month, startMinute.day, startMinute.hour, startMinute.minute),
      open: open,
      high: high,
      low: low,
      close: close,
    ));

    _lastPrice = close;
  }

  void _startTickGenerator() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final delta = (_random.nextDouble() * 200 - 100);
      _lastPrice = double.parse((_lastPrice + delta).clamp(2000, 5000).toStringAsFixed(2));
      add(TickReceived(_lastPrice));
    });
  }

  void _onTick(TickReceived event, Emitter<OhlcState> emit) {
    final now = timeProvider();

    final currentBucket = _timeframe == Timeframe.oneMinute
        ? DateTime(now.year, now.month, now.day, now.hour, now.minute)
        : DateTime(now.year, now.month, now.day, now.hour, (now.minute ~/ 5) * 5);

    if (_currentCandle == null || _currentCandle!.time != currentBucket) {
      if (_currentCandle != null) {
        _candles.add(_currentCandle!); //Adding at end point.
        if (_candles.length > 30) _candles.removeAt(0);  //Here we are removing from 1st index if _candles list is greater than 30.
      }
      _currentCandle = Candle(
        time: currentBucket,
        open: event.price,
        high: event.price,
        low: event.price,
        close: event.price,
      );
    } else {
      _currentCandle = Candle(
        time: _currentCandle!.time,
        open: _currentCandle!.open,
        high: max(_currentCandle!.high, event.price),
        low: min(_currentCandle!.low, event.price),
        close: event.price,
      );
    }

    final allCandles = List<Candle>.from(_candles);
    if (_currentCandle != null) allCandles.add(_currentCandle!);
    emit(OhlcState(allCandles, draggedPosition: state.draggedPosition));
  }

  void _onDragged(LineDragged event, Emitter<OhlcState> emit) {
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), () {
      add(ResetLine());
    });

    emit(state.copyWith(draggedPosition: event.position));
  }

  void _onReset(ResetLine event, Emitter<OhlcState> emit) {
    emit(state.copyWith(draggedPosition: null));
  }

/// _onChangeTimeframe this function will change time frame and last candle.
  void _onChangeTimeframe(ChangeTimeframe event, Emitter<OhlcState> emit) {
    _timeframe = event.timeframe;
    _candles.clear();
    _currentCandle = null;
    _generateInitialData();

    
  }

  List<Candle> get allCandles => _candles;
  Candle? get currentCandle => _currentCandle;
  Timeframe get currentTimeframe => _timeframe;

  @override
  Future<void> close() {
    _timer.cancel();
    _resetTimer?.cancel();
    return super.close();
  }
}
