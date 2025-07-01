
import 'package:flutter/material.dart';
import '../../../domain/entities/candle.dart';

class CandlePainter extends CustomPainter {
  final List<Candle> candles;
  final Offset? draggedPosition;
  static const double minPrice = 2000;
  static const double maxPrice = 5000;

  CandlePainter(this.candles, {this.draggedPosition});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final paint = Paint()..strokeWidth = 1;
    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    const double rightPadding = 60;
    final double chartWidth = size.width - rightPadding;
    final double candleWidth = chartWidth / candles.length;
    final double scaleY = size.height / (maxPrice - minPrice);

    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = i * candleWidth + candleWidth / 2;
      final yOpen = size.height - ((c.open - minPrice) * scaleY);
      final yClose = size.height - ((c.close - minPrice) * scaleY);
      final yHigh = size.height - ((c.high - minPrice) * scaleY);
      final yLow = size.height - ((c.low - minPrice) * scaleY);
      final isBullish = c.close >= c.open;

      paint.color = isBullish ? Colors.green : Colors.red;
      canvas.drawLine(Offset(x, yHigh), Offset(x, yLow), paint);

      final rect = Rect.fromLTRB(
        x - candleWidth / 4,
        isBullish ? yClose : yOpen,
        x + candleWidth / 4,
        isBullish ? yOpen : yClose,
      );
      canvas.drawRect(rect, paint);

      if (i == candles.length - 1) {
        final priceLabel = c.close.toStringAsFixed(2);
        textPainter.text = TextSpan(
          text: priceLabel,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        );
        textPainter.layout();
        canvas.drawRect(
          Rect.fromLTWH(x + 5, yClose - 8, textPainter.width + 6, textPainter.height),
          Paint()..color = Colors.black,
        );
        textPainter.paint(canvas, Offset(x + 8, yClose - 8));
      }
    }

    final int step = 250;
    for (double price = minPrice; price <= maxPrice; price += step) {
      final y = size.height - ((price - minPrice) * scaleY);
      final priceLabel = price.toInt().toString();

      textPainter.text = TextSpan(
        text: priceLabel,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(size.width - textPainter.width - 4, y - 6));

      final gridPaint = Paint()
        ..color = Colors.grey.withOpacity(0.2)
        ..strokeWidth = 0.5;

      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
    }
if (draggedPosition != null) {
  final price = maxPrice - (draggedPosition!.dy / size.height) * (maxPrice - minPrice);
  final linePaint = Paint()
    ..color = Colors.green
    ..strokeWidth = 1.2
    ..style = PaintingStyle.stroke;

  // Horizontal green line
  canvas.drawLine(
    Offset(0, draggedPosition!.dy),
    Offset(chartWidth, draggedPosition!.dy),
    linePaint,
  );

  // Price label text
  final priceLabel = price.toStringAsFixed(2);
  textPainter.text = TextSpan(
    text: ' ₹$priceLabel',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
  );
  textPainter.layout();

  final labelWidth = textPainter.width + 10;
  final labelHeight = textPainter.height + 6;

  final tooltipRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      size.width - labelWidth - 4,
      draggedPosition!.dy - labelHeight / 2,
      labelWidth,
      labelHeight,
    ),
    const Radius.circular(6),
  );

  final tooltipPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill
    ..strokeWidth = 1;

  // Tooltip background
  canvas.drawRRect(tooltipRect, tooltipPaint);

  // Tooltip border
  canvas.drawRRect(
    tooltipRect,
    Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1,
  );

  // Draw the price text
  textPainter.paint(
    canvas,
    Offset(
      size.width - labelWidth + 1,
      draggedPosition!.dy - textPainter.height / 2,
    ),
  );
 
   
    }
  }

  @override
  bool shouldRepaint(covariant CandlePainter oldDelegate) => true;
}
