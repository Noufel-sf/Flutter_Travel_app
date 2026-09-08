import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/models/place.dart';

void main() {
  group('Place Model Tests', () {
    test('fromJson creates a valid Place instance', () {
      final json = {
        'id': '10',
        'name': 'Alpine Lodge',
        'img': 'assets/1.jpeg',
        'images': ['assets/1.jpeg', 'assets/2.jpeg'],
        'price': r'$250/night',
        'location': 'Zermatt, Switzerland',
        'rating': 4.9,
        'details': 'Beautiful mountain views.',
      };

      final place = Place.fromJson(json);

      expect(place.id, '10');
      expect(place.name, 'Alpine Lodge');
      expect(place.images.length, 2);
      expect(place.rating, 4.9);
    });

    test('toJson produces correct map structure', () {
      const place = Place(
        id: '20',
        name: 'Ocean Villa',
        img: 'assets/2.jpeg',
        price: r'$300/night',
        location: 'Bali, Indonesia',
        details: 'Private beach access.',
      );

      final json = place.toJson();

      expect(json['id'], '20');
      expect(json['name'], 'Ocean Villa');
      expect(json['location'], 'Bali, Indonesia');
    });

    test('copyWith updates properties while keeping immutability', () {
      const original = Place(
        id: '1',
        name: 'Original Name',
        img: 'assets/1.jpeg',
        price: r'$100/night',
        location: 'City',
        details: 'Details',
      );

      final modified = original.copyWith(name: 'Updated Name', rating: 5.0);

      expect(original.name, 'Original Name');
      expect(modified.name, 'Updated Name');
      expect(modified.rating, 5.0);
      expect(modified.id, original.id);
    });
  });
}
