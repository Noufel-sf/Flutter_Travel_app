import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/widgets/shimmer_loading.dart';

/// Skeleton list for the Favorites / Bookmarks screen
class FavoritesSkeleton extends StatelessWidget {
  final int itemCount;

  const FavoritesSkeleton({super.key, this.itemCount = 4});

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
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ShimmerEffect(
            child: Row(
              children: [
                // Image square
                const ShimmerBox(
                  width: 90.0,
                  height: 90.0,
                  borderRadius: 14.0,
                ),
                const SizedBox(width: 14.0),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 130.0, height: 15.0, borderRadius: 4.0),
                      SizedBox(height: 8.0),
                      ShimmerBox(width: 95.0, height: 11.0, borderRadius: 3.0),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerBox(width: 65.0, height: 16.0, borderRadius: 5.0),
                          ShimmerBox(width: 45.0, height: 16.0, borderRadius: 5.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
