import 'package:flutter/material.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resep Tersimpan')),
      body: Center(child: Text('Belum ada resep tersimpan')),
    );
  }
}
