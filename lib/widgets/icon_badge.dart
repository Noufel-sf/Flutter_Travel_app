import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool showBadge;

  const IconBadge({
    super.key,
    required this.icon,
    this.size = 24.0,
    this.color,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Icon(
          icon,
          size: size,
          color: color,
        ),
        if (showBadge)
          Positioned(
            right: -2.0,
            top: -2.0,
            child: Container(
              height: 9.0,
              width: 9.0,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).cardColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
