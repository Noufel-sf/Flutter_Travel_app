import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/places.dart';
import 'package:flutter_travel_concept/widgets/horizontal_place_item.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';
import 'package:flutter_travel_concept/widgets/search_bar.dart';
import 'package:flutter_travel_concept/widgets/vertical_place_item.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, currentMode, _) {
              final isDark = currentMode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? "Switch to White Mode" : "Switch to Dark Mode",
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                ),
                onPressed: () {
                  themeModeNotifier.value =
                      isDark ? ThemeMode.light : ThemeMode.dark;
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
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Where are you \ngoing?",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomSearchBar(),
          ),
          buildHorizontalList(context),
          buildVerticalList(),
        ],
      ),
    );
  }

  Widget buildHorizontalList(BuildContext context) {
    return SizedBox(
      height: 260.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0),
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          final place = places.reversed.toList()[index];
          return HorizontalPlaceItem(place: place);
        },
      ),
    );
  }

  Widget buildVerticalList() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          final place = places[index];
          return VerticalPlaceItem(place: place);
        },
      ),
    );
  }
}
