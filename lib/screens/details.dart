import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:flutter_travel_concept/services/reviews_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/haptics.dart';
import 'package:flutter_travel_concept/widgets/booking_bottom_sheet.dart';
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
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    final images = place.images.isNotEmpty ? place.images : [place.img];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image Header with Floating Controls
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Image Carousel
                SizedBox(
                  height: 360.0,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() => _currentImageIndex = index);
                        },
                        itemBuilder: (context, index) {
                          Widget img = Image.asset(
                            images[index],
                            height: 360.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );

                          if (index == 0 && widget.heroTag != null) {
                            img = Hero(
                              tag: widget.heroTag!,
                              child: img,
                            );
                          }
                          return ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(32.0),
                            ),
                            child: img,
                          );
                        },
                      ),

                      // Gradient overlay at top for button contrast
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 100.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Page Indicators
                      Positioned(
                        bottom: 44.0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (index) {
                            final isSelected = _currentImageIndex == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3.0),
                              height: 6.0,
                              width: isSelected ? 24.0 : 6.0,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // Top Floating Action Buttons (Back & Bookmark)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _floatingGlassButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder<ThemeMode>(
                              valueListenable: themeModeNotifier,
                              builder: (context, mode, _) {
                                final isDarkMode = mode == ThemeMode.dark;
                                return _floatingGlassButton(
                                  icon: isDarkMode
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_outlined,
                                  onTap: () {
                                    themeModeNotifier.value = isDarkMode
                                        ? ThemeMode.light
                                        : ThemeMode.dark;
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 10.0),
                            BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, state) {
                                final isSaved = (state is FavoritesLoaded)
                                    ? state.isFavorite(place.id)
                                    : false;
                                return _floatingGlassButton(
                                  icon: isSaved
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  iconColor: isSaved
                                      ? Constants.brandBlue
                                      : Colors.white,
                                  onTap: () {
                                    Haptics.light();
                                    context.read<FavoritesCubit>().toggleFavorite(place.id);
                                    final willBeSaved = !isSaved;
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 1),
                                        content: Text(
                                          willBeSaved
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
                      ],
                    ),
                  ),
                ),

                // Floating Title & Rating Card (Overlapping image bottom)
                Positioned(
                  bottom: -32.0,
                  left: 20.0,
                  right: 20.0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(22.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.35 : 0.08),
                          blurRadius: 20.0,
                          offset: const Offset(0, 8.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : Constants.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 15.0,
                                    color: Constants.brandBlue,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Expanded(
                                    child: Text(
                                      place.location,
                                      style: TextStyle(
                                        fontSize: 13.0,
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
                            ],
                          ),
                        ),
                        const SizedBox(width: 12.0),

                        // Royal Blue Rating Card (From Mockup)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Constants.brandBlue,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                color: Constants.brandBlue
                                    .withValues(alpha: 0.35),
                                blurRadius: 10.0,
                                offset: const Offset(0, 4.0),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded,
                                      color: Constants.accentGold, size: 16),
                                  const SizedBox(width: 3.0),
                                  Text(
                                    "${place.rating}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2.0),
                              const Text(
                                "Reviews",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 52.0, 20.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    place.details,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.6,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Location Map Preview (From Mockup)
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  _buildMapPreview(context, place),
                  const SizedBox(height: 26.0),

                  // Traveler Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Traveler Reviews",
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isDark ? Colors.white : Constants.textDark,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add_comment_rounded, size: 16),
                        label: const Text(
                          "Write Tip",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onPressed: () {
                          WriteReviewDialog.show(context, defaultPlace: place);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  _buildReviewsPreview(context, place),

                  const SizedBox(height: 100.0), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Reservation Bar (From Mockup)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24.0, 14.0, 24.0, 20.0),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 20.0,
              offset: const Offset(0, -4.0),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Text(
                        "\$${place.pricePerNight.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                          color: Constants.brandBlue,
                        ),
                      ),
                      Text(
                        "/night",
                        style: TextStyle(
                          fontSize: 13.0,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36.0, vertical: 15.0),
                ),
                onPressed: () {
                  Haptics.medium();
                  BookingBottomSheet.show(context, place);
                },
                child: const Text(
                  "Booking Now",
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingGlassButton({
    required IconData icon,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: onTap,
      child: Container(
        height: 42.0,
        width: 42.0,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(icon, size: 18.0, color: iconColor),
        ),
      ),
    );
  }

  Widget _buildMapPreview(BuildContext context, Place place) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 130.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Stack(
        children: [
          // Styled Map Grid graphic
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: CustomPaint(
                painter: _MapGridPainter(isDark: isDark),
              ),
            ),
          ),
          // Center Location Pin Card
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4.0),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Constants.brandBlue,
                    size: 16.0,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    place.location,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsPreview(BuildContext context, Place place) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: reviewsService,
      builder: (context, _) {
        final placeReviews = reviewsService.getReviewsForPlace(place.id);
        if (placeReviews.isEmpty) {
          return Text(
            "No tips yet. Be the first traveler to share your experience!",
            style: TextStyle(fontSize: 13.5, color: Colors.blueGrey[400]),
          );
        }

        final topReview = placeReviews.first;

        return Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color:
                  isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 12.0,
                offset: const Offset(0, 4.0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topReview.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Constants.accentGold, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        topReview.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "\"${topReview.comment}\"",
                style: TextStyle(
                  fontSize: 13.0,
                  fontStyle: FontStyle.italic,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;

  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.blueGrey.withValues(alpha: 0.12)
      ..strokeWidth = 1.5;

    // Draw stylized road grid
    canvas.drawLine(
        Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.6), linePaint);
    canvas.drawLine(
        Offset(0, size.height * 0.75), Offset(size.width, size.height * 0.3), linePaint);
    canvas.drawLine(
        Offset(size.width * 0.3, 0), Offset(size.width * 0.45, size.height), linePaint);
    canvas.drawLine(
        Offset(size.width * 0.7, 0), Offset(size.width * 0.65, size.height), linePaint);

    final roadPaint = Paint()
      ..color = isDark
          ? const Color(0xFF334155).withValues(alpha: 0.4)
          : Colors.blue.withValues(alpha: 0.08)
      ..strokeWidth = 6.0;

    canvas.drawLine(
        Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
