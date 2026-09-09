import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/models/review.dart';
import 'package:flutter_travel_concept/services/reviews_service.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/places.dart';

class WriteReviewDialog extends StatefulWidget {
  final Place? defaultPlace;

  const WriteReviewDialog({super.key, this.defaultPlace});

  static Future<void> show(BuildContext context, {Place? defaultPlace}) {
    return showDialog(
      context: context,
      builder: (_) => WriteReviewDialog(defaultPlace: defaultPlace),
    );
  }

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: "Noufel Traveler");
  final _commentController = TextEditingController();

  late Place _selectedPlace;
  double _rating = 5.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedPlace = widget.defaultPlace ?? places.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    final review = Review(
      id: "rev_${DateTime.now().millisecondsSinceEpoch}",
      placeId: _selectedPlace.id,
      placeName: _selectedPlace.name,
      userName: _nameController.text.trim(),
      rating: _rating,
      comment: _commentController.text.trim(),
      helpfulCount: 0,
      createdAt: DateTime.now(),
    );

    await reviewsService.addReview(review);

    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Thank you! Your review has been shared with travelers."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Constants.brandBlueSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.rate_review_rounded,
              color: Constants.brandBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Share Travel Tip",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18.0,
              letterSpacing: -0.3,
              color: isDark ? Colors.white : Constants.textDark,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Destination Dropdown
              Text(
                "Destination",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2430) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Place>(
                    isExpanded: true,
                    value: _selectedPlace,
                    items: places.map((p) {
                      return DropdownMenuItem<Place>(
                        value: p,
                        child: Text(
                          p.name,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Constants.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (p) {
                      if (p != null) {
                        setState(() => _selectedPlace = p);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Rating Stars
              Text(
                "Your Rating",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2430) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2E384D) : const Color(0xFFE8EEF8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        starIndex <= _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Constants.accentGold,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() => _rating = starIndex.toDouble());
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14.0),

              // Name Field
              Text(
                "Your Name",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Constants.brandBlue),
                  hintText: "Enter your name",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E2430) : const Color(0xFFF8FAFC),
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
                    borderSide: const BorderSide(color: Constants.brandBlue, width: 1.5),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14.0),

              // Review Text Field
              Text(
                "Review / Recommendations",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Constants.textDark,
                ),
              ),
              const SizedBox(height: 6.0),
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      "Share tips (best time to visit, food suggestions, hidden spots...)",
                  hintStyle: TextStyle(
                    fontSize: 12.0,
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  ),
                  contentPadding: const EdgeInsets.all(14.0),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E2430) : const Color(0xFFF8FAFC),
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
                    borderSide: const BorderSide(color: Constants.brandBlue, width: 1.5),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().length < 5) {
                    return "Please write at least 5 characters";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: isDark ? const Color(0xFF94A3B8) : Constants.textLight,
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.brandBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          ),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text("Post Review", style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
