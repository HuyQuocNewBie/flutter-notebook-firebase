// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_colors.dart';
import '../data/firebase_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'note_edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Ghi chú của tôi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm ghi chú...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),

          // Danh sách ghi chú
          Expanded(
            child: StreamBuilder<List<Note>>(
              stream: FirebaseService.getNotes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var notes = snapshot.data!;

                // Lọc tìm kiếm
                if (_searchQuery.isNotEmpty) {
                  notes = notes.where((note) {
                    return note.title.toLowerCase().contains(_searchQuery) ||
                           note.content.toLowerCase().contains(_searchQuery);
                  }).toList();
                }

                // Sắp xếp: Favorite lên đầu, mới nhất trước
                notes.sort((a, b) {
                  if (a.isFavorite && !b.isFavorite) return -1;
                  if (!a.isFavorite && b.isFavorite) return 1;
                  return b.createdAt.compareTo(a.createdAt);
                });

                if (notes.isEmpty) {
                  return const EmptyState();
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NoteEditScreen(note: note)),
                      ),
                      onDelete: () => FirebaseService.deleteNote(note.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
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
        label: const Text('Ghi chú mới'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}