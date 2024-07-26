import 'package:flutter/material.dart';
import 'package:td_aflo_parc/pages/create_form_atraction.dart';
import 'package:td_aflo_parc/pages/home.dart';
import 'package:td_aflo_parc/pages/list_atraction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'attraction.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute('CREATE TABLE attraction(id INTEGER PRIMARY KEY, nom TEXT, description TEXT, parcId INTEGER)');
    },

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  runApp(const MaterialApp(
    title: "Afloparc",
    home: MyApp(),
  ));
}

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: const MyApp(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0; // L'index de la vue actuellement sélectionnée

  // Les vues entre lesquelles l'utilisateur peut naviguer
  final List<Widget> _views = [
    const Home(),
    const FormAttraction(),
    const ListAtraction(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Met à jour l'index sélectionné et donc la vue
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _views.elementAt(_selectedIndex), // Affiche la vue sélectionnée
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Vue 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
