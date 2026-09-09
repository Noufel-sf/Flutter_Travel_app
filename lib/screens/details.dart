import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/services/favorites_service.dart';
import 'package:flutter_travel_concept/services/reviews_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/widgets/booking_bottom_sheet.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';
import 'package:flutter_travel_concept/widgets/write_review_dialog.dart';

class Details extends StatefulWidget {
  final Place place;
  final String? heroTag;

  const Details({
    super.key,
    required this.place,
    this.heroTag,
  });

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final images = place.images.isNotEmpty ? place.images : [place.img];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, currentMode, _) {
              final isDark = currentMode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? "Switch to White Mode" : "Switch to Dark Mode",
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                ),
                onPressed: () {
                  themeModeNotifier.value =
                      isDark ? ThemeMode.light : ThemeMode.dark;
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
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10.0),
          buildSlider(images),
          const SizedBox(height: 20),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      place.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ListenableBuilder(
                    listenable: favoritesService,
                    builder: (context, _) {
                      final isSaved = favoritesService.isFavorite(place.id);
                      return IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? Colors.amber[800] : null,
                        ),
                        tooltip:
                            isSaved ? "Remove from saved" : "Save destination",
                        onPressed: () async {
                          final added =
                              await favoritesService.toggleFavorite(place.id);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                added
                                    ? "${place.name} saved to bookmarks!"
                                    : "${place.name} removed from bookmarks.",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.blueGrey[300],
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      place.location,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        "${place.rating}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  place.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  place.details,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Traveler Reviews",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add_comment_outlined, size: 16),
                    label: const Text("Write Tip"),
                    onPressed: () {
                      WriteReviewDialog.show(context, defaultPlace: place);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              ListenableBuilder(
                listenable: reviewsService,
                builder: (context, _) {
                  final placeReviews =
                      reviewsService.getReviewsForPlace(place.id);
                  if (placeReviews.isEmpty) {
                    return Text(
                      "No tips yet. Be the first to share your experience!",
                      style:
                          TextStyle(fontSize: 13, color: Colors.blueGrey[400]),
                    );
                  }
                  final topReview = placeReviews.first;
                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  return Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              topReview.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  topReview.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "\"${topReview.comment}\"",
                          style: const TextStyle(
                              fontSize: 13, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Book Trip",
        icon: const Icon(Icons.airplanemode_active),
        label: const Text(
          "Book Now",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        onPressed: () => BookingBottomSheet.show(context, place),
      ),
    );
  }

  Widget buildSlider(List<String> images) {
    return SizedBox(
      height: 250.0,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          final imgPath = images[index];
          Widget imgWidget = Image.asset(
            imgPath,
            height: 250.0,
            width: MediaQuery.of(context).size.width - 40.0,
            fit: BoxFit.cover,
          );

          if (index == 0 && widget.heroTag != null) {
            imgWidget = Hero(
              tag: widget.heroTag!,
              child: imgWidget,
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: imgWidget,
            ),
          );
        },
      ),
    );
  }
}
