import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/places.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';

class Details extends StatelessWidget {
  const Details({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
          const SizedBox(height: 10.0),
          buildSlider(),
          const SizedBox(height: 20),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${places[0]["name"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.blueGrey[300],
                  ),
                  const SizedBox(width: 3),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${places[0]["location"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.blueGrey[300],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${places[0]["price"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${places[0]["details"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.airplanemode_active,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget buildSlider() {
    return SizedBox(
      height: 250.0,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        primary: false,
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          Map place = places[index];

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Builder(
                builder: (context) => Image.asset(
                  "${place["img"]}",
                  height: 250.0,
                  width: MediaQuery.of(context).size.width - 40.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
