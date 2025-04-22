import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVideoScreen extends StatefulWidget {
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _videoUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _saveVideo() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('videos').add({
        'url': _videoUrlController.text,
        'title': _titleController.text,
        'description': _descriptionController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Видео успешно добавлено!')),
      );
      Navigator.pop(context); // Вернуться на главный экран
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить видео')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _videoUrlController,
                decoration: InputDecoration(labelText: 'Ссылка на видео'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ссылку на видео';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveVideo,
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}