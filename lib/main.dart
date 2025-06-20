import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bumbu_bersama/providers/theme_provider.dart';
import 'package:bumbu_bersama/pages/login_page.dart';
import 'package:bumbu_bersama/pages/register_page.dart';
import 'package:bumbu_bersama/pages/home_page.dart';
import 'package:bumbu_bersama/pages/profile_page.dart';
import 'package:bumbu_bersama/pages/explore_page.dart';
import 'package:bumbu_bersama/pages/add_recipe_page.dart';
import 'package:bumbu_bersama/pages/recipe_detail_page.dart';
import 'package:bumbu_bersama/pages/forgot_password.dart';
import 'package:bumbu_bersama/pages/saved_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: BumbuBersamaApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class BumbuBersamaApp extends StatelessWidget {
  final bool isLoggedIn;

  const BumbuBersamaApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Bumbu Bersama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3AB76C),
          secondary: Color(0xFF3AB76C),
        ),
        buttonTheme: const ButtonThemeData(buttonColor: Color(0xFF3AB76C)),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF3AB76C)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3AB76C),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3AB76C),
          secondary: Color(0xFF3AB76C),
        ),
      ),
      themeMode: themeProvider.currentTheme,
      initialRoute: isLoggedIn ? '/home' : '/login',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          case '/home':
          case '/profile':
          case '/explore':
          case '/saved':
            return MaterialPageRoute(builder: (_) => const NavigationWrapper());
          case '/addRecipe':
            return MaterialPageRoute(builder: (_) => const AddRecipePage());
          case '/recipeDetail':
            return MaterialPageRoute(builder: (_) => const RecipeDetailPage());
          case '/forgot-password':
            return MaterialPageRoute(builder: (_) => const ForgotPassword());
          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('Page not found')),
                  ),
            );
        }
      },
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const SavedPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Jelajahi'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Simpan'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
