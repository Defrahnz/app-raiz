import 'package:flutter/material.dart';

// Modelo de datos para una reservación.
// En un futuro, esto vendrá de tu API.
class Reservation {
  final String localizador;
  final String titular;
  final String hotel;
  final String checkIn;
  final String fechaReserva;
  final String caducidad;
  final double total;
  final bool isActive;

  Reservation({
    required this.localizador,
    required this.titular,
    required this.hotel,
    required this.checkIn,
    required this.fechaReserva,
    required this.caducidad,
    required this.total,
    required this.isActive,
  });
}

// Datos de ejemplo para mostrar en la lista.
final List<Reservation> mockReservations = [
  Reservation(
    localizador: 'AALI-S6Q7H2',
    titular: 'Luz Maria Lopez Figueroa',
    hotel: 'La Posada and Beach Club | La Paz',
    checkIn: '2025-07-22',
    fechaReserva: '2025-07-14 16:55',
    caducidad: '-',
    total: 14578.59,
    isActive: true,
  ),
  Reservation(
    localizador: 'ANCH-P1F5K7',
    titular: 'Maria Clementina Jimenez Rojas',
    hotel: 'Decameron Isla Coral Guayabitos',
    checkIn: '2025-06-29',
    fechaReserva: '2025-06-17 19:59',
    caducidad: '-',
    total: 26915.60,
    isActive: true,
  ),
  Reservation(
    localizador: 'AINT-T5E1I2',
    titular: 'Eva Gordillo Garay',
    hotel: 'Internacional | Traslado Hotel',
    checkIn: '2025-06-24',
    fechaReserva: '2025-06-16 18:42',
    caducidad: '-',
    total: 950.00,
    isActive: true,
  ),
  Reservation(
    localizador: 'ANCH-X1H1Q4',
    titular: 'Norma Yuliana Salas Rosales',
    hotel: 'Crown Paradise Golden All Inclusive',
    checkIn: '2026-01-08',
    fechaReserva: '2025-05-31 15:24',
    caducidad: '12-JUN-25',
    total: 0.00,
    isActive: false,
  ),
  Reservation(
    localizador: 'AINT-H8R4Y9',
    titular: 'Eva Gordillo Garay',
    hotel: 'Grand Bavaro Princess All Inclusive',
    checkIn: '2025-06-17',
    fechaReserva: '2025-05-29 19:17',
    caducidad: '03-JUN-25',
    total: 39290.75,
    isActive: false,
  ),
];

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Reservaciones',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: mockReservations.length,
        itemBuilder: (context, index) {
          final reservation = mockReservations[index];
          return _buildReservationCard(reservation);
        },
      ),
    );
  }

  // Widget para construir cada tarjeta de reservación
  Widget _buildReservationCard(Reservation reservation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: reservation.isActive ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reservation.localizador,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${reservation.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Titular:', reservation.titular),
            const SizedBox(height: 8),
            _buildInfoRow('Hotel/Servicio:', reservation.hotel),
            const SizedBox(height: 8),
            _buildInfoRow('Check-in:', reservation.checkIn),
            const SizedBox(height: 8),
            _buildInfoRow('Fecha de Reserva:', reservation.fechaReserva),
          ],
        ),
      ),
    );
  }

  // Helper para crear las filas de información
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
