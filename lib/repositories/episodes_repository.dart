import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/episodes_model.dart';

class EpisodesRepository {
  Future<EpisodesResponse> getEpisodes(int page) async {
    debugPrint(
      '------------------------------------------------------------------------',
    );
    debugPrint(
      '🚀 Request URL: https://rickandmortyapi.com/api/episode/?page=$page',
    );
    debugPrint(
      '------------------------------------------------------------------------',
    );
    final response = await http.get(
      Uri.parse('https://rickandmortyapi.com/api/episode/?page=$page'),
    );

    if (response.statusCode == 200) {
      debugPrint('----------------------------------------------');
      debugPrint("✅ Ma'lumot keldi. Episodes: $page");
      debugPrint('----------------------------------------------');
      return EpisodesResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Maʼlumotlarni yuklashda xatolik yuz berdi');
    }
  }
}
