import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false, // No back arrow
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text(
            'PERFIL',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoField(label: 'Alias', value: 'MN VIAJES'),
          const SizedBox(height: 20),
          _buildInfoField(label: 'Nombre', value: 'MN VIAJES'),
          const SizedBox(height: 20),
          _buildInfoField(label: 'Email', value: 'm_nviajes@hotmail.com'),
          const SizedBox(height: 20),
          _buildInfoField(label: 'Móvil', value: '4499709515'),
          const SizedBox(height: 30),
          _buildStatusSwitch(),
        ],
      ),
    );
  }

  // Widget para crear los campos de texto de solo lectura
  Widget _buildInfoField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          readOnly: true,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  // Widget para el interruptor de Status
  Widget _buildStatusSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Switch(
            value: true, // Valor estático como se solicitó
            onChanged: (bool value) {
              // No se necesita acción para datos estáticos
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
