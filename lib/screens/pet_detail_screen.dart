import 'package:flutter/material.dart';
import '../services/pet_detail_service.dart';
import '../services/consultation_service.dart';
import 'consultation_detail_screen.dart';

class PetDetailScreen extends StatefulWidget {
  final int petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  final PetDetailService _petService = PetDetailService();
  final ConsultationService _consultationService = ConsultationService();

  Map<String, dynamic>? _pet;
  List<dynamic> _consultations = [];

  bool _isLoadingPet = true;
  bool _isLoadingConsultations = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPet();
    _loadConsultations();
  }

  Future<void> _loadPet() async {
    try {
      final response = await _petService.getPet(widget.petId);

      setState(() {
        _pet = response['data'];
        _isLoadingPet = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error cargando la mascota';
        _isLoadingPet = false;
      });
    }
  }

  Future<void> _loadConsultations() async {
    try {
      final data =
          await _consultationService.getConsultations(widget.petId);

      setState(() {
        _consultations = data;
        _isLoadingConsultations = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingConsultations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de mascota'),
      ),
      body: _isLoadingPet
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Datos básicos de la mascota
                      Text(
                        _pet!['name'],
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Especie: ${_pet!['species']}'),
                      Text('Raza: ${_pet!['breed'] ?? '-'}'),
                      Text('Sexo: ${_pet!['sex']}'),
                      Text('Nacimiento: ${_pet!['birthDate'] ?? '-'}'),

                        const SizedBox(height: 24),

                        const Text(
                        'Historial clínico',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                        ),
                        ),

                        const SizedBox(height: 12),

                        _isLoadingConsultations
                            ? const Center(child: CircularProgressIndicator())
                            : _consultations.isEmpty
                                ? const Text('No hay registros clínicos')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _consultations.length,
                                    itemBuilder: (context, index) {
                                    final c = _consultations[index];
                                    return Card(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                            title: Text(c['reason'] ?? 'Consulta'),
                                            subtitle: Text('${c['type']} · ${c['created_at']}'),
                                            trailing: const Icon(Icons.chevron_right),
                                            onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                builder: (_) => ConsultationDetailScreen(
                                                    consultationId: c['id'],
                                                ),
                                                ),
                                            );
                                            },
                                        ),
                                        );
                                    },
                                ),

                    ],
                  ),
                ),
    );
  }
}
