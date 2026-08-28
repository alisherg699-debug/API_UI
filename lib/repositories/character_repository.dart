import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class CharacterRepository {
  Future<CharacterResponse> getCharacters(int page) async {
    debugPrint('------------------------------------------------------------------------');
    debugPrint('🚀 Request URL: https://rickandmortyapi.com/api/character/?page=$page');
    debugPrint('------------------------------------------------------------------------');
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/?page=$page'),
    );

    if (response.statusCode == 200) {
      debugPrint('----------------------------------------------');
      debugPrint("✅ Ma'lumot keldi. Sahifa: $page");
      debugPrint('----------------------------------------------');

      return CharacterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Server xatosi: ${response.statusCode}');
    }
  }
}