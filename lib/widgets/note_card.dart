// lib/widgets/note_card.dart
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_helper.dart';
import '../data/firebase_service.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(int.parse(note.color)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (note.isFavorite)
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                const Spacer(),
                if (note.isFavorite) const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.title.isEmpty ? '(Không có tiêu đề)' : note.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              note.content.isEmpty ? 'Không có nội dung' : note.content,
              style: TextStyle(color: Colors.black.withOpacity(0.7)),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              DateHelper.format(note.createdAt),
              style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(note.isFavorite ? Icons.star : Icons.star_border),
              title: Text(note.isFavorite ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'),
              onTap: () {
                FirebaseService.updateNote(note.copyWith(isFavorite: !note.isFavorite));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Đổi màu'),
              onTap: () {
                Navigator.pop(ctx);
                _showColorPicker(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chọn màu'),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: NoteColors.colors.map((color) {
            return GestureDetector(
              onTap: () {
                FirebaseService.updateNote(note.copyWith(color: color));
                Navigator.pop(ctx);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(int.parse(color)),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: note.color == color
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Extension để copy note dễ hơn
extension NoteCopy on Note {
  Note copyWith({
    String? title,
    String? content,
    bool? isFavorite,
    String? color,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isFavorite: isFavorite ?? this.isFavorite,
      color: color ?? this.color,
    );
  }
}