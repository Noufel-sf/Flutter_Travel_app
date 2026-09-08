import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/place.dart';

import '../screens/details.dart';

class HorizontalPlaceItem extends StatelessWidget {
  final Place place;

  const HorizontalPlaceItem({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final heroTag = "horizontal_place_${place.id}";

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 250.0,
          width: 140.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Hero(
                  tag: heroTag,
                  child: Image.asset(
                    place.img,
                    height: 165.0,
                    width: 140.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 7.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  place.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 3.0),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  place.location,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                    color: Colors.blueGrey[300],
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Details(place: place, heroTag: heroTag);
              },
            ),
          );
        },
      ),
    );
  }
}
