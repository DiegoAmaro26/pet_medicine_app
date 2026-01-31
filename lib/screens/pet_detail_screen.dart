import 'package:flutter/material.dart';

class PetDetailScreen extends StatelessWidget {
  final int petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de mascota')),
      body: Center(
        child: Text(
          'Mascota ID: $petId',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
