import 'category.dart';

class Task {
  String title;
  String description;
  DateTime dateTime;
  String priority; // Ex: 'Alta', 'Média', 'Baixa'
  Category category; // Agora armazena um objeto Category
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    required this.category,
    this.isCompleted = false,
  });
}