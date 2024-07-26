// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:td_aflo_parc/main.dart';
import 'package:td_aflo_parc/models/attraction.dart';
import 'package:td_aflo_parc/service/atraction.service.dart';

class FormAttraction extends StatefulWidget {
  const FormAttraction({super.key, this.attractionInitiale, this.onItemTapped});

  final Attraction? attractionInitiale;
  final dynamic onItemTapped;

  @override
  State<FormAttraction> createState() => CreateFormAttractionState();
}

class CreateFormAttractionState extends State<FormAttraction> {
  late TextEditingController _controller;
  late TextEditingController _controllerDesc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.attractionInitiale?.nom ?? '');
    _controllerDesc = TextEditingController(text: widget.attractionInitiale?.description ?? '');
  }

  // Future<Attraction>? _futureAttraction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.attractionInitiale == null ? const Text('Create Data') : const Text('Update Data'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'attraction',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attractions),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _controllerDesc,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          Attraction? result;
                          // La logique de création ou de mise à jour
                          if (widget.attractionInitiale == null) {
                            // Logique de création
                            result = await AttractionService.createAttraction(_controller.text, _controllerDesc.text);
                            _formKey.currentState?.reset();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const MyApp()),
                            );
                          } else {
                            // Logique de mise à jour
                            result = await AttractionService.updateAttraction(
                                widget.attractionInitiale!.id, _controller.text, _controllerDesc.text);

                            // Navigue en arrière
                            Navigator.pop(context, result);
                          }

                          // Affichage du résultat ou gestion de l'état
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: widget.attractionInitiale == null
                                  ? Text('Attraction créée : ${result.id} ${result.nom}',
                                      style: const TextStyle(color: Colors.white))
                                  : Text('Attraction mise à jour : ${result.id} ${result.nom}',
                                      style: const TextStyle(color: Colors.white)),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur lors de l\'opération')),
                          );
                        }
                      }
                    },
                    child: Text(widget.attractionInitiale == null ? 'Créer' : 'Mettre à jour'),
                  ),
                ],
              ),
            ),
          ),
        ),
        // child: (_futureAttraction == null) ? buildForm() : buildFutureBuilder(),
      ),
    );
  }
}


  // Column buildForm() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       TextField(
  //         controller: _controller,
  //         decoration: const InputDecoration(hintText: 'Entrer le nom'),
  //       ),
  //       TextField(
  //         controller: _controllerDesc,
  //         decoration: const InputDecoration(hintText: 'Entrer la description'),
  //       ),
  //       ElevatedButton(
  //         onPressed: () {
  //           if (widget.attractionInitiale == null) {
  //             // Logique création
  //             setState(() {
  //               _futureAttraction = AttractionService.createAttraction(_controller.text, _controllerDesc.text);
  //             });
  //           } else {
  //             // Logique de mise à jour
  //             setState(() {
  //               _futureAttraction = AttractionService.updateAttraction(
  //                   widget.attractionInitiale!.id.toString(), _controller.text, _controllerDesc.text);
  //             });
  //           }
  //         },
  //         child: widget.attractionInitiale == null ? const Text('Create Data') : const Text('Update Data'),
  //       ),
  //     ],
  //   );
  // }

  // FutureBuilder<Attraction> buildFutureBuilder() {
  //   return FutureBuilder<Attraction>(
  //     future: _futureAttraction,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return Text(snapshot.data!.nom);
  //       } else if (snapshot.hasError) {
  //         return Text('${snapshot.error}');
  //       }

  //       return const CircularProgressIndicator();
  //     },
  //   );
  // }
