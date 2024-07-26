import 'dart:convert';

// import 'package:afloparc/album.dart';
// import 'package:afloparc/first_route.dart';
// import 'package:afloparc/form_demo.dart';
// import 'package:afloparc/tabview.dart';
// import 'package:afloparc/vincent.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

import 'package:aflo_parc/album.dart';
import 'package:aflo_parc/form_demo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//
void main() async {
  // Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'album.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute('CREATE TABLE album(id INTEGER PRIMARY KEY, title TEXT)');
    },
    onUpgrade: (db, oldVersion, newVersion) {
      return db.execute('CREATE TABLE album(id INTEGER PRIMARY KEY, title TEXT)');
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 6,
  );

  runApp(
    MaterialApp(title: 'Afloparc', home: MainApp()),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  var chaine = "Begin";
  var chaine2 = "Middle";
  late Future<Album> futureAlbum;
  late Future<List<Album>> futuresAlbum;

  Future<Album> fetchAlbum() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/3'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<Album>> fetchAllAlbum() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return Album.parseAlbums(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load all album');
    }
  }

  @override
  void initState() {
    super.initState();
    //futureAlbum = fetchAlbum();
    //futuresAlbum = fetchAllAlbum();
    futuresAlbum = Album.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Album>>(
      future: futuresAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(children: [
            const Text("Hello world"),
            Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        child: ListTile(title: Text(snapshot.data![index].title), tileColor: Colors.blueAccent),
                        padding: EdgeInsets.all(8.0),
                      );
                    })),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FormDemo()));
                },
                child: Text("Ajouter un album"))
          ]);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    ));
  }
}








// import 'dart:convert';
// import 'package:aflo_parc/album.dart';
// import 'package:aflo_parc/form_demo.dart';
// // import 'package:aflo_parc/tabview.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MaterialApp(
//     title: "Afloparc",
//     home: FormDemo(),
//   ));
// }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainApp();
// }

// class _MainApp extends State<MainApp> {
//   var chaine = "Begin";
//   var chaine2 = "Middle";
//   // late Future<Album> futureAlbum;
//   late Future<List<Album>> futuresAlbum;

//   Future<Album> fetchAlbum() async {
//     final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/3'));

//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }

//   Future<List<Album>> fetchAllAlbum() async {
//     final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/'));

//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       return Album.parseAlbums(response.body);
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // futureAlbum = fetchAlbum();
//     futuresAlbum = fetchAllAlbum();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder<List<Album>>(
//       future: futuresAlbum,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//             itemCount: snapshot.data!.length,
//             itemBuilder: (BuildContext context, int index) {
//               return ListTile(title: Text(snapshot.data![index].title)
//                   // Row(children: [Text(snapshot.data![index].title), Text(snapshot.data![index].userId.toString())]),
//                   );
//             },
//           );
//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }

//         // By default, show a loading spinner.
//         return const CircularProgressIndicator();
//       },
//     ));
//   }
// }












// import 'dart:convert';

// import 'package:aflo_parc/album.dart';
// import 'package:flutter/material.dart';
// import "package:http/http.dart" as http;

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   String chaine = "Begin";

//   Future<Album> fetchAlbum() async {
//     final responce = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

//     if (responce.statusCode == 200) {
//       return Album.fromJson(jsonDecode(responce.body) as Map<String, dynamic>);
//     } else {
//       throw Exception("Failed to load data");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SizedBox.expand(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 60,
//               ),
//               Text(chaine),
//               const Spacer(),
//               const Text("Middle"),
//               const Spacer(),
//               const Text("End"),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       chaine = "After click";
//                     });
//                   },
//                   child: const Text("Cliquez-moi")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Defaut

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.telegram),
//                   Container(child: const Text("CALL"))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
