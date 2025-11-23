import 'package:flutter/material.dart';

/// Widget hiển thị khi danh sách ghi chú trống
/// Mục đích: Giao diện thân thiện, hướng dẫn người dùng cách tạo ghi chú đầu tiên
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon lớn minh họa cho ghi chú
        Icon(
          Icons.note_alt_outlined,
          size: 80,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 16),

        // Tiêu đề trạng thái trống
        Text(
          'Chưa có ghi chú nào',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Hướng dẫn người dùng
        Text(
          'Nhấn nút + để tạo ghi chú mới',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
  }
}