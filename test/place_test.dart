import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/models/place.dart';

void main() {
  group('Place Model Tests', () {
    test('fromJson creates a valid Place instance with category', () {
      final json = {
        'id': '10',
        'name': 'Alpine Lodge',
        'img': 'assets/1.jpeg',
        'images': ['assets/1.jpeg', 'assets/2.jpeg'],
        'price': r'$250/night',
        'location': 'Zermatt, Switzerland',
        'category': 'Hotels',
        'rating': 4.9,
        'details': 'Beautiful mountain views.',
      };

      final place = Place.fromJson(json);

      expect(place.id, '10');
      expect(place.name, 'Alpine Lodge');
      expect(place.category, 'Hotels');
      expect(place.images.length, 2);
      expect(place.rating, 4.9);
    });

    test('toJson produces correct map structure including category', () {
      const place = Place(
        id: '20',
        name: 'Ocean Villa',
        img: 'assets/2.jpeg',
        price: r'$300/night',
        location: 'Bali, Indonesia',
        category: 'Beaches',
        details: 'Private beach access.',
      );

      final json = place.toJson();

      expect(json['id'], '20');
      expect(json['name'], 'Ocean Villa');
      expect(json['category'], 'Beaches');
      expect(json['location'], 'Bali, Indonesia');
    });

    test('copyWith updates properties while keeping immutability', () {
      const original = Place(
        id: '1',
        name: 'Original Name',
        img: 'assets/1.jpeg',
        price: r'$100/night',
        location: 'City',
        category: 'Hotels',
        details: 'Details',
      );

      final modified = original.copyWith(
        name: 'Updated Name',
        category: 'Resorts',
        rating: 5.0,
      );

      expect(original.name, 'Original Name');
      expect(original.category, 'Hotels');
      expect(modified.name, 'Updated Name');
      expect(modified.category, 'Resorts');
      expect(modified.rating, 5.0);
      expect(modified.id, original.id);
    });
  });
}
