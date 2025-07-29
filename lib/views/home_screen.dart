import 'dart:async';
import 'package:flutter/material.dart';
import '../main_navigator_cont.dart'; // Asegúrate de que esta ruta esté correcta

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Espera 5 segundos y navega a la pantalla principal
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MainNavigationContainer(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.jpg', // Cambia esta ruta si tu logo está en otro lugar
              width: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Colors.blue, strokeWidth: 3),
          ],
        ),
      ),
    );
  }
}
