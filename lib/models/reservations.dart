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
    this.titular = 'Sin titular',
    this.hotel = 'Hotel no especificado',
    this.checkIn = 'Sin fecha',
    this.fechaReserva = 'Fecha desconocida',
    this.caducidad = '-',
    this.total = 0.0,
    this.isActive = true,
  });
}
