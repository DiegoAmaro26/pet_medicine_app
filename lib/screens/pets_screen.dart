import 'package:flutter/material.dart';
import '../services/pet_service.dart';
import 'pet_detail_screen.dart';


class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final PetService _petService = PetService();

  List<dynamic> _pets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final response = await _petService.getPets();

      setState(() {
        _pets = response['data']; // 👈 CLAVE
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error cargando mascotas';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis mascotas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _pets.isEmpty
                  ? const Center(child: Text('No tienes mascotas'))
                  : ListView.builder(
                      itemCount: _pets.length,
                      itemBuilder: (context, index) {
                        final pet = _pets[index];
                        return ListTile(
                            title: Text(pet['name']),
                            subtitle: Text('${pet['species']} - ${pet['breed'] ?? ''}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PetDetailScreen(petId: pet['id']),
                                ),
                                );
                            },
                        );
                      },
                    ),
    );
  }
}
