import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/widgets/ticket_clipper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BoardingPassCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onQrTap;

  const BoardingPassCard({
    super.key,
    required this.booking,
    this.onQrTap,
  });

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return "${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}";
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E2430) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2E384D) : const Color(0xFFE2E8F0);
    final secondaryText = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final punchBg = isDark ? Constants.darkBG : const Color(0xFFF1F5F9);

    const punchRadius = 14.0;
    const cornerRadius = 22.0;

    return Stack(
      children: [
        // Physical ticket card container
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(cornerRadius),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Branded Header (Royal Blue Gradient Banner)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E60FF),
                      Color(0xFF0040D6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius - 1.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Icon(
                            Icons.flight_takeoff_rounded,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "TRAVELPASS AIRWAYS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              "Digital Boarding Pass • ${booking.serviceCode}",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.82),
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.4),
                          width: 1.0,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF10B981),
                            size: 11.0,
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            "CONFIRMED",
                            style: TextStyle(
                              color: Color(0xFF10B981),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Journey Route Section (Origin -> Destination)
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 20.0, 22.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Origin
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.originCode,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            "Departure City",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Flight Path Center Graphic
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6.0,
                                height: 6.0,
                                decoration: const BoxDecoration(
                                  color: Constants.brandBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                width: 50.0,
                                height: 1.5,
                                child: CustomPaint(
                                  painter: DashedLinePainter(
                                    color: Constants.brandBlue.withValues(alpha: 0.5),
                                    dashWidth: 4.0,
                                    dashSpace: 3.0,
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: 1.5708, // 90 degrees in radians
                                child: const Icon(
                                  Icons.flight_rounded,
                                  color: Constants.brandBlue,
                                  size: 18.0,
                                ),
                              ),
                              SizedBox(
                                width: 50.0,
                                height: 1.5,
                                child: CustomPaint(
                                  painter: DashedLinePainter(
                                    color: Constants.brandBlue.withValues(alpha: 0.5),
                                    dashWidth: 4.0,
                                    dashSpace: 3.0,
                                  ),
                                ),
                              ),
                              Container(
                                width: 6.0,
                                height: 6.0,
                                decoration: const BoxDecoration(
                                  color: Constants.brandBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                            decoration: BoxDecoration(
                              color: Constants.brandBlueSoft,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              "${booking.nights}N Stays",
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Constants.brandBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Destination
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            booking.destinationCode,
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              color: primaryText,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            booking.place.name,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: secondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Info Grid Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF151922) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(
                      color: isDark ? const Color(0xFF263043) : const Color(0xFFEDF2F7),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildInfoItem(
                              "PASSENGER",
                              booking.guestName,
                              primaryText,
                              secondaryText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildInfoItem(
                              "GATE / SUITE",
                              booking.gate,
                              primaryText,
                              secondaryText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildInfoItem(
                              "GUESTS",
                              "${booking.guests} Pax",
                              primaryText,
                              secondaryText,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(
                          height: 1.0,
                          color: isDark ? const Color(0xFF263043) : const Color(0xFFE2E8F0),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildInfoItem(
                              "CHECK-IN DATE",
                              _formatDate(booking.checkIn),
                              primaryText,
                              secondaryText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildInfoItem(
                              "BOARDING",
                              _formatTime(booking.checkIn),
                              primaryText,
                              secondaryText,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildInfoItem(
                              "CLASS",
                              "Deluxe",
                              Constants.brandBlue,
                              secondaryText,
                              isHighlight: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18.0),

              // 4. Perforation Tear Line with Side Notch Cutouts
              SizedBox(
                height: punchRadius * 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dashed perforation line
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: punchRadius + 4),
                      child: CustomPaint(
                        size: const Size(double.infinity, 2.0),
                        painter: DashedLinePainter(
                          color: isDark ? const Color(0xFF3B4861) : const Color(0xFFCBD5E1),
                          dashWidth: 6.0,
                          dashSpace: 5.0,
                        ),
                      ),
                    ),

                    // Left Cutout Punch
                    Positioned(
                      left: -punchRadius,
                      child: Container(
                        width: punchRadius * 2,
                        height: punchRadius * 2,
                        decoration: BoxDecoration(
                          color: punchBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                      ),
                    ),

                    // Right Cutout Punch
                    Positioned(
                      right: -punchRadius,
                      child: Container(
                        width: punchRadius * 2,
                        height: punchRadius * 2,
                        decoration: BoxDecoration(
                          color: punchBg,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14.0),

              // 5. Scannable QR Code & Barcode Stub
              Padding(
                padding: const EdgeInsets.fromLTRB(22.0, 0.0, 22.0, 22.0),
                child: Column(
                  children: [
                    // QR Container with clean white background for reliable scanner contrast
                    GestureDetector(
                      onTap: onQrTap,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: booking.qrData,
                          version: QrVersions.auto,
                          size: 145.0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF0F172A),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12.0),

                    // Booking Reference with Copy Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "PNR: ${booking.pnr}",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        InkWell(
                          borderRadius: BorderRadius.circular(6.0),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: booking.pnr));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Copied PNR ${booking.pnr} to clipboard!"),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.copy_rounded,
                              size: 14.0,
                              color: Constants.brandBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4.0),

                    Text(
                      "Scan at airline gate or hotel reception for fast check-in",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.0,
                        color: secondaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    Color valueColor,
    Color labelColor, {
    bool isHighlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 3.0),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 13.0 : 12.5,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
            color: valueColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
