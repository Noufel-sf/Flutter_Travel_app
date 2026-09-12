import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:flutter_travel_concept/screens/boarding_pass_screen.dart';
import 'package:flutter_travel_concept/screens/details.dart';
import 'package:flutter_travel_concept/services/booking_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onExploreTap;

  const ProfileScreen({super.key, this.onExploreTap});

  String _formatDate(DateTime d) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${months[d.month - 1]} ${d.day}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          // Profile Header
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Constants.brandBlue, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Constants.brandBlueSoft,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 44,
                        color: Constants.brandBlue,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Constants.brandBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Noufel Traveler",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: isDark ? Colors.white : Constants.textDark,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Constants.brandBlueSoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Pro Explorer ✈️",
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: Constants.brandBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "Member since 2026",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22.0),

          // Stats Overview
          Row(
            children: [
              Expanded(
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) {
                    final count = (state is FavoritesLoaded)
                        ? state.favoriteIds.length
                        : 0;
                    return _statCard(
                      context,
                      title: "Saved",
                      count: "$count",
                      icon: Icons.bookmark_rounded,
                      iconColor: Constants.brandBlue,
                      bgColor: Constants.brandBlueSoft,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: ListenableBuilder(
                  listenable: bookingService,
                  builder: (context, _) => _statCard(
                    context,
                    title: "Trips",
                    count: "${bookingService.count}",
                    icon: Icons.flight_takeoff_rounded,
                    iconColor: const Color(0xFF10B981),
                    bgColor: const Color(0xFF10B981).withValues(alpha: 0.12),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: _statCard(
                  context,
                  title: "Visited",
                  count: "5",
                  icon: Icons.place_rounded,
                  iconColor: Constants.accentGold,
                  bgColor: Constants.accentGold.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28.0),

          // My Bookings Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Bookings",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              ListenableBuilder(
                listenable: bookingService,
                builder: (context, _) {
                  return Text(
                    "${bookingService.count} active",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Bookings List
          ListenableBuilder(
            listenable: bookingService,
            builder: (context, _) {
              final bookings = bookingService.bookings;

              if (bookings.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2430) : Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Constants.brandBlueSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.luggage_rounded,
                          size: 40,
                          color: Constants.brandBlue,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      const Text(
                        "No active bookings yet",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        "Plan your dream getaway and book your first stay today!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.brandBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.explore_rounded, size: 16),
                        label: const Text(
                          "Explore Places",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onPressed: onExploreTap,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14.0),
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2430) : Colors.white,
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                booking.place.img,
                                height: 68.0,
                                width: 68.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          booking.place.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15.0,
                                            letterSpacing: -0.2,
                                            color: isDark ? Colors.white : Constants.textDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 3.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: const Text(
                                          "Confirmed",
                                          style: TextStyle(
                                            color: Color(0xFF10B981),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    "${_formatDate(booking.checkIn)} - ${_formatDate(booking.checkOut)} • ${booking.nights} nights",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${booking.guests} Guests • Ref: #${booking.id}",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 22.0,
                          color: isDark ? const Color(0xFF2E384D) : const Color(0xFFF1F5F9),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total: \$${booking.totalPrice.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.0,
                                  color: Constants.brandBlue,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              tooltip: "Cancel booking",
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 19,
                                color: Color(0xFFEF4444),
                              ),
                              onPressed: () {
                                _confirmCancelBooking(context, booking.id);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 4),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BoardingPassScreen(booking: booking),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.confirmation_number_outlined, size: 13),
                              label: const Text(
                                "Pass",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.brandBlueSoft,
                                foregroundColor: Constants.brandBlue,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Details(
                                      place: booking.place,
                                      heroTag: "booking_${booking.id}",
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.brandBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: const Text(
                                "View",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24.0),

          // Settings & Preferences
          Text(
            "Settings & Preferences",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: isDark ? Colors.white : Constants.textDark,
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2430) : Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(
                color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E60FF).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeModeNotifier,
                  builder: (context, currentMode, _) {
                    final isDarkMode = currentMode == ThemeMode.dark;
                    return SwitchListTile(
                      activeTrackColor: Constants.brandBlue,
                      secondary: Icon(
                        isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: Constants.brandBlue,
                      ),
                      title: const Text(
                        "Dark Theme",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        isDarkMode ? "Enabled" : "White Mode Active",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                        ),
                      ),
                      value: isDarkMode,
                      onChanged: (val) {
                        themeModeNotifier.value =
                            val ? ThemeMode.dark : ThemeMode.light;
                      },
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF2E384D) : const Color(0xFFF1F5F9),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Color(0xFFEF4444),
                  ),
                  title: const Text(
                    "Clear All Bookings",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Reset booking records",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                    ),
                  ),
                  onTap: () => _confirmClearBookings(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  void _confirmCancelBooking(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Cancel Booking?"),
        content: const Text(
          "Are you sure you want to cancel this reservation? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Keep"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              bookingService.cancelBooking(id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Booking has been cancelled"),
                ),
              );
            },
            child: const Text("Cancel Reservation"),
          ),
        ],
      ),
    );
  }

  void _confirmClearBookings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Clear All Bookings?"),
        content: const Text(
          "This will erase all saved booking records from your device.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(ctx);
              bookingService.clearAllBookings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All bookings cleared"),
                ),
              );
            },
            child: const Text("Clear All"),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String title,
    required String count,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2430) : Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8.0),
          Text(
            count,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Constants.textDark,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
