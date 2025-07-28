import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para HapticFeedback
import 'dart:ui'; // Para ImageFilter.blur

// Importamos el modelo de datos que ya creamos.
// Asegúrate de que la ruta de importación sea correcta.
import './explore_screen.dart';

class PlaceDetailsScreen extends StatefulWidget {
  // La pantalla recibirá un objeto 'Place' para mostrar sus detalles.
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      // Usamos un Stack para poder superponer elementos sobre el body
      body: Stack(
        children: [
          // Contenido principal que se puede desplazar
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(screenSize),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 20),
                      _buildDescription(),
                      const SizedBox(height: 30),
                      _buildFacilities(),
                    ],
                  ),
                ),
                // Espacio extra al final para que no lo tape la barra inferior
                const SizedBox(height: 120),
              ],
            ),
          ),
          // Botones superpuestos en la imagen
          _buildTopButtons(),
          // Barra inferior fija
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage(Size screenSize) {
    return Stack(
      children: [
        Container(
          height: screenSize.height * 0.45,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.place.imageUrl),
              fit: BoxFit.cover,
              // Fallback por si la imagen no carga
              onError: (exception, stackTrace) {
                // Puedes mostrar un widget de error aquí
              },
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        // Degradado sutil en la parte inferior de la imagen para que el borde no sea tan duro
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black12],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.8, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopButtons() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 15,
      right: 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón de regreso
          _buildBlurredButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // El Expanded asegura que el texto no se desborde si es muy largo
            Expanded(
              child: Text(
                widget.place.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Botón de favorito
            GestureDetector(
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                HapticFeedback.lightImpact();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isFavorite
                      ? Colors.red.shade100
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? Colors.red.shade700
                      : Colors.grey.shade600,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 5),
            Text(
              '${widget.place.rating} (365 Reviews)',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('Show map')),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    // Texto de ejemplo. Lo reemplazarás con la descripción de tu API.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'La Presa Plutarco Elías Calles, también conocida como Presa Calles, es una presa ubicada en el municipio de San José de Gracia, Aguascalientes, México...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade800,
            height: 1.5, // Espacio entre líneas
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        Text(
          'Read more',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facilities',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFacilityIcon(Icons.wifi, '1 Heater'),
            _buildFacilityIcon(Icons.restaurant, 'Dinner'),
            _buildFacilityIcon(Icons.bathtub_outlined, '1 Tub'),
            _buildFacilityIcon(Icons.pool, 'Pool'),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilityIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 28),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: Colors.blue.shade800)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(
                      '\$199',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text('Book Now', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper para los botones con fondo borroso
  Widget _buildBlurredButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
