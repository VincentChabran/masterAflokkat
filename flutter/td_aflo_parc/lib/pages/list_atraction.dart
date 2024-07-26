import 'package:flutter/material.dart';
import 'package:td_aflo_parc/models/attraction.dart';
import 'package:td_aflo_parc/views/detail_atraction.dart';
import 'package:td_aflo_parc/service/atraction.service.dart';

class ListAtraction extends StatefulWidget {
  const ListAtraction({super.key});

  @override
  State<ListAtraction> createState() => _ListAtraction();
}

class _ListAtraction extends State<ListAtraction> {
  late Future<List<Attraction>> futureAtractions;

  @override
  void initState() {
    super.initState();
    futureAtractions = AttractionService.getAllAtraction();
  }

  final List<int> colorCodes = <int>[600, 500, 300, 200, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste attractions')),
      body: FutureBuilder(
        future: futureAtractions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final attraction = snapshot.data![index];
                return Dismissible(
                  key: Key(
                      '${attraction.id} + $index'), // Assurez-vous que la clé est unique pour chaque élément de la liste
                  direction: DismissDirection.endToStart, // Swipe de droite à gauche
                  onDismissed: (direction) {
                    setState(() {
                      // Supposons que `snapshot.data` est votre liste d'éléments
                      // et que vous supprimez l'élément à `index`
                      snapshot.data!.removeAt(index);
                      // Après avoir supprimé l'élément de votre liste,
                      // rafraîchissez l'état pour refléter le changement dans l'UI
                    });
                    // Effectuez également la suppression dans votre backend ou votre base de données ici
                    AttractionService.deleteAttraction(attraction.id.toString());
                  },

                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      onTap: () async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailAtraction(
                                      attraction: attraction,
                                    )));
                        if (result == 'dataUpdated' || result == "deleteData") {
                          setState(() {
                            futureAtractions = AttractionService.getAllAtraction();
                          });
                        }
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          children: [
                            Icon(Icons.attractions, color: Colors.grey[700], size: 32),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nom : ${attraction.nom}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Id : ${attraction.id}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

      // Card(
                    //     elevation: 5,
                    //     child: ListTile(
                    //       title:
                    //           // Text(snapshot.data![index].nom)
                    //           Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text("Nom : ${snapshot.data![index].nom}"),
                    //           Text('id : ${snapshot.data![index].id.toString()}')
                    //         ],
                    //       ),
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => DetailAtraction(
                    //                       attraction: snapshot.data![index],
                    //                     )));
                    //       },
                    //     ));