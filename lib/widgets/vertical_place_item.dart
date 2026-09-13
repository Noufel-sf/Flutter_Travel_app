import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/haptics.dart';
import 'package:go_router/go_router.dart';

class VerticalPlaceItem extends StatelessWidget {
  final Place place;

  const VerticalPlaceItem({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final heroTag = "vertical_place_${place.id}";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: () {
          context.push('/details/${place.id}', extra: place);
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 14.0,
                offset: const Offset(0, 4.0),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              // Rounded Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: Hero(
                  tag: heroTag,
                  child: Image.asset(
                    place.img,
                    height: 84.0,
                    width: 84.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14.0),

              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      place.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: isDark ? Colors.white : Constants.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_rounded,
                          size: 13.0,
                          color: Constants.brandBlue,
                        ),
                        const SizedBox(width: 3.0),
                        Expanded(
                          child: Text(
                            place.location,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "\$${place.pricePerNight.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                                color: Constants.brandBlue,
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
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Constants.accentGold, size: 14),
                            const SizedBox(width: 2.0),
                            Text(
                              "${place.rating}",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color:
                                    isDark ? Colors.white70 : Constants.textDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quick Bookmark Button
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final isSaved = (state is FavoritesLoaded)
                        ? state.isFavorite(place.id)
                        : false;
                    return IconButton(
                      icon: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_outline_rounded,
                        color: isSaved
                            ? Constants.brandBlue
                            : const Color(0xFF94A3B8),
                        size: 20.0,
                      ),
                      onPressed: () {
                        Haptics.light();
                        context.read<FavoritesCubit>().toggleFavorite(place.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
