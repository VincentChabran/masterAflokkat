import 'package:examen/models/task.model.dart';
import 'package:examen/widget/dismissible_background.dart';
import 'package:examen/widget/task_card/nom_desc_column.dart';
import 'package:flutter/material.dart';

class TaskCardItem extends StatelessWidget {
  final Task task;
  final Function() onUpdateTask;
  final Function(Task task) onDismissed;
  final Function(Task task) onCompletedChanged;

  const TaskCardItem({
    super.key,
    required this.task,
    required this.onUpdateTask,
    required this.onDismissed,
    required this.onCompletedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${task.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(task),
      background: dismissibleBackground(),
      child: Card(
        elevation: 6,
        color: task.isCompleted ? Colors.green[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () => onCompletedChanged(task),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Update (nom, desc) btn
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue[300]),
                  onPressed: () => onUpdateTask(),
                ),

                const SizedBox(width: 16),

                buildColumn(task),

                Checkbox(
                  value: task.isCompleted,
                  activeColor: const Color.fromARGB(255, 48, 128, 51),
                  onChanged: (newValue) => onCompletedChanged(task),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
