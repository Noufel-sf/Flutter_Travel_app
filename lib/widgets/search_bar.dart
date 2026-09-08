import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF263238) : Colors.blueGrey[50],
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 15.0,
          color: isDark ? Colors.white70 : Colors.blueGrey[800],
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: isDark ? Colors.transparent : Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.transparent : Colors.white,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: "Search destinations, cities...",
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? Colors.white60 : Colors.blueGrey[300],
          ),
          suffixIcon: (controller != null && controller!.text.isNotEmpty)
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                    color: isDark ? Colors.white60 : Colors.blueGrey[300],
                  ),
                  onPressed: onClear,
                )
              : null,
          hintStyle: TextStyle(
            fontSize: 15.0,
            color: isDark ? Colors.white38 : Colors.blueGrey[300],
          ),
        ),
        maxLines: 1,
      ),
    );
  }
}
