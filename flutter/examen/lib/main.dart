// ignore_for_file: must_be_immutable

import 'package:examen/pages/form_task.dart';
import 'package:examen/pages/home.dart';
import 'package:examen/pages/list_task.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  openDatabase(
    join(await getDatabasesPath(), 'examen.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE task(id INTEGER PRIMARY KEY, nom TEXT NOT NULL, description TEXT NOT NULL, isCompleted INTEGER NOT NULL)');
    },
    version: 1,
  );

  runApp(MaterialApp(
    title: "Examen Flutter Aflokkat",
    home: App(selectedIndex: 0),
  ));
}

class App extends StatefulWidget {
  App({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Widget> _views = [
    const Home(),
    const FormTask(),
    const ListTask(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _views.elementAt(widget.selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue,
          currentIndex: widget.selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Créer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Liste',
            ),
          ],
        ));
  }
}
