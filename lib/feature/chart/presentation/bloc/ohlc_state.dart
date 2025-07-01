import 'dart:ui';

import 'package:real_time_trading_app/core/utils/timeframe.dart';
import 'package:real_time_trading_app/feature/chart/domain/entities/candle.dart';

import 'package:flutter/material.dart';
import '../../domain/entities/candle.dart';

class OhlcState {
  final List<Candle> candles;
  final Offset? draggedPosition;

  const OhlcState(this.candles, {this.draggedPosition});

  OhlcState copyWith({List<Candle>? candles, Offset? draggedPosition}) {
    return OhlcState(
      candles ?? this.candles,
      draggedPosition: draggedPosition,
    );
  }
}
