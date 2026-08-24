import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class CharacterRepository {
  Future<CharacterResponse> getCharacters(int page) async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/character/?page=$page'),
    );

    if (response.statusCode == 200) {
      print("📥 GET response: ${response.body}");
      return CharacterResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Maʼlumotlarni yuklashda xatolik yuz berdi');
    }
  }
}