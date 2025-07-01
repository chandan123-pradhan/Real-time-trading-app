import 'package:flutter/material.dart';
import 'package:real_time_trading_app/feature/chart/domain/entities/candle.dart';

class TopOhlcBar extends StatelessWidget {
  final Candle? lastClosedCandle;

  const TopOhlcBar({super.key, required this.lastClosedCandle});

  @override
  Widget build(BuildContext context) {
    final candle = lastClosedCandle;
    if (candle == null) {
      return const SizedBox.shrink();
    }

    TextStyle style = const TextStyle(color: Colors.white, fontSize: 13);
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLabel("OPEN", candle.open, style),
          _buildLabel("HIGH", candle.high, style),
          _buildLabel("LOW", candle.low, style),
          _buildLabel("CLOSE", candle.close, style),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, double value, TextStyle style) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: style.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value.toStringAsFixed(2), style: style),
      ],
    );
  }
}
