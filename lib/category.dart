import 'package:flutter/widgets.dart';

class Category {
  String name;
  IconData icon;
  Color color;

  Category({required this.name, required this.icon, required this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode; // Hashcode baseado no nome para comparação
}