import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/locations_model.dart';

class LocationsRepository {
  Future<LocationsResponse> getLocations(int page) async {
    debugPrint(
      '------------------------------------------------------------------------',
    );
    debugPrint(
      '🚀 Request URL: https://rickandmortyapi.com/api/location/?page=$page',
    );
    debugPrint(
      '------------------------------------------------------------------------',
    );
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/location/?page=$page'),
    );

    if (response.statusCode == 200) {
      debugPrint('----------------------------------------------');
      debugPrint("✅ Ma'lumot keldi. Locations: $page");
      debugPrint('----------------------------------------------');
      return LocationsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Maʼlumotlarni yuklashda xatolik yuz berdi');
    }
  }
}
