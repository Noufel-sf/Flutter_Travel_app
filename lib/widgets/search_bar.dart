import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/util/const.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasText = controller != null && controller!.text.isNotEmpty;

    return Container(
      height: 52.0,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Constants.textDark,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
          border: InputBorder.none,
          hintText: "Where do you wanna go...",
          hintStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 22.0,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasText)
                IconButton(
                  icon: const Icon(Icons.cancel_rounded, size: 18),
                  color: isDark ? Colors.white60 : Colors.blueGrey[400],
                  onPressed: onClear,
                ),
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: IconButton(
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                  tooltip: "Filter options",
                  onPressed: onFilterTap,
                ),
              ),
            ],
          ),
        ),
        maxLines: 1,
      ),
    );
  }
}
