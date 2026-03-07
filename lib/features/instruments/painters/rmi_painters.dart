import 'dart:math' as math;

import 'package:flutter/material.dart';

class RMIMarksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final whiteTrianglePaint = Paint()..color = Colors.white;
    final orangeTrianglePaint = Paint()..color = Colors.orange;

    for (int i = 0; i < 8; i++) {
      final path = Path();
      path.moveTo(0, -radius + 10);
      path.lineTo(-5, -radius);
      path.lineTo(5, -radius);
      path.close();

      canvas.drawPath(path, i == 0 ? orangeTrianglePaint : whiteTrianglePaint);
      canvas.rotate(45 * math.pi / 180);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RMIRosePainter extends CustomPainter {
  final double currentHeading;

  RMIRosePainter({required this.currentHeading});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    canvas.rotate(-currentHeading * math.pi / 180);

    final ringPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35;

    canvas.drawCircle(Offset.zero, radius - 20, ringPaint);

    final tickPaint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.square;

    for (int i = 0; i < 360; i += 5) {
      canvas.save();
      canvas.rotate(i * math.pi / 180);

      if (i % 30 == 0) {
        tickPaint.strokeWidth = 2;
        canvas.drawLine(Offset(0, -radius + 5), Offset(0, -radius + 18), tickPaint);

        String label;
        if (i == 0) label = "N";
        else if (i == 90) label = "E";
        else if (i == 180) label = "S";
        else if (i == 270) label = "W";
        else label = (i ~/ 10).toString();

        final textPainter = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -radius + 22),
        );

      } else if (i % 10 == 0) {
        tickPaint.strokeWidth = 1;
        canvas.drawLine(Offset(0, -radius + 5), Offset(0, -radius + 15), tickPaint);
      } else {
        tickPaint.strokeWidth = 0.5;
        canvas.drawLine(Offset(0, -radius + 5), Offset(0, -radius + 10), tickPaint);
      }

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RMIRosePainter oldDelegate) {
    return oldDelegate.currentHeading != currentHeading;
  }
}

class RMIBugPainter extends CustomPainter {
  final double currentHeading;
  final double targetHeading;

  RMIBugPainter({required this.currentHeading, required this.targetHeading});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    canvas.rotate((targetHeading - currentHeading) * math.pi / 180);

    final bugPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(-8, -radius + 5);
    path.lineTo(8, -radius + 5);
    path.lineTo(8, -radius + 18);
    path.lineTo(3, -radius + 18);
    path.lineTo(0, -radius + 12);
    path.lineTo(-3, -radius + 18);
    path.lineTo(-8, -radius + 18);
    path.close();

    canvas.drawPath(path, bugPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RMIBugPainter oldDelegate) {
    return oldDelegate.currentHeading != currentHeading ||
        oldDelegate.targetHeading != targetHeading;
  }
}

class RMINeedlePainter extends CustomPainter {
  final double currentHeading;
  final double bearing;

  RMINeedlePainter({required this.currentHeading, required this.bearing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    // L'aiguille pointe vers le relèvement (Bearing)
    // On doit soustraire le cap actuel car tout l'instrument tourne
    canvas.rotate((bearing - currentHeading) * math.pi / 180);

    final paint = Paint()
      ..color = const Color(0xFFFFD700) // Jaune Or (ADF standard)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    // Dessin de la flèche (Pointe)
    final headPath = Path();
    headPath.moveTo(0, -radius + 20); // Pointe
    headPath.lineTo(-6, -radius + 45);
    headPath.lineTo(6, -radius + 45);
    headPath.close();
    canvas.drawPath(headPath, paint);

    // Corps de l'aiguille (Traversant)
    // Partie avant
    canvas.drawRect(Rect.fromCenter(center: Offset(0, -radius / 2 + 10), width: 3, height: radius - 40), paint);
    // Partie arrière (Queue)
    canvas.drawRect(Rect.fromCenter(center: Offset(0, radius / 2 - 5), width: 3, height: radius - 30), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RMINeedlePainter oldDelegate) {
    return oldDelegate.currentHeading != currentHeading || oldDelegate.bearing != bearing;
  }
}

class RMIAirplanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    // Fuselage
    path.moveTo(0, -8);
    path.lineTo(0, 12);
    // Ailes
    path.moveTo(-12, -2);
    path.lineTo(12, -2);
    // Empennage (Queue)
    path.moveTo(-5, 8);
    path.lineTo(5, 8);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}