import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:flutter_travel_concept/screens/favorites_screen.dart';
import 'package:flutter_travel_concept/screens/home.dart';
import 'package:flutter_travel_concept/screens/profile_screen.dart';
import 'package:flutter_travel_concept/screens/reviews_screen.dart';
import 'package:flutter_travel_concept/services/booking_service.dart';
import 'package:flutter_travel_concept/services/reviews_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/haptics.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          const Home(),
          FavoritesScreen(
            onExploreTap: () => navigationTapped(0),
          ),
          ReviewsScreen(
            onExploreTap: () => navigationTapped(0),
          ),
          ProfileScreen(
            onExploreTap: () => navigationTapped(0),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64.0,
          margin: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 24.0,
                offset: const Offset(0, 8.0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavButton(
                pageIndex: 0,
                icon: Icons.home_rounded,
                inactiveIcon: Icons.home_outlined,
              ),
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final count = (state is FavoritesLoaded)
                      ? state.favoriteIds.length
                      : 0;
                  return _buildNavButton(
                    pageIndex: 1,
                    icon: Icons.bookmark_rounded,
                    inactiveIcon: Icons.bookmark_border_rounded,
                    showBadge: count > 0,
                  );
                },
              ),
              ListenableBuilder(
                listenable: reviewsService,
                builder: (context, _) => _buildNavButton(
                  pageIndex: 2,
                  icon: Icons.chat_bubble_rounded,
                  inactiveIcon: Icons.chat_bubble_outline_rounded,
                  showBadge: reviewsService.count > 0,
                ),
              ),
              ListenableBuilder(
                listenable: bookingService,
                builder: (context, _) => _buildNavButton(
                  pageIndex: 3,
                  icon: Icons.person_rounded,
                  inactiveIcon: Icons.person_outline_rounded,
                  showBadge: bookingService.count > 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required int pageIndex,
    required IconData icon,
    required IconData inactiveIcon,
    bool showBadge = false,
  }) {
    final isSelected = _page == pageIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(24.0),
      onTap: () => navigationTapped(pageIndex),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: isSelected ? Constants.brandBlue : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: IconBadge(
            icon: isSelected ? icon : inactiveIcon,
            size: 24.0,
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            showBadge: showBadge && !isSelected,
          ),
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    Haptics.light();
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
}
