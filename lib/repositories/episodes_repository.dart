import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/episodes_model.dart';

class EpisodesRepository {
  Future<EpisodesResponse> getEpisodes(int page) async {
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/episode/?page=$page'),
    );

    if (response.statusCode == 200) {
      print("📥 GET response: ${response.body}");
      return EpisodesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Maʼlumotlarni yuklashda xatolik yuz berdi');
    }
  }
}