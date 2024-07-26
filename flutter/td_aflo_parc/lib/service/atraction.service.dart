// ignore_for_file: avoid_print

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:td_aflo_parc/models/attraction.dart';

class AttractionService {
  static Future<Attraction> createAttraction(String nom, String description) async {
    const parcId = 1;

    print("in db insert");

    final db = await openDatabase(
      join(await getDatabasesPath(), 'attraction.db'),
    );

    final id = await db.insert(
      'attraction',
      {"nom": nom, "description": description, "parcId": parcId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("data inserted");

    return Attraction(id: id, parcId: parcId, nom: nom, description: description);
  }

  static Future<List<Attraction>> getAllAtraction() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'attraction.db'),
    );

    final List<Map<String, Object?>> albumsMap = await db.query('attraction');

    print("albums length = ${albumsMap.length}");

    return [
      for (final {
            'id': id as int,
            'parcId': parcId as int,
            'nom': nom as String,
            'description': description as String,
          } in albumsMap)
        Attraction(id: id, nom: nom, description: description, parcId: parcId),
    ];
  }

  static Future<Attraction> updateAttraction(int id, String nom, String description) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'attraction.db'),
    );

    await db.update(
      'attraction', // Assurez-vous que le nom de la table est correct
      {'nom': nom, 'description': description},
      where: 'id = ?',
      whereArgs: [id],
    );

    return Attraction(id: id, nom: nom, description: description, parcId: 1); // Retourne le nombre de lignes affectées
  }

  static Future<String> deleteAttraction(String id) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'attraction.db'),
    );

    await db.delete(
      'attraction', // Assurez-vous que le nom de la table est correct
      where: 'id = ?',
      whereArgs: [id],
    );

    return "Attration $id";
  }

  // Requete http

  // static Future<Attraction> createAttraction(String nom, String description) async {
  //   final response = await http.post(Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions'),
  //       headers: <String, String>{"Content-Type": "application/json; charset=UTF-8"},
  //       body: jsonEncode(<String, dynamic>{"nom": nom, "description": description, "parc_id": 1}));

  //   if (response.statusCode == 201) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return Attraction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to create attraction');
  //   }
  // }

  // static Future<List<Attraction>> getAllAtraction() async {
  //   final response = await http.get(Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions'));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return Attraction.parseAttractions(response.body);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load attraction');
  //   }
  // }

  // static Future<Attraction> updateAttraction(String id, String nom, String description) async {
  //   final response = await http.put(Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions/$id'),
  //       headers: <String, String>{"Content-Type": "application/json; charset=UTF-8"},
  //       body: jsonEncode(<String, dynamic>{"nom": nom, "description": description, "parc_id": 1}));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return Attraction.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to update attraction');
  //   }
  // }

  // static Future<String> deleteAttraction(String id) async {
  //   final response = await http.delete(
  //       Uri.parse('https://my-json-server.typicode.com/Ludovic2b/afloparc/attractions/$id'),
  //       headers: <String, String>{"Content-Type": "application/json; charset=UTF-8"},
  //       body: jsonEncode(<String, dynamic>{}));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return "Suppression réussie";
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to delete attraction');
  //   }
  // }
}
