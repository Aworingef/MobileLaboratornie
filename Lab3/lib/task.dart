// task.dart
class Task {
  String name;
  String description;
  bool completed;

  Task({
    required this.name,
    required this.description,
    this.completed = false, // Инициализируем 'completed' значением по умолчанию
  });

  // Метод для преобразования объекта Task в формат JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'completed': completed,
    };
  }

  // Метод для создания объекта Task из JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      description: json['description'],
      completed: json['completed'],
    );
  }
}
