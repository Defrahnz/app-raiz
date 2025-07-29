import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservations.dart';
import '../models/reservations_provider.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = Provider.of<ReservationsProvider>(
      context,
    ).reservations;

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
      body: reservations.isEmpty
          ? const Center(
              child: Text(
                'No hay reservaciones aún.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
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
