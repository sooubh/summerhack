import 'package:flutter/material.dart';

class UploadsScreen extends StatelessWidget {
  const UploadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Uploads',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'File upload module scaffold is ready for Firebase Storage integration '
                'for image, document, and audio categories.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
