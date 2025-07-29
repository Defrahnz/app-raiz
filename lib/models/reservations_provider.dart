import 'package:flutter/material.dart';
import '../models/reservations.dart';

class ReservationsProvider with ChangeNotifier {
  final List<Reservation> _reservations = [];

  List<Reservation> get reservations => List.unmodifiable(_reservations);

  void addReservation(Reservation reservation) {
    _reservations.insert(0, reservation);
    notifyListeners();
  }
}
