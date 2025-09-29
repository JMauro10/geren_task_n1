import 'category.dart';

class Task {
  String title;
  String description;
  DateTime dateTime;
  String priority;
  Category category; 
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