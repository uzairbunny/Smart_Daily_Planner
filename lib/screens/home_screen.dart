import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_list_item.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Daily Planner'),
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text('No tasks yet. Add one!'),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskListItem(
                  task: task,
                  onTap: () => _navigateToEditTask(task),
                  onDelete: () => _deleteTask(task.id),
                  onCompleted: (isCompleted) => _toggleCompleted(task, isCompleted),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddTask() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
    );
    if (newTask != null) {
      await _taskService.addTask(newTask);
      _loadTasks();
    }
  }

  void _navigateToEditTask(Task task) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTaskScreen(task: task),
      ),
    );
    if (updatedTask != null) {
      await _taskService.updateTask(updatedTask);
      _loadTasks();
    }
  }

  Future<void> _deleteTask(String taskId) async {
    await _taskService.deleteTask(taskId);
    _loadTasks();
  }

  Future<void> _toggleCompleted(Task task, bool isCompleted) async {
    task.isCompleted = isCompleted;
    await _taskService.updateTask(task);
    _loadTasks();
  }
}
