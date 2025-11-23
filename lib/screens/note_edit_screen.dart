import 'package:flutter/material.dart';
import '../data/firebase_service.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note note;
  const NoteEditScreen({super.key, required this.note});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isNewNote = false;

  @override
  void initState() {
    super.initState();
    _isNewNote = widget.note.title.isEmpty && widget.note.content.isEmpty;
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNewNote ? 'Tạo ghi chú mới' : 'Sửa ghi chú'),
        actions: [
          if (!_isNewNote)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await FirebaseService.deleteNote(widget.note.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Tiêu đề',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Bắt đầu viết...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updatedNote = Note(
            id: widget.note.id,
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            createdAt: widget.note.createdAt,
            updatedAt: DateTime.now(),
          );

          if (_isNewNote) {
            await FirebaseService.addNote(updatedNote);
          } else {
            await FirebaseService.updateNote(updatedNote);
          }

          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}