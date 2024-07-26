import 'package:flutter/material.dart';

Card dismissibleBackground() {
  return Card(
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [Padding(padding: EdgeInsets.all(14), child: Icon(Icons.delete, color: Colors.white))],
      ));
}
