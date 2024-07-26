// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:td_aflo_parc/models/attraction.dart';
import 'package:td_aflo_parc/pages/create_form_atraction.dart';
import 'package:td_aflo_parc/service/atraction.service.dart';

class DetailAtraction extends StatefulWidget {
  DetailAtraction({
    super.key,
    required this.attraction,
  });

  Attraction attraction;
  bool isNotUpdated = true;

  @override
  State<DetailAtraction> createState() => DetailAtractionState();
}

class DetailAtractionState extends State<DetailAtraction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail attraction ID : ${widget.attraction.id}'),
      ),
      //bottomNavigationBar: BottomBar(selectedIndex: 2),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              PopScope(
                  canPop: widget.isNotUpdated,
                  child: const Text("Hello"),
                  onPopInvoked: (bool didPop) {
                    // Insérez ici la logique que vous souhaitez exécuter avant que l'écran ne soit fermé
                    if (didPop) {
                      return;
                    }
                    Navigator.pop(context, 'dataUpdated'); // Remplacez 'dataUpdated' par le résultat souhaité

                    //tourne true pour permettre de quitter l'écran, false pour empêcher
                  }),
              ListTile(
                title: Text(
                  widget.attraction.nom,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text('ID du parc: ${widget.attraction.parcId}'),
                leading: Icon(
                  Icons.attractions,
                  color: Theme.of(context).primaryColor,
                ),
                // Update button
                trailing: IconButton(
                  icon: Icon(Icons.create, color: Theme.of(context).primaryColor),
                  onPressed: () async {
                    final attractionUpdated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormAttraction(
                          attractionInitiale: widget.attraction,
                        ),
                      ),
                    );

                    setState(() {
                      if (attractionUpdated != null) widget.attraction = attractionUpdated;
                      widget.isNotUpdated = false;
                    });
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text(
                      "Description :",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.attraction.description,
                      style: const TextStyle(fontSize: 13),
                    )
                  ]),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext contextDialog) {
                          return AlertDialog(
                            title: const Text('Confirmer la suppression'),
                            content: const Text('Êtes-vous sûr de vouloir supprimer cet élément ?'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Annuler'),
                                onPressed: () {
                                  Navigator.of(contextDialog).pop(); // Ferme le dialogue sans rien faire
                                },
                              ),
                              TextButton(
                                child: const Text('Supprimer'),
                                onPressed: () async {
                                  Navigator.of(contextDialog).pop(); // Ferme le dialogue de confirmation

                                  try {
                                    await AttractionService.deleteAttraction(widget.attraction.id.toString());

                                    Navigator.pop(context, 'deleteData');

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Suppression réussie")),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      //)
    );
  }
}
