import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TimeOfDay _timeSlot;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _timeSlot = widget.task!.timeSlot;
    } else {
      _title = '';
      _description = '';
      _timeSlot = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text('Time Slot: '),
                  TextButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _timeSlot,
                      );
                      if (time != null) {
                        setState(() {
                          _timeSlot = time;
                        });
                      }
                    },
                    child: Text(_timeSlot.format(context)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.task?.id ?? Uuid().v4(),
        title: _title,
        description: _description,
        timeSlot: _timeSlot,
        isCompleted: widget.task?.isCompleted ?? false,
      );
      Navigator.pop(context, task);
    }
  }
}
