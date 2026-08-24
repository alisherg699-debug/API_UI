class LocationsResponse {
  final Info info;
  final List<Locations>results;

  LocationsResponse({
    required this.info,
    required this.results,
  });
  factory LocationsResponse.fromJson(Map<String, dynamic> json) {
    return LocationsResponse(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Locations.fromJson(e as Map<String, dynamic>))
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

class Locations {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;
  final String url;
  final DateTime created;

  Locations({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
});

  factory Locations.fromJson(Map<String, dynamic> json) {
    return Locations(
      id: json["id"] as int,
      name: json["name"] as String,
      type: json["type"] as String,
      dimension: json["dimension"] as String,
      residents: (json["residents"] as List<dynamic>).map((e) => e as String).toList(),
      url: json["url"] as String,
      created: DateTime.parse(json["created"] as String),
    );
  }
}





















