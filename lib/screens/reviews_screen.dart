import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/models/review.dart';
import 'package:flutter_travel_concept/services/reviews_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/places.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';
import 'package:flutter_travel_concept/widgets/write_review_dialog.dart';

class ReviewsScreen extends StatefulWidget {
  final VoidCallback? onExploreTap;

  const ReviewsScreen({super.key, this.onExploreTap});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _selectedPlaceId = "All";

  String _formatTimeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 0) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    return "Just now";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Travel Community",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, currentMode, _) {
              final isDarkMode = currentMode == ThemeMode.dark;
              return IconButton(
                tooltip:
                    isDarkMode ? "Switch to White Mode" : "Switch to Dark Mode",
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined,
                ),
                onPressed: () {
                  themeModeNotifier.value =
                      isDarkMode ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
          IconButton(
            icon: const IconBadge(
              icon: Icons.notifications_none,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips for destinations
          SizedBox(
            height: 48.0,
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              scrollDirection: Axis.horizontal,
              itemCount: places.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final id = isAll ? "All" : places[index - 1].id;
                final label = isAll ? "All Places" : places[index - 1].name;
                final isSelected = _selectedPlaceId == id;

                return Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? Colors.white70 : Colors.blueGrey[700]),
                    ),
                    selectedColor:
                        isDark ? Colors.white : const Color(0xFF263238),
                    backgroundColor:
                        isDark ? const Color(0xFF1E1E1E) : Colors.blueGrey[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark ? Colors.white12 : Colors.black12),
                      ),
                    ),
                    onSelected: (val) {
                      setState(() {
                        _selectedPlaceId = id;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Reviews List
          Expanded(
            child: ListenableBuilder(
              listenable: reviewsService,
              builder: (context, _) {
                final allReviews = reviewsService.reviews;
                final filtered = _selectedPlaceId == "All"
                    ? allReviews
                    : allReviews
                        .where((r) => r.placeId == _selectedPlaceId)
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 56,
                            color: Colors.blueGrey[300],
                          ),
                          const SizedBox(height: 14.0),
                          const Text(
                            "No reviews for this place yet",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            "Be the first traveler to share tips and photos!",
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.blueGrey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 80.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final review = filtered[index];
                    return _reviewCard(context, review);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.rate_review),
        label: const Text(
          "Share Tip",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: isDark ? Colors.black : Colors.white,
        onPressed: () {
          Place? currentPlace;
          if (_selectedPlaceId != "All") {
            try {
              currentPlace =
                  places.firstWhere((p) => p.id == _selectedPlaceId);
            } catch (_) {}
          }
          WriteReviewDialog.show(context, defaultPlace: currentPlace);
        },
      ),
    );
  }

  Widget _reviewCard(BuildContext context, Review review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUpvoted = reviewsService.isUpvoted(review.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Rating, Time
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : "A",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                      _formatTimeAgo(review.createdAt),
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.blueGrey[300],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 3),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Place tag chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2B2B2B) : Colors.white,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: 11.0,
                  color: Colors.blueGrey[300],
                ),
                const SizedBox(width: 4.0),
                Text(
                  review.placeName,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[400],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),

          // Comment body
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10.0),

          // Helpful button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  reviewsService.toggleHelpful(review.id);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Icon(
                        isUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                        size: 15,
                        color: isUpvoted ? Colors.blueAccent : Colors.blueGrey[300],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Helpful (${review.helpfulCount})",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight:
                              isUpvoted ? FontWeight.bold : FontWeight.w500,
                          color: isUpvoted
                              ? Colors.blueAccent
                              : Colors.blueGrey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
