// ignore_for_file: use_build_context_synchronously

import 'package:examen/main.dart';
import 'package:examen/models/task.model.dart';
import 'package:examen/service/task.service.dart';
import 'package:flutter/material.dart';

class FormTask extends StatefulWidget {
  const FormTask({super.key, this.taskInitiale});

  final Task? taskInitiale;

  @override
  State<FormTask> createState() => FormTaskState();
}

class FormTaskState extends State<FormTask> {
  late TextEditingController _nomController;
  late TextEditingController _descriptionController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.taskInitiale?.nom ?? '');
    _descriptionController = TextEditingController(text: widget.taskInitiale?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.taskInitiale == null ? const Text('Créer une tâche') : const Text('Mettre à jour la tâche'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la tache',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.auto_awesome),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer un nom';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description de la tache',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer une description';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(widget.taskInitiale == null ? 'Créer la tache' : 'Mettre à jour la tache'),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    try {
                      Task? result;

                      // La logique de création (if) ou de mise à jour (else)
                      if (widget.taskInitiale == null) {
                        result = await TaskService.createTask(_nomController.text, _descriptionController.text);
                        _formKey.currentState?.reset();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => App(selectedIndex: 2)),
                        );
                      } else {
                        result = await TaskService.updateTask(widget.taskInitiale!.id, _nomController.text,
                            _descriptionController.text, widget.taskInitiale!.isCompleted);

                        Navigator.pop(context, result);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              '${widget.taskInitiale == null ? 'Attraction créée : ' : 'Attraction mise à jour : '}${result.nom}',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erreur lors de l\'opération')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
