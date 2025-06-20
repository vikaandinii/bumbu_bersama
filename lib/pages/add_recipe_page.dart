import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  void _saveRecipe() async {
    String recipeName = _nameController.text.trim();
    String description = _descriptionController.text.trim();
    String ingredients = _ingredientsController.text.trim();

    if (recipeName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama resep tidak boleh kosong')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recipeList = prefs.getStringList('recipes') ?? [];

    // Format penyimpanan: Nama|Deskripsi|Bahan
    recipeList.add('$recipeName|$description|$ingredients');

    await prefs.setStringList('recipes', recipeList);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Resep')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Resep',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Bahan-bahan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: const Text('Simpan Resep'),
            ),
          ],
        ),
      ),
    );
  }
}
