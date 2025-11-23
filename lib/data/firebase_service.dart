import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'notes';

  // Lấy danh sách ghi chú (sắp xếp theo ngày tạo, mới nhất trước)
  static Stream<List<Note>> getNotes() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Thêm ghi chú mới
  static Future<void> addNote(Note note) async {
    await _firestore.collection(_collection).doc(note.id).set(note.toMap());
  }

  // Cập nhật ghi chú
  static Future<void> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    await _firestore.collection(_collection).doc(note.id).update(note.toMap());
  }

  // Xóa ghi chú
  static Future<void> deleteNote(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}