import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';
import 'add_task.dart';
import 'edit_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class TaskItem extends StatefulWidget {
  final Task task;
  final Function(bool) onTaskCompleted;
  final VoidCallback onTaskEdit;
  final VoidCallback onTaskDelete;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onTaskCompleted,
    required this.onTaskEdit,
    required this.onTaskDelete,
  }) : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(widget.task.name),
        subtitle: Text(widget.task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                widget.onTaskEdit();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                widget.onTaskDelete();
              },
            ),
            Checkbox(
              value: widget.task.completed,
              onChanged: (value) {
                setState(() {
                  widget.task.completed = value!;
                });
                widget.onTaskCompleted(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  bool showCompletedTasks = false;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tasksJson = prefs.getStringList('tasks');

    if (tasksJson != null) {
      setState(() {
        tasks = tasksJson.map((taskJson) => Task.fromJson(jsonDecode(taskJson))).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> filteredTasks = getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showCompletedTasks = !showCompletedTasks;
              });
            },
            icon: Icon(
              showCompletedTasks ? Icons.check_box : Icons.check_box_outline_blank,
            ),
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? const Center(child: Text('Нет запланированных задач'))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: filteredTasks[index],
                  onTaskCompleted: (completed) {
                    setState(() {
                      tasks[index].completed = completed;
                    });
                  },
                  onTaskEdit: () {
                    _navigateToEditTaskScreen(context, filteredTasks[index]);
                  },
                  onTaskDelete: () {
                    _deleteTask(index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onTaskAdded: (newTask) {
                  setState(() {
                    tasks.add(newTask);
                  });
                  saveTasks(); // Добавлено сохранение задач после добавления
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _navigateToEditTaskScreen(BuildContext context, Task task) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          task: task,
          onTaskUpdated: (updatedTask) {
            setState(() {
              tasks[tasks.indexWhere((element) => element == task)] = updatedTask;
            });
            saveTasks(); // Добавлено сохранение задач после обновления
          },
        ),
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks(); // Добавлено сохранение задач после удаления
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    prefs.setStringList('tasks', tasksJson);
  }

  List<Task> getFilteredTasks() {
    return showCompletedTasks
        ? tasks.where((task) => task.completed).toList()
        : tasks.where((task) => !task.completed).toList();
  }
}
