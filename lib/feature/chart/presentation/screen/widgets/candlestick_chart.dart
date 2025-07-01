
import 'package:flutter/material.dart';
import 'package:real_time_trading_app/feature/chart/presentation/screen/widgets/cancdle_painter.dart';
import '../../../domain/entities/candle.dart';

class CandlestickChart extends StatelessWidget {
  final List<Candle> candles;
  final Offset? draggedPosition;
  final Function(Offset offset) onDrag;

  const CandlestickChart({
    super.key,
    required this.candles,
    required this.draggedPosition,
    required this.onDrag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => onDrag(details.localPosition),
      child: CustomPaint(
        painter: CandlePainter(candles, draggedPosition: draggedPosition),
        size: Size.infinite,
      ),
    );
  }
}