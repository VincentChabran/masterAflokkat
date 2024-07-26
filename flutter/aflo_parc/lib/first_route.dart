import 'package:aflo_parc/second_route.dart';
import 'package:flutter/material.dart';

class FirstRoute extends StatelessWidget {
  FirstRoute({super.key});

  final List<String> entries = <String>['A', 'B', 'C', 'D'];
  final List<int> colorCodes = <int>[600, 500, 300, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('First Route'),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Container(
                  height: 50,
                  color: Colors.amber[colorCodes[index]],
                  child: Center(child: Text('Entry ${entries[index]}')),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute(lettre: entries[index])));
                },
              );
            }));
  }
}




// Meme chose avec GestureDetector pour le composant qui ne sont pas des listes

// import 'package:aflo_parc/second_route.dart';
// import 'package:flutter/material.dart';

// class FirstRoute extends StatelessWidget {
//   FirstRoute({super.key});

//   final List<String> entries = <String>['A', 'B', 'C', 'D'];
//   final List<int> colorCodes = <int>[600, 500, 300, 100];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('First Route'),
//         ),
//         body: ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: entries.length,
//             itemBuilder: (BuildContext context, int index) {
//               return GestureDetector(
//                 child: Container(
//                   height: 50,
//                   color: Colors.amber[colorCodes[index]],
//                   child: Center(child: Text('Entry ${entries[index]}')),
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                       context, MaterialPageRoute(builder: (context) => SecondRoute(lettre: (entries[index]))));
//                 },
//               );
//             }));
//   }
// }
