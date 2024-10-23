import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Timestamp timestamp;

  const MyListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi Timestamp thành DateTime
    DateTime dateTime = timestamp.toDate();

    // Định dạng thời gian
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          trailing: Text(
            formattedTime, // Hiển thị thời gian ở phía bên phải
            style: TextStyle(
              fontSize: 12, // Kích thước chữ
              color: Colors.grey, // Màu sắc cho thời gian
            ),
          ),
        ),
      ),
    );
  }
}
