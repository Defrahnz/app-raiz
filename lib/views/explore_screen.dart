import 'package:flutter/material.dart';
import 'package:app_raiz/views/place_details.dart';
import 'dart:ui'; // Para usar ImageFilter.blur

// --- Modelo de datos simple para los lugares ---
// (Este modelo se puede mover a su propio archivo en el futuro)
class Place {
  final String name;
  final String imageUrl;
  final double rating;
  final String duration;

  Place({
    required this.name,
    required this.imageUrl,
    this.rating = 0.0,
    this.duration = '',
  });
}

// --- Datos de ejemplo (Mock Data) ---
final List<Place> popularPlaces = [
  Place(
    name: 'Cerro del Muerto',
    imageUrl:
        'https://images.unsplash.com/photo-1622023922308-3f38add65346?q=80&w=1964&auto=format&fit=crop',
    rating: 4.1,
  ),
  Place(
    name: 'Presa Calles',
    imageUrl:
        'https://images.unsplash.com/photo-1599146419790-2025164268e8?q=80&w=1887&auto=format&fit=crop',
    rating: 4.5,
  ),
  Place(
    name: 'Jardín de San Marcos',
    imageUrl:
        'https://images.unsplash.com/photo-1589218528219-1369a4412323?q=80&w=1887&auto=format&fit=crop',
    rating: 4.8,
  ),
];

final List<Place> recommendedPlaces = [
  Place(
    name: 'Centro Histórico',
    imageUrl:
        'https://images.unsplash.com/photo-1605332151324-a715f03a11a2?q=80&w=1935&auto=format&fit=crop',
    duration: '4N/5D',
  ),
  Place(
    name: 'Viñedos',
    imageUrl:
        'https://images.unsplash.com/photo-1598104334236-32451a954157?q=80&w=1887&auto=format&fit=crop',
    duration: '2N/3D',
  ),
  Place(
    name: 'Real de Asientos',
    imageUrl:
        'https://images.unsplash.com/photo-1634545087398-e7d85367c8b4?q=80&w=1887&auto=format&fit=crop',
    duration: '1N/2D',
  ),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Location', 'Food', 'Adventure', 'Culture'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCategoryTabs(),
          const SizedBox(height: 30),
          _buildSectionHeader('Popular', () {}),
          const SizedBox(height: 15),
          _buildHorizontalPlaceList(popularPlaces, isPopular: true),
          const SizedBox(height: 30),
          _buildSectionHeader('Recommended', () {}),
          const SizedBox(height: 15),
          _buildHorizontalPlaceList(recommendedPlaces, isPopular: false),
        ],
      ),
    );
  }

  // ... (Los widgets _buildAppBar, _buildSearchBar, _buildCategoryTabs, y _buildSectionHeader no cambian) ...
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false, // Para no mostrar la flecha de regreso
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 4),
              const Text(
                'Aguascalientes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                ', MX',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Find things to do',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.blue.shade700
                      : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See all', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildHorizontalPlaceList(
    List<Place> places, {
    required bool isPopular,
  }) {
    return SizedBox(
      height: isPopular ? 240 : 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return isPopular
              ? _buildPopularCard(place)
              : _buildRecommendedCard(place);
        },
      ),
    );
  }

  // --- PASO 2: ACTUALIZAR LA TARJETA POPULAR ---
  Widget _buildPopularCard(Place place) {
    // Se envuelve el Container en un GestureDetector para hacerlo interactivo
    return GestureDetector(
      onTap: () {
        // Al tocar, se navega a la pantalla de detalles pasando el objeto 'place'
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsScreen(place: place),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        child: Stack(
          // El contenido de la tarjeta no cambia
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                place.imageUrl,
                height: 240,
                width: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          place.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- PASO 3: ACTUALIZAR LA TARJETA RECOMENDADA ---
  Widget _buildRecommendedCard(Place place) {
    // También se envuelve en un GestureDetector
    return GestureDetector(
      onTap: () {
        // Y se le añade la misma lógica de navegación
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsScreen(place: place),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 15.0),
        child: Column(
          // El contenido de la tarjeta no cambia
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      place.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        place.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              place.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
