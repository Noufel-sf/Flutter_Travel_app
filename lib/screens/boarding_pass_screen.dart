import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/haptics.dart';
import 'package:flutter_travel_concept/widgets/boarding_pass_card.dart';

class BoardingPassScreen extends StatefulWidget {
  final Booking booking;

  const BoardingPassScreen({
    super.key,
    required this.booking,
  });

  @override
  State<BoardingPassScreen> createState() => _BoardingPassScreenState();
}

class _BoardingPassScreenState extends State<BoardingPassScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _isSavedToWallet = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleSaveWallet() {
    Haptics.success();
    setState(() {
      _isSavedToWallet = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Pass for ${widget.booking.place.name} added to Digital Wallet!",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleShareTicket() {
    Haptics.medium();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Share Boarding Pass",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : Constants.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Share your e-ticket with travel companions or save a copy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Constants.brandBlueSoft,
                    child: Icon(Icons.link_rounded, color: Constants.brandBlue),
                  ),
                  title: const Text("Copy Verification Link",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(widget.booking.qrData,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Verification link copied!"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE0F2FE),
                    child: Icon(Icons.picture_as_pdf_rounded,
                        color: Color(0xFF0284C7)),
                  ),
                  title: const Text("Export as PDF Ticket",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text("High-resolution printable boarding pass"),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("PDF Ticket generated and ready to print!"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Constants.darkBG : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Constants.textDark,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Digital Boarding Pass",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : Constants.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: isDark ? Colors.white : Constants.textDark,
              size: 22,
            ),
            onPressed: _handleShareTicket,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          physics: const BouncingScrollPhysics(),
          child: SlideTransition(
            position: _slideAnim,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                children: [
                  // Boarding Pass Card
                  BoardingPassCard(
                    booking: widget.booking,
                    onQrTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Verified for ${widget.booking.guestName} • PNR ${widget.booking.pnr}"),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24.0),

                  // Save to Wallet Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52.0,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSavedToWallet
                            ? const Color(0xFF10B981)
                            : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        foregroundColor: _isSavedToWallet
                            ? Colors.white
                            : (isDark ? const Color(0xFF0F172A) : Colors.white),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: _isSavedToWallet ? null : _handleSaveWallet,
                      icon: Icon(
                        _isSavedToWallet
                            ? Icons.check_circle_rounded
                            : Icons.wallet_rounded,
                        size: 20,
                      ),
                      label: Text(
                        _isSavedToWallet ? "Added to Wallet" : "Add to Digital Wallet",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),

                  // Share Pass Secondary Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : Constants.textDark,
                        side: BorderSide(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: _handleShareTicket,
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: const Text(
                        "Share or Export Ticket",
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
