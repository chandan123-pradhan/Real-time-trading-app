import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_trading_app/core/utils/timeframe.dart';
import 'package:real_time_trading_app/feature/chart/presentation/bloc/ohlc_bloc.dart';
import 'package:real_time_trading_app/feature/chart/presentation/bloc/ohlc_state.dart';
import 'package:real_time_trading_app/feature/chart/presentation/bloc/ohlc_event.dart';
import 'package:real_time_trading_app/feature/chart/presentation/screen/widgets/candlestick_chart.dart';
import 'package:real_time_trading_app/feature/chart/presentation/screen/widgets/top_ohlc_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("TCS Live Chart", style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<OhlcBloc, OhlcState>(
        builder: (context, state) {
          final candles = state.candles;
          final latestClosedCandle = candles.length > 1 ? candles[candles.length - 2] : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
               _buildTimeframeSelector(context),
              const SizedBox(height: 8),
              TopOhlcBar(lastClosedCandle: latestClosedCandle),
              const SizedBox(height: 8),
             
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CandlestickChart(
                    candles: candles,
                    draggedPosition: state.draggedPosition,
                    onDrag: (offset) => context.read<OhlcBloc>().add(LineDragged(offset)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeframeSelector(BuildContext context) {
    final current = context.watch<OhlcBloc>().currentTimeframe;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        
        children: [
          _buildTimeframeButton(context, Timeframe.oneMinute, current == Timeframe.oneMinute, label: "1M"),
          const SizedBox(width: 8),
          _buildTimeframeButton(context, Timeframe.fiveMinute, current == Timeframe.fiveMinute, label: "5M"),
        ],
      ),
    );
  }

  Widget _buildTimeframeButton(BuildContext context, Timeframe tf, bool selected, {required String label}) {
    return ElevatedButton(
      onPressed: () => context.read<OhlcBloc>().add(ChangeTimeframe(tf)),
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey.shade800,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        elevation: selected ? 4 : 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
