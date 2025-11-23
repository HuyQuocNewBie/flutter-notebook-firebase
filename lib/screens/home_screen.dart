import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/firebase_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'note_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú của tôi'),
        centerTitle: false,
      ),
      body: StreamBuilder<List<Note>>(
        stream: FirebaseService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Có lỗi xảy ra'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteEditScreen(note: note),
                    ),
                  );
                },
                onDelete: () async {
                  await FirebaseService.deleteNote(note.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newNote = Note(
            id: const Uuid().v4(),
            title: '',
            content: '',
            createdAt: DateTime.now(),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NoteEditScreen(note: newNote)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}