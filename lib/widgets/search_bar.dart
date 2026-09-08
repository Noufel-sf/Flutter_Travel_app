import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController _searchControl = TextEditingController();

  CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF263238) : Colors.blueGrey[50],
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: TextField(
        style: TextStyle(
          fontSize: 15.0,
          color: isDark ? Colors.white70 : Colors.blueGrey[800],
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: isDark ? Colors.transparent : Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDark ? Colors.transparent : Colors.white,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          hintText: "E.g: New York, United States",
          prefixIcon: Icon(
            Icons.location_on,
            color: isDark ? Colors.white60 : Colors.blueGrey[300],
          ),
          hintStyle: TextStyle(
            fontSize: 15.0,
            color: isDark ? Colors.white38 : Colors.blueGrey[300],
          ),
        ),
        maxLines: 1,
        controller: _searchControl,
      ),
    );
  }
}
