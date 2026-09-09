import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/services/favorites_service.dart';
import 'package:flutter_travel_concept/util/const.dart';

import '../screens/details.dart';

class HorizontalPlaceItem extends StatelessWidget {
  final Place place;

  const HorizontalPlaceItem({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final heroTag = "horizontal_place_${place.id}";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 175.0,
      margin: const EdgeInsets.only(right: 16.0, bottom: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Details(place: place, heroTag: heroTag),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                blurRadius: 16.0,
                offset: const Offset(0, 4.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image with Floating Rating Badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Hero(
                      tag: heroTag,
                      child: Image.asset(
                        place.img,
                        height: 140.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    left: 8.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Constants.accentGold, size: 14),
                          const SizedBox(width: 3.0),
                          Text(
                            "${place.rating}",
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  place.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: isDark ? Colors.white : Constants.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4.0),

              // Price & Quick Bookmark Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              "\$${place.pricePerNight.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.0,
                                color: Constants.brandBlue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "/night",
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListenableBuilder(
                      listenable: favoritesService,
                      builder: (context, _) {
                        final isSaved = favoritesService.isFavorite(place.id);
                        return InkWell(
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: () {
                            favoritesService.toggleFavorite(place.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              isSaved
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_outline_rounded,
                              size: 20.0,
                              color: isSaved
                                  ? Constants.brandBlue
                                  : (isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF94A3B8)),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
