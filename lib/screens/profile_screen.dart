import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/screens/details.dart';
import 'package:flutter_travel_concept/services/booking_service.dart';
import 'package:flutter_travel_concept/services/favorites_service.dart';
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
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor:
                          isDark ? const Color(0xFF2C2C2C) : Colors.blueGrey[100],
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 12,
                        color: isDark ? Colors.black : Colors.white,
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
                    const Text(
                      "Noufel Traveler",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "Travel Enthusiast 🌍",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.blueGrey[400],
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "Member since 2026",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blueGrey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),

          // Stats Overview
          Row(
            children: [
              Expanded(
                child: ListenableBuilder(
                  listenable: favoritesService,
                  builder: (context, _) => _statCard(
                    context,
                    title: "Saved",
                    count: "${favoritesService.count}",
                    icon: Icons.favorite,
                    iconColor: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ListenableBuilder(
                  listenable: bookingService,
                  builder: (context, _) => _statCard(
                    context,
                    title: "Trips",
                    count: "${bookingService.count}",
                    icon: Icons.flight_takeoff,
                    iconColor: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _statCard(
                  context,
                  title: "Places Visited",
                  count: "5",
                  icon: Icons.place,
                  iconColor: Colors.orangeAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28.0),

          // My Bookings Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "My Bookings",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListenableBuilder(
                listenable: bookingService,
                builder: (context, _) {
                  return Text(
                    "${bookingService.count} active",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.blueGrey[400],
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
                    color: isDark
                        ? const Color(0xFF1E1E1E)
                        : Colors.blueGrey[50],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.luggage_outlined,
                        size: 48,
                        color: Colors.blueGrey[300],
                      ),
                      const SizedBox(height: 12.0),
                      const Text(
                        "No active bookings yet",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        "Plan your dream getaway and book your first stay today!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.blueGrey[400],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.explore),
                        label: const Text("Explore Places"),
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
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E1E)
                          : Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                booking.place.img,
                                height: 65.0,
                                width: 65.0,
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 2.0),
                                        decoration: BoxDecoration(
                                          color: Colors.green
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: const Text(
                                          "Confirmed",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${_formatDate(booking.checkIn)} - ${_formatDate(booking.checkOut)} • ${booking.nights} nights",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.blueGrey[400],
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    "${booking.guests} Guests • Ref: #${booking.id}",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.blueGrey[300],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 18.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total: \$${booking.totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _confirmCancelBooking(context, booking.id);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red[400],
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: const Text("Cancel"),
                                ),
                                const SizedBox(width: 8),
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
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                    foregroundColor:
                                        isDark ? Colors.black : Colors.white,
                                    visualDensity: VisualDensity.compact,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text("View"),
                                ),
                              ],
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
          const Text(
            "Settings & Preferences",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Column(
              children: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeModeNotifier,
                  builder: (context, currentMode, _) {
                    final isDarkMode = currentMode == ThemeMode.dark;
                    return SwitchListTile(
                      secondary: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      ),
                      title: const Text("Dark Theme"),
                      subtitle: Text(
                        isDarkMode ? "Enabled" : "White Mode Active",
                        style: const TextStyle(fontSize: 12.0),
                      ),
                      value: isDarkMode,
                      onChanged: (val) {
                        themeModeNotifier.value =
                            val ? ThemeMode.dark : ThemeMode.light;
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: const Text("Clear All Bookings"),
                  subtitle: const Text(
                    "Reset booking records",
                    style: TextStyle(fontSize: 12.0),
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 6.0),
          Text(
            count,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.blueGrey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
