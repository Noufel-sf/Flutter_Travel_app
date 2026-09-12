import 'package:flutter/material.dart';

/// High-performance 60fps Shimmer Loading Engine
/// Animates a continuous luminous wave over child placeholder widgets.
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final base = widget.baseColor ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));
    final highlight = widget.highlightColor ??
        (isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final double value = _controller.value;
            // Translates the gradient sweep from left (-1.0) to right (2.0)
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                base,
                highlight,
                base,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(slidePercent: value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // Shifts the gradient horizontally by 3x bounds width to create smooth continuous pass
    final dx = bounds.width * (slidePercent * 3.0 - 1.0);
    return Matrix4.translationValues(dx, 0.0, 0.0);
  }
}

/// A convenient rounded placeholder block that pairs with ShimmerEffect
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shapeBorder;
  final Color? color;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.shapeBorder,
    this.color,
  });

  const ShimmerBox.circular({
    super.key,
    required double size,
    this.color,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = color ??
        (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0));

    if (shapeBorder != null) {
      return Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: defaultColor,
          shape: shapeBorder!,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: defaultColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
