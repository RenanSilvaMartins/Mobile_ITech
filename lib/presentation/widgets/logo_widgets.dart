import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  
  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GoogleLogoPainter(),
      ),
    );
  }
}

class MicrosoftLogo extends StatelessWidget {
  final double size;
  
  const MicrosoftLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MicrosoftLogoPainter(),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6A1B9A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Desenhar arco do G (3/4 de círculo) - abertura à direita
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.79,  // 45 graus
      4.71,  // 270 graus (3/4 do círculo)
      false,
      paint,
    );
    
    // Barra horizontal interna do G
    final linePaint = Paint()
      ..color = const Color(0xFF6A1B9A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx + radius * 0.7, center.dy),
      linePaint,
    );
    
    // Barra vertical do G
    canvas.drawLine(
      Offset(center.dx + radius * 0.7, center.dy),
      Offset(center.dx + radius * 0.7, center.dy + radius * 0.5),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MicrosoftLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6A1B9A)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final logoSize = size.width * 0.7; // Mesmo tamanho proporcional da Google
    final squareSize = logoSize * 0.4;
    final gap = logoSize * 0.05;

    final startX = center.dx - logoSize / 2;
    final startY = center.dy - logoSize / 2;

    // Quatro quadrados
    canvas.drawRect(Rect.fromLTWH(startX, startY, squareSize, squareSize), paint);
    canvas.drawRect(Rect.fromLTWH(startX + squareSize + gap, startY, squareSize, squareSize), paint);
    canvas.drawRect(Rect.fromLTWH(startX, startY + squareSize + gap, squareSize, squareSize), paint);
    canvas.drawRect(Rect.fromLTWH(startX + squareSize + gap, startY + squareSize + gap, squareSize, squareSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}