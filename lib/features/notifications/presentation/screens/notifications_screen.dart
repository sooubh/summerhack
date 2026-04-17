import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Notifications',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'In-app notification center scaffold is ready for FCM + Firestore sync.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
