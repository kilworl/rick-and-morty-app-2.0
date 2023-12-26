import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/characters_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick and Morty GraphQL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Use GetMaterialApp's initialRoute to set the initial route
      initialRoute: '/',
      getPages: [
        // Define the splash screen route
        GetPage(name: '/', page: () => SplashScreen()),
        // Define the characters page route
        GetPage(name: '/characters', page: () => CharactersPage()),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simulate a delay for 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      // Use Get.offNamed to navigate to the characters page
      Get.offNamed('/characters');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Rick and Morty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
