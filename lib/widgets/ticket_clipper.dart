import 'package:flutter/material.dart';

/// A custom clipper that gives a ticket or boarding pass rounded corners
/// plus symmetrical semi-circular cutouts ("punches") on the left and right sides.
class TicketClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double punchRadius;
  final double punchPositionRatio; // 0.0 to 1.0 (e.g. 0.68 for bottom stub)

  const TicketClipper({
    this.cornerRadius = 20.0,
    this.punchRadius = 14.0,
    this.punchPositionRatio = 0.68,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final punchY = size.height * punchPositionRatio;

    // Top-left corner
    path.moveTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Top edge
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right corner
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Right edge down to right punch
    path.lineTo(size.width, punchY - punchRadius);

    // Right punch (curving inward towards center)
    path.arcToPoint(
      Offset(size.width, punchY + punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // Right edge down to bottom-right corner
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - cornerRadius, size.height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Left edge up to left punch
    path.lineTo(0, punchY + punchRadius);

    // Left punch (curving inward towards center)
    path.arcToPoint(
      Offset(0, punchY - punchRadius),
      radius: Radius.circular(punchRadius),
      clockwise: false,
    );

    // Left edge up to top-left start
    path.lineTo(0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TicketClipper oldClipper) {
    return oldClipper.cornerRadius != cornerRadius ||
        oldClipper.punchRadius != punchRadius ||
        oldClipper.punchPositionRatio != punchPositionRatio;
  }
}

/// Custom painter to draw a crisp dashed line across the ticket perforation.
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const DashedLinePainter({
    required this.color,
    this.dashWidth = 6.0,
    this.dashSpace = 5.0,
    this.strokeWidth = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
