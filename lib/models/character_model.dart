class CharacterResponse {
  final Info info;
  final List<Character> results;

  CharacterResponse({required this.info, required this.results});
  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    return CharacterResponse(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
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
      count: json["count"] ?? 0,
      pages: json["pages"] ?? 0,
      next: json["next"] ?? "",
      prev: json["prev"] ?? "",
    );
  }
}

class Location {
  final String name;
  final String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(name: json['name'] ?? "", url: json['url'] ?? "");
  }
}

class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final Location origin;
  final Location location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      species: json["species"] ?? "",
      type: json["type"] ?? "",
      gender: json["gender"] ?? "",
      origin: json["origin"] != null
          ? Location.fromJson(json["origin"] as Map<String, dynamic>)
          : Location(name: "", url: ""),
      location: json["location"] != null
          ? Location.fromJson(json["location"] as Map<String, dynamic>)
          : Location(name: "", url: ""),
      image: json["image"] ?? "",
      episode:
          (json["episode"] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      url: json["url"] ?? "",
      created: json["created"] != null
          ? DateTime.parse(json["created"] as String)
          : DateTime.now(),
    );
  }
}
