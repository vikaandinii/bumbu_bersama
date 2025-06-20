import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String recipeName =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(recipeName), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String>(
          future: _fetchRecipeDetails(
            recipeName,
          ), // Function to get recipe details
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final recipeDetails = snapshot.data ?? '';
              final recipeData = recipeDetails.split('|');
              final description =
                  recipeData.length > 1
                      ? recipeData[1]
                      : 'Deskripsi tidak tersedia';
              final ingredients =
                  recipeData.length > 2
                      ? recipeData[2]
                      : 'Bahan tidak tersedia';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deskripsi:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                    const SizedBox(height: 16),
                    const Text(
                      'Bahan-bahan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(ingredients),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Resep tidak ditemukan.'));
            }
          },
        ),
      ),
    );
  }

  // Mock function to simulate fetching recipe details from storage or database
  Future<String> _fetchRecipeDetails(String recipeName) async {
    // In a real scenario, you'd fetch the details based on the recipe name
    // This is a placeholder for demonstration
    await Future.delayed(const Duration(seconds: 2));
    // Simulate recipe data
    return 'Nama Resep: $recipeName|Deskripsi resep ini memberikan penjelasan detail tentang cara pembuatan.|Tomat, Bawang, Daging';
  }
}
