import 'package:examen/models/task.model.dart';
import 'package:examen/pages/form_task.dart';
import 'package:examen/service/task.service.dart';
import 'package:examen/widget/task_card/task_card.dart';
import 'package:flutter/material.dart';

class ListTask extends StatefulWidget {
  const ListTask({super.key});

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = TaskService.getAllTask();
  }

  updateIsCompletedTask(Task task) {
    TaskService.updateIsCompletedFromTask(task.id, task.isCompleted);
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des tâches')),
      body: FutureBuilder(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final task = snapshot.data![index];

                return TaskCardItem(
                  task: task,
                  onUpdateTask: () async {
                    final taskUpdated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormTask(
                          taskInitiale: task,
                        ),
                      ),
                    );

                    setState(() {
                      if (taskUpdated != null) snapshot.data![index] = taskUpdated;
                    });
                  },
                  onDismissed: (task) {
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });
                    TaskService.deleteTask(task.id.toString());
                  },
                  onCompletedChanged: (task) {
                    updateIsCompletedTask(task);
                  },
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
