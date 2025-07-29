import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './explore_screen.dart'; // Asegúrate de que 'Place' venga de aquí

class PlaceDetail {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final double rating;
  final String description;

  PlaceDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.description,
  });

  factory PlaceDetail.fromGooglePlaceDetails(dynamic json, String imageUrl) {
    final result = json['result'];

    return PlaceDetail(
      id: result['place_id'] ?? '',
      name: result['name'] ?? 'Sin nombre',
      address: result['formatted_address'] ?? 'Sin dirección',
      imageUrl: imageUrl,
      rating: (result['rating'] ?? 0.0).toDouble(),
      description:
          result['editorial_summary']?['overview'] ??
          'No hay descripción disponible.',
    );
  }
}

class PlaceDetailsScreen extends StatefulWidget {
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  late Future<PlaceDetail> _detailsFuture;
  bool isFavorite = false;

  // Cambia esta por tu propia Google API Key
  final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _detailsFuture = _fetchPlaceDetails(widget.place.id);
  }

  Future<PlaceDetail> _fetchPlaceDetails(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=place_id,name,formatted_address,rating,editorial_summary&language=es&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PlaceDetail.fromGooglePlaceDetails(data, widget.place.imageUrl);
    } else {
      throw Exception('Error al cargar los detalles de Google Places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<PlaceDetail>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            final details = snapshot.data!;
            return _buildContent(context, details);
          }
          return const Center(child: Text('Cargando detalles...'));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PlaceDetail details) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  details.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre + botón de favorito
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            details.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                      ],
                    ),

                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 5),
                        Text(
                          '${details.rating.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "(Google Reviews)",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // Descripción
                    Text(
                      details.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Read more"),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Facilities",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _FacilityIcon(icon: Icons.heat_pump, label: "Heater"),
                        _FacilityIcon(
                          icon: Icons.restaurant_menu,
                          label: "Dining",
                        ),
                        _FacilityIcon(icon: Icons.local_drink, label: "Walk"),
                        _FacilityIcon(icon: Icons.pool, label: "Pool"),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Botón de regreso
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),

        // Bottom bar
        _buildBottomBar(),
      ],
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
              color: Colors.white.withOpacity(0.85),
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '\$199',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
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
}

class _FacilityIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FacilityIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
