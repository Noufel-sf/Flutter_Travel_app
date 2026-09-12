import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/widgets/shimmer_loading.dart';

/// Skeleton list for Community Reviews screen
class ReviewsSkeleton extends StatelessWidget {
  final int itemCount;

  const ReviewsSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ShimmerEffect(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Avatar + Name + Rating
                Row(
                  children: [
                    const ShimmerBox.circular(size: 42.0),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShimmerBox(width: 110.0, height: 14.0, borderRadius: 4.0),
                          SizedBox(height: 6.0),
                          ShimmerBox(width: 70.0, height: 10.0, borderRadius: 3.0),
                        ],
                      ),
                    ),
                    const ShimmerBox(width: 50.0, height: 14.0, borderRadius: 4.0),
                  ],
                ),
                const SizedBox(height: 14.0),
                // Comment lines
                const ShimmerBox(width: double.infinity, height: 12.0, borderRadius: 3.0),
                const SizedBox(height: 6.0),
                const ShimmerBox(width: 220.0, height: 12.0, borderRadius: 3.0),
                const SizedBox(height: 14.0),
                // Bottom helpful action placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerBox(width: 80.0, height: 22.0, borderRadius: 8.0),
                    ShimmerBox(width: 60.0, height: 18.0, borderRadius: 6.0),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
