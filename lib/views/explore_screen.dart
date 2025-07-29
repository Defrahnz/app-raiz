import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './place_details.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- Modelo de datos simple para los lugares ---
// (Este modelo se puede mover a su propio archivo en el futuro)
class Place {
  final String id;
  final String name;
  final String address;
  final String imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
  });

  //Creamos un objeto place desde el JSON de la api
  factory Place.fromGoogleResult(dynamic json, String apiKey) {
    String imageUrl =
        'https://placehold.co/400x400/EFEFEF/AAAAAA?text=No+Image';

    if (json.photos != null && json.photos!.isNotEmpty) {
      final photoRef = json.photos!.first.photoReference;
      imageUrl =
          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoRef&key=$apiKey';
    }

    return Place(
      id: json.placeId ?? '',
      name: json.name ?? 'Nombre no disponible',
      address: json.vicinity ?? 'Dirección no disponible',
      imageUrl: imageUrl,
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Place>> _placesFuture;

  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
  @override
  void initState() {
    super.initState();
    // Al iniciar la pantalla, comenzamos el proceso de carga de datos.
    _placesFuture = _loadPlacesData();
  }

  // --- FUNCIÓN PRINCIPAL PARA CARGAR DATOS ---
  Future<List<Place>> _loadPlacesData() async {
    try {
      // 1. Obtenemos la posición actual del dispositivo.
      final Position position = await _determinePosition();

      // 2. Usamos la posición para buscar lugares cercanos.
      return await _fetchPlaces(position.latitude, position.longitude);
    } catch (e) {
      // Si hay un error (ej. permisos denegados), lo lanzamos para que el FutureBuilder lo maneje.
      print('Error al cargar datos de lugares: $e');
      throw Exception(
        'No se pudieron cargar los lugares. Revisa tus permisos de ubicación.',
      );
    }
  }

  // --- FUNCIÓN PARA OBTENER LA UBICACIÓN (de la documentación de geolocator) ---
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Los permisos de ubicación están permanentemente denegados.',
      );
    }

    // Si llegamos aquí, los permisos están concedidos y podemos obtener la posición.
    return await Geolocator.getCurrentPosition();
  }

  // --- FUNCIÓN PARA LLAMAR A LA API DE FOURSQUARE ---
  Future<List<Place>> _fetchPlaces(double lat, double lon) async {
    final googlePlace = GooglePlace(apiKey);

    final result = await googlePlace.search.getNearBySearch(
      Location(lat: lat, lng: lon),
      5000,
      type: "tourist_attraction",
      language: "es",
    );

    if (result != null && result.results != null) {
      final places = result.results!
          .map((place) => Place.fromGoogleResult(place, apiKey))
          .toList();
      return places;
    } else {
      throw Exception('No se pudieron cargar los lugares.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // --- USO DE FUTUREBUILDER PARA MANEJAR ESTADOS DE CARGA/ERROR/ÉXITO ---
        child: FutureBuilder<List<Place>>(
          future: _placesFuture,
          builder: (context, snapshot) {
            // ESTADO DE CARGA
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // ESTADO DE ERROR
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }
            // ESTADO DE ÉXITO
            if (snapshot.hasData) {
              final places = snapshot.data!;
              // Dividimos la lista para "Popular" y "Recommended" (puedes ajustar la lógica)
              final popularPlaces = places.take(5).toList();
              final recommendedPlaces = places.skip(5).toList();

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20.0,
                ),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildCategoryTabs(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Popular', () {}),
                  const SizedBox(height: 15),
                  _buildHorizontalPlaceList(popularPlaces),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Recommended', () {}),
                  const SizedBox(height: 15),
                  _buildHorizontalPlaceList(recommendedPlaces),
                ],
              );
            }
            // Estado inicial o por defecto
            return const Center(child: Text("Iniciando..."));
          },
        ),
      ),
    );
  }

  // --- WIDGETS DE UI (MODIFICADOS PARA USAR EL NUEVO MODELO 'Place') ---

  Widget _buildHeader() {
    return Column(
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
              'Ubicación Actual',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    // Sin cambios
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
    // Sin cambios
    final List<String> _categories = [
      'Location',
      'Food',
      'Adventure',
      'Culture',
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.blue.shade50 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _categories[index],
              style: TextStyle(
                color: index == 0 ? Colors.blue.shade700 : Colors.grey.shade600,
                fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    // Sin cambios
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

  Widget _buildHorizontalPlaceList(List<Place> places) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: places.length,
        itemBuilder: (context, index) {
          final place = places[index];
          return _buildPlaceCard(place);
        },
      ),
    );
  }

  // Tarjeta unificada para mostrar lugares (reemplaza a _buildPopularCard y _buildRecommendedCard)
  Widget _buildPlaceCard(Place place) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlaceDetailsScreen(place: place), // <-- Ajustar esto
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        child: Stack(
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
              child: Text(
                place.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
