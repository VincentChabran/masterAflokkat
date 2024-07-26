class Task {
  final int id;
  final String nom;
  final String description;
  bool isCompleted;

  Task({required this.id, required this.nom, required this.description, required this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
