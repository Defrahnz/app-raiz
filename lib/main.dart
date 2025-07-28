import 'package:flutter/material.dart';
// Importa el nuevo contenedor de navegación
import 'main_navigator_cont.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raíz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Cambia el home para que apunte al nuevo widget con la barra de navegación
      home: const MainNavigationContainer(),
    );
  }
}
