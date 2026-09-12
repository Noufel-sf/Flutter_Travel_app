import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/widgets/shimmer_loading.dart';

/// Skeleton card matching the dimensions and layout of HorizontalPlaceItem
class HorizontalPlaceSkeleton extends StatelessWidget {
  const HorizontalPlaceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8);

    return Container(
      width: 250.0,
      margin: const EdgeInsets.only(right: 16.0, bottom: 8.0, top: 4.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ShimmerEffect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area placeholder
            const ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(19.0)),
              child: ShimmerBox(
                height: 140.0,
                width: double.infinity,
                borderRadius: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title line
                  const ShimmerBox(width: 150.0, height: 14.0, borderRadius: 4.0),
                  const SizedBox(height: 8.0),
                  // Location line
                  const ShimmerBox(width: 100.0, height: 11.0, borderRadius: 3.0),
                  const SizedBox(height: 10.0),
                  // Price and rating row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      ShimmerBox(width: 65.0, height: 14.0, borderRadius: 4.0),
                      ShimmerBox(width: 45.0, height: 14.0, borderRadius: 4.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton card matching the dimensions and layout of VerticalPlaceItem
class VerticalPlaceSkeleton extends StatelessWidget {
  const VerticalPlaceSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8);

    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: ShimmerEffect(
        child: Row(
          children: [
            // Left image placeholder
            const ShimmerBox(
              width: 72.0,
              height: 72.0,
              borderRadius: 14.0,
            ),
            const SizedBox(width: 14.0),
            // Center info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(width: 140.0, height: 14.0, borderRadius: 4.0),
                  SizedBox(height: 8.0),
                  ShimmerBox(width: 100.0, height: 11.0, borderRadius: 3.0),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      ShimmerBox(width: 55.0, height: 18.0, borderRadius: 6.0),
                      SizedBox(width: 8.0),
                      ShimmerBox(width: 40.0, height: 18.0, borderRadius: 6.0),
                    ],
                  ),
                ],
              ),
            ),
            // Right bookmark placeholder circle
            const ShimmerBox.circular(size: 32.0),
          ],
        ),
      ),
    );
  }
}

/// Full-screen home shimmer placeholder
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal carousel skeleton
        SizedBox(
          height: 245.0,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20.0),
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (_, __) => const HorizontalPlaceSkeleton(),
          ),
        ),
        const SizedBox(height: 14.0),
        // Vertical list skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: List.generate(
              3,
              (_) => const VerticalPlaceSkeleton(),
            ),
          ),
        ),
      ],
    );
  }
}
