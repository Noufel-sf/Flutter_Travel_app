import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/services/booking_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:go_router/go_router.dart';

class BookingBottomSheet extends StatefulWidget {
  final Place place;

  const BookingBottomSheet({super.key, required this.place});

  static Future<void> show(BuildContext context, Place place) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingBottomSheet(place: place),
    );
  }

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: "Noufel Traveler");
  late DateTimeRange _dateRange;
  int _guests = 2;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: now.add(const Duration(days: 1)),
      end: now.add(const Duration(days: 4)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  int get _nights {
    final days = _dateRange.duration.inDays;
    return days > 0 ? days : 1;
  }

  double get _basePrice => widget.place.pricePerNight * _nights;
  double get _taxes => _basePrice * 0.10;
  double get _totalPrice => _basePrice + _taxes;

  String _formatDate(DateTime d) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${months[d.month - 1]} ${d.day}, ${d.year}";
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final booking = Booking(
      id: "TRV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
      place: widget.place,
      checkIn: _dateRange.start,
      checkOut: _dateRange.end,
      guests: _guests,
      totalPrice: _totalPrice,
      guestName: _nameController.text.trim(),
      createdAt: DateTime.now(),
    );

    await bookingService.addBooking(booking);

    Navigator.pop(context); // Close bottom sheet

    _showConfirmationDialog(booking);
  }

  void _showConfirmationDialog(Booking booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.0),
          ),
          contentPadding: const EdgeInsets.all(24.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 56.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                "Booking Confirmed!",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                "Reference #${booking.id}",
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2430)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                  ),
                ),
                child: Column(
                  children: [
                    _dialogRow("Destination", booking.place.name),
                    const Divider(height: 14),
                    _dialogRow("Dates",
                        "${_formatDate(booking.checkIn)} - ${_formatDate(booking.checkOut)}"),
                    const Divider(height: 14),
                    _dialogRow("Duration", "${booking.nights} nights"),
                    const Divider(height: 14),
                    _dialogRow("Guests", "${booking.guests} Guests"),
                    const Divider(height: 14),
                    _dialogRow("Guest Name", booking.guestName),
                    const Divider(height: 14),
                    _dialogRow(
                      "Total Paid",
                      "\$${booking.totalPrice.toStringAsFixed(2)}",
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.brandBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    context.push('/boarding-pass/${booking.id}', extra: booking);
                  },
                  icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                  label: const Text(
                    "View Digital Pass & QR Code",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    "Back to Destination",
                    style: TextStyle(
                      color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dialogRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.blueGrey[300],
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? Constants.brandBlue : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181F2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      padding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 20.0 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  height: 4.0,
                  width: 38.0,
                  margin: const EdgeInsets.only(bottom: 18.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),

              // Title and destination brief
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      widget.place.img,
                      height: 56.0,
                      width: 56.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Book Your Stay",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: isDark ? Colors.white : Constants.textDark,
                          ),
                        ),
                        Text(
                          widget.place.name,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.place.price,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0,
                      color: Constants.brandBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Date Range Picker Card
              Text(
                "Travel Dates",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 8.0),
              InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E2430)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Constants.brandBlueSoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: Constants.brandBlue,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_formatDate(_dateRange.start)} → ${_formatDate(_dateRange.end)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: isDark ? Colors.white : Constants.textDark,
                              ),
                            ),
                            Text(
                              "$_nights night${_nights > 1 ? 's' : ''}",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDateRange,
                        style: TextButton.styleFrom(
                          foregroundColor: Constants.brandBlue,
                        ),
                        child: const Text(
                          "Change",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Guests Stepper
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Guests",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                          color: isDark ? Colors.white : Constants.textDark,
                        ),
                      ),
                      Text(
                        "Adults & Children",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                          foregroundColor: isDark ? Colors.white : Constants.textDark,
                        ),
                        icon: const Icon(Icons.remove_rounded, size: 18),
                        onPressed: _guests > 1
                            ? () => setState(() => _guests--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          "$_guests",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Constants.textDark,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Constants.brandBlueSoft,
                          foregroundColor: Constants.brandBlue,
                        ),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        onPressed: _guests < 10
                            ? () => setState(() => _guests++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Guest Name Input Field
              Text(
                "Primary Guest Name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Constants.brandBlue),
                  hintText: "Enter full name",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF1E2430)
                      : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: BorderSide(
                      color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(
                      color: Constants.brandBlue,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter guest name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              // Price Summary
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2430)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                  ),
                ),
                child: Column(
                  children: [
                    _priceRow(
                      "\$${widget.place.pricePerNight.toStringAsFixed(0)} × $_nights night${_nights > 1 ? 's' : ''}",
                      "\$${_basePrice.toStringAsFixed(2)}",
                    ),
                    const SizedBox(height: 8.0),
                    _priceRow("Taxes & service fees (10%)",
                        "\$${_taxes.toStringAsFixed(2)}"),
                    Divider(
                      height: 20.0,
                      color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Due",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.0,
                            color: isDark ? Colors.white : Constants.textDark,
                          ),
                        ),
                        Text(
                          "\$${_totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 19.0,
                            color: Constants.brandBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.brandBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitBooking,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Confirm & Reserve",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.blueGrey[300],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
