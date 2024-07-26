import 'package:flutter/material.dart';

buildColumn(task) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.nom,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        Text(
          task.description,
          style: TextStyle(
            color: Colors.grey[600],
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    ),
  );
}
