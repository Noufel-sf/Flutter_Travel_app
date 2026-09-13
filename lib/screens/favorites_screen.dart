import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/haptics.dart';
import 'package:flutter_travel_concept/widgets/favorites_skeleton.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const FavoritesScreen({super.key, this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved Places",
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
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const FavoritesSkeleton();
          }

          if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<FavoritesCubit>().loadFavorites(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final favoritePlaces = (state is FavoritesLoaded)
              ? state.favoritePlaces
              : [];

          if (favoritePlaces.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Constants.brandBlueSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bookmark_outline_rounded,
                        size: 56.0,
                        color: Constants.brandBlue,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "No saved places yet",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Explore amazing destinations and tap the bookmark icon to save your favorite spots for your next journey.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.brandBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      icon: const Icon(Icons.explore_rounded, size: 18),
                      label: const Text(
                        "Explore Destinations",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onPressed: onExploreTap,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: Constants.brandBlue,
            onRefresh: () async {
              Haptics.light();
              await context.read<FavoritesCubit>().loadFavorites();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              itemCount: favoritePlaces.length,
              itemBuilder: (context, index) {
                final place = favoritePlaces[index];
                final heroTag = "favorite_place_${place.id}";

                return Dismissible(
                  key: Key("favorite_${place.id}"),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    margin: const EdgeInsets.only(bottom: 14.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  onDismissed: (_) {
                    Haptics.light();
                    context.read<FavoritesCubit>().toggleFavorite(place.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text("${place.name} removed from saved places"),
                        action: SnackBarAction(
                          label: "UNDO",
                          textColor: Constants.accentGold,
                          onPressed: () {
                            Haptics.light();
                            context.read<FavoritesCubit>().toggleFavorite(place.id);
                          },
                        ),
                      ),
                    );
                  },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Material(
                    color: isDark ? const Color(0xFF1E2430) : Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18.0),
                      onTap: () {
                        context.push('/details/${place.id}', extra: place);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF2E384D)
                                : const Color(0xFFE8EEF8),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1E60FF).withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: Hero(
                                tag: heroTag,
                                child: Image.asset(
                                  place.img,
                                  height: 80.0,
                                  width: 80.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15.0,
                                      letterSpacing: -0.2,
                                      color: isDark ? Colors.white : Constants.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        size: 14.0,
                                        color: Constants.brandBlue,
                                      ),
                                      const SizedBox(width: 3.0),
                                      Expanded(
                                        child: Text(
                                          place.location,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${place.price}/night",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14.0,
                                          color: Constants.brandBlue,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: Constants.accentGold.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Constants.accentGold,
                                              size: 13,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              "${place.rating}",
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                                color: Constants.accentGold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark_rounded,
                                color: Constants.brandBlue,
                                size: 22,
                              ),
                              tooltip: "Remove from Saved",
                              onPressed: () {
                                context.read<FavoritesCubit>().toggleFavorite(place.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
}
