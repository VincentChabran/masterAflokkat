import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Album {
  final int? userId;
  final int id;
  final String title;

  const Album({
    this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
      } =>
        Album(
          id: id,
          title: title,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  Map<String, Object?> toMap() {
    return {
      'title': title,
    };
  }

  static List<Album> parseAlbums(String responseBody) {
    final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

    return parsed.map<Album>((json) => Album.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'Album{id: $id, title: $title}';
  }

  Future<void> insertAlbum() async {
    // Get a reference to the database.

    print("in db insert");
    final db = await openDatabase(
      join(await getDatabasesPath(), 'album.db'),
    );

    // Insert the Album into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'album',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("data inserted");
  }

  static Future<List<Album>> getAll() async {
    // Get a reference to the database.
    final db = await openDatabase(
      join(await getDatabasesPath(), 'album.db'),
    );

    // Query the table for all the dogs.
    final List<Map<String, Object?>> albumsMap = await db.query('album');

    print("albums = " + albumsMap.length.toString());

    // Convert the list of each albums's fields into a list of `Album` objects.
    return [
      for (final {
            'id': id as int,
            'title': title as String,
          } in albumsMap)
        Album(id: id, title: title),
    ];
  }
}
