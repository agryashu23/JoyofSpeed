import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapsService {
  static const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  Future<String> getPlaceDetailsFromPincode(String pincode) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?components=country:IN|postal_code:$pincode&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['results'][0]['formatted_address'] as String;
    } else {
      throw Exception('Failed to fetch place details');
    }
  }

  Future<String> getPlaceCity(String pincode) async {
    final placeDetails = await getPlaceDetailsFromPincode(pincode);
    final addressComponents = placeDetails.split(', ');
    String? city;

    for (final component in addressComponents) {
      if (component.contains('locality')) {
        city = component.split(' ')[0];
        break;
      }
    }

    return city!;
  }

  Future<String> getPlaceState(String pincode) async {
    final placeDetails = await getPlaceDetailsFromPincode(pincode);
    final addressComponents = placeDetails.split(', ');
    String? state;

    for (final component in addressComponents) {
      if (component.contains('administrative_area_level_1')) {
        state = component.split(' ')[0];
        break;
      }
    }

    return state!;
  }

  Future<String> getPlaceZone(String pincode) async {
    final placeDetails = await getPlaceDetailsFromPincode(pincode);
    final addressComponents = placeDetails.split(', ');
    String? zone;

    for (final component in addressComponents) {
      if (component.contains('zone')) {
        zone = component.split(' ')[0];
        break;
      }
    }

    return zone!;
  }

  Future<String> getPlaceMetro(String pincode) async {
    final placeDetails = await getPlaceDetailsFromPincode(pincode);
    final addressComponents = placeDetails.split(', ');
    String? metro;

    for (final component in addressComponents) {
      if (component.contains('metro')) {
        metro = component.split(' ')[0];
        break;
      }
    }

    return metro!;
  }

  Future<String> comparePincodes(String pincode1, String pincode2) async {
    final city1 = await getPlaceCity(pincode1);
    final city2 = await getPlaceCity(pincode2);

    if (city1 == city2) {
      return 'Same City';
    }

    final state1 = await getPlaceState(pincode1);
    final state2 = await getPlaceState(pincode2);

    if (state1 == state2) {
      return 'Different City, Same State';
    }

    final zone1 = await getPlaceZone(pincode1);
    final zone2 = await getPlaceZone(pincode2);

    if (zone1 == zone2) {
      return 'Different State, Same Zone';
    }

    final metro1 = await getPlaceMetro(pincode1);
    final metro2 = await getPlaceMetro(pincode2);

    if (metro1 == metro2) {
      return 'Different Zone, Same Metro';
    }

    return 'Different Metro';
  }
}
