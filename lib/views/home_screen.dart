import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos las dimensiones de la pantalla para un diseño adaptable.
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // Usamos un Stack para superponer widgets (imagen de fondo, contenido, etc.).
      body: Stack(
        children: [
          // 1. WIDGET DE FONDO
          // Este Container ocupa toda la pantalla y muestra la imagen.
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // IMPORTANTE: Reemplaza esta URL con tu propia imagen.
                // Para usar una imagen local:
                // 1. Crea una carpeta 'assets' en la raíz de tu proyecto.
                // 2. Agrega la imagen ahí (ej: assets/background.png).
                // 3. Declárala en tu archivo pubspec.yaml:
                //    flutter:
                //      assets:
                //        - assets/background.png
                // 4. Usa: AssetImage('assets/background.png')
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1572533925227-42b330404b9a?q=80&w=1887&auto=format&fit=crop',
                ),
                fit: BoxFit.cover, // La imagen cubre todo el espacio.
              ),
            ),
          ),

          // 2. WIDGET DE SUPERPOSICIÓN (OVERLAY)
          // Este Container agrega un degradado oscuro en la parte inferior
          // para que el texto blanco sea más legible.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.4, 0.6, 1],
              ),
            ),
          ),

          // 3. WIDGET DE CONTENIDO PRINCIPAL
          // SafeArea asegura que el contenido no se superponga con la barra de estado o el notch.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- SECCIÓN SUPERIOR: LOGOS ---
                  _buildHeader(),

                  // Spacer ocupa el espacio disponible para empujar el contenido inferior hacia abajo.
                  const Spacer(),

                  // --- SECCIÓN CENTRAL: TEXTO PRINCIPAL ---
                  _buildMainText(),

                  const SizedBox(height: 30),

                  // --- SECCIÓN INFERIOR: BOTÓN ---
                  _buildExploreButton(screenSize),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la cabecera con los textos "Cultur Mex" y "Raíz Viva".
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Usamos RichText para dar estilos diferentes a cada palabra.
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto', // Puedes cambiar la fuente
            ),
            children: [
              TextSpan(
                text: 'Cultur\n',
                style: TextStyle(color: Color(0xFFD32F2F)), // Rojo
              ),
              TextSpan(
                text: 'Mex',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        RichText(
          textAlign: TextAlign.right,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
            children: [
              TextSpan(
                text: 'Raíz\n',
                style: TextStyle(color: Color(0xFF4CAF50)), // Verde
              ),
              TextSpan(
                text: 'Viva',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye el texto principal de la pantalla.
  Widget _buildMainText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Planea tu próxima',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w300, // Fuente más ligera
          ),
        ),
        const Text(
          'Aventura',
          style: TextStyle(
            color: Colors.white,
            fontSize: 56,
            fontWeight: FontWeight.bold, // Fuente en negrita
          ),
        ),
      ],
    );
  }

  /// Construye el botón "Explore".
  Widget _buildExploreButton(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.8, // El botón ocupa el 80% del ancho
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Aquí va la lógica para navegar a otra pantalla.
          print('Botón Explore presionado!');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC62828), // Color rojo del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Bordes redondeados
          ),
        ),
        child: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
