import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class RMIMarksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final double chamfer = 30.0;

    final outerBezel = Path()
      ..moveTo(chamfer, 0)
      ..lineTo(size.width - chamfer, 0)
      ..lineTo(size.width, chamfer)
      ..lineTo(size.width, size.height - chamfer)
      ..lineTo(size.width - chamfer, size.height)
      ..lineTo(chamfer, size.height)
      ..lineTo(0, size.height - chamfer)
      ..lineTo(0, chamfer)
      ..close();

    final innerHole = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius - 2));

    final bezelPath = Path.combine(PathOperation.difference, outerBezel, innerHole);

    final bezelPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bezelPath, bezelPaint);

    final bezelBorderPaint = Paint()
      ..color = const Color(0xFF333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(outerBezel, bezelBorderPaint);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final whiteTrianglePaint = Paint()..color = AppColors.white;
    final orangeTrianglePaint = Paint()..color = AppColors.orange;

    for (int i = 0; i < 8; i++) {
      final path = Path();
      path.moveTo(0, -radius + 12);
      path.lineTo(-5, -radius + 2);
      path.lineTo(5, -radius + 2);
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
  RMIRosePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final ringPaint = Paint()
      ..color = AppColors.instrumentRing
      ..style = PaintingStyle.stroke
      ..strokeWidth = 35;

    canvas.drawCircle(Offset.zero, radius - 20, ringPaint);

    final tickPaint = Paint()
      ..color = AppColors.white
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
              color: AppColors.white,
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RMIBugPainter extends CustomPainter {
  final double targetHeading;

  RMIBugPainter({required this.targetHeading});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    canvas.rotate(targetHeading * math.pi / 180);

    final bugPaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(-8, -radius + 18);
    path.lineTo(8, -radius + 18);
    path.lineTo(8, -radius + 5);
    path.lineTo(3, -radius + 5);
    path.lineTo(0, -radius + 11);
    path.lineTo(-3, -radius + 5);
    path.lineTo(-8, -radius + 5);
    path.close();

    canvas.drawPath(path, bugPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RMIBugPainter oldDelegate) {
    return oldDelegate.targetHeading != targetHeading;
  }
}

class RMINeedlePainter extends CustomPainter {
  final double bearing;

  RMINeedlePainter({required this.bearing});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    canvas.rotate(bearing * math.pi / 180);

    final paint = Paint()
      ..color = AppColors.adfNeedle
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final headPath = Path();
    headPath.moveTo(0, -radius + 20);
    headPath.lineTo(-6, -radius + 45);
    headPath.lineTo(6, -radius + 45);
    headPath.close();
    canvas.drawPath(headPath, paint);

    canvas.drawRect(Rect.fromCenter(center: Offset(0, -radius / 2 + 10), width: 3, height: radius - 40), paint);
    canvas.drawRect(Rect.fromCenter(center: Offset(0, radius / 2 - 5), width: 3, height: radius - 30), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RMINeedlePainter oldDelegate) {
    return oldDelegate.bearing != bearing;
  }
}

class RMIAirplanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final paint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, -8);
    path.lineTo(0, 12);
    path.moveTo(-12, -2);
    path.lineTo(12, -2);
    path.moveTo(-5, 8);
    path.lineTo(5, 8);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RMIKnobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = AppColors.instrumentGrey
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, basePaint);

    final topPaint = Paint()
      ..color = AppColors.instrumentBackground
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 4, topPaint);

    final ridgePaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    for (int i = 0; i < 12; i++) {
      canvas.drawLine(Offset(0, radius - 5), Offset(0, radius), ridgePaint);
      canvas.rotate(math.pi / 6);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
