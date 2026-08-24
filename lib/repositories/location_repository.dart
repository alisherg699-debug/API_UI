import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/locations_model.dart';

class LocationsRepository {
  Future<LocationsResponse> getLocations(int page) async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/location/?page=$page'),
    );

    if (response.statusCode == 200) {
      print("📥 GET response: ${response.body}");
      return LocationsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Maʼlumotlarni yuklashda xatolik yuz berdi');
    }
  }
}