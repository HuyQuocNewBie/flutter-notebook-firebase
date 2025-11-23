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
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isNewNote)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Xóa ghi chú?'),
                    content: const Text('Hành động này không thể hoàn tác.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  await FirebaseService.deleteNote(widget.note.id);
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.blue),
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
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Tiêu đề',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 28, color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              autofocus: _isNewNote,
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Bắt đầu viết...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 18, height: 1.6),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}