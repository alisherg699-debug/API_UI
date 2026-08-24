class EpisodesResponse {
  final Info info;
  final List<Episodes>results;

  EpisodesResponse({
    required this.info,
    required this.results,
  });
  factory EpisodesResponse.fromJson(Map<String, dynamic> json) {
    return EpisodesResponse(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Episodes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Info {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  Info({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json["count"] as int,
      pages: json["pages"] as int,
      next: json["next"] as String?,
      prev: json["prev"] as String?,
    );
  }
}

class Episodes {
  final int id;
  final String name;
  final String air_date;
  final String episode;
  final List<String> characters;
  final String url;
  final DateTime created;

  Episodes({
    required this.id,
    required this.name,
    required this.air_date,
    required this.episode,
    required this.characters,
    required this.url,
    required this.created,
  });

  factory Episodes.fromJson(Map<String, dynamic> json) {
    return Episodes(
      id: json["id"] as int,
      name: json["name"] as String,
      air_date: json["air_date"] as String,
      episode: json["episode"] as String,
      characters: (json["characters"] as List<dynamic>).map((e) => e as String).toList(),
      url: json["url"] as String,
      created: DateTime.parse(json["created"] as String),
    );
  }
}