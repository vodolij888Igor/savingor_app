import 'package:flutter/material.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

/// Placeholder until Google Maps SDK is integrated.
class NearbyMapPlaceholderCard extends StatelessWidget {
  const NearbyMapPlaceholderCard({super.key});

  static const Color _mapTint = Color(0xFFE8EFE6);
  static const Color _mapGrid = Color(0xFFD8E4D4);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _mapTint,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: SavingorColors.primaryStroke.withOpacity(0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: _MapGridPainter(),
            ),
          ),
          const Positioned(top: 28, left: 42, child: _MapPin()),
          const Positioned(top: 52, right: 56, child: _MapPin(small: true)),
          const Positioned(bottom: 36, left: 88, child: _MapPin(small: true)),
          const Positioned(bottom: 48, right: 40, child: _MapPin()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.map_outlined,
                  size: 32,
                  color: SavingorColors.primaryStroke.withOpacity(0.55),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Map preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real Google Maps integration coming next.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({this.small = false});

  final bool small;

  @override
  Widget build(BuildContext context) {
    final double size = small ? 28 : 34;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: SavingorColors.primaryStroke.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.location_on_rounded,
        size: small ? 18 : 22,
        color: SavingorColors.primaryStroke,
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = NearbyMapPlaceholderCard._mapGrid.withOpacity(0.5)
      ..strokeWidth = 1;

    const double step = 28;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
