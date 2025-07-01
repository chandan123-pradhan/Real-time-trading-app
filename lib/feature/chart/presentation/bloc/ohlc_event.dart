import 'dart:ui';

import 'package:real_time_trading_app/core/utils/timeframe.dart';

abstract class OhlcEvent {}

class TickReceived extends OhlcEvent {
  final double price;
  TickReceived(this.price);
}

class LineDragged extends OhlcEvent {
  final Offset position;
  LineDragged(this.position);
}

class ResetLine extends OhlcEvent {}

class ChangeTimeframe extends OhlcEvent {
  final Timeframe timeframe;
  ChangeTimeframe(this.timeframe);
}
