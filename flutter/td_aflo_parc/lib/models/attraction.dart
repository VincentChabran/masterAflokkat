import 'dart:convert';

class Attraction {
  final int id;
  final int parcId;
  final String nom;
  final String description;

  const Attraction({
    required this.id,
    required this.parcId,
    required this.nom,
    required this.description,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'parc_id': int parcId,
        'nom': String nom,
        'description': String description,
      } =>
        Attraction(parcId: parcId, id: id, nom: nom, description: description),
      _ => throw const FormatException('Failed to load Attraction.'),
    };
  }

  static List<Attraction> parseAttractions(String responseBody) {
    final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Attraction>((json) => Attraction.fromJson(json)).toList();
  }

  Map<String, Object?> toMap() {
    return {
      'parcId': parcId,
      'nom': nom,
      'description': description,
    };
  }
}
