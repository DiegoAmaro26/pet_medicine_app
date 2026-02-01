import 'package:flutter/material.dart';
import '../services/consultation_detail_service.dart';
import 'test_viewer_screen.dart';

class ConsultationDetailScreen extends StatefulWidget {
  final int consultationId;

  const ConsultationDetailScreen({
    super.key,
    required this.consultationId,
  });

  @override
  State<ConsultationDetailScreen> createState() =>
      _ConsultationDetailScreenState();
}

class _ConsultationDetailScreenState
    extends State<ConsultationDetailScreen> {
  final ConsultationDetailService _service = ConsultationDetailService();

  Map<String, dynamic>? _consultation;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConsultation();
  }

  Future<void> _loadConsultation() async {
    try {
      final data =
          await _service.getConsultation(widget.consultationId);

      setState(() {
        _consultation = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error cargando la consulta';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Consulta')),
        body: Center(child: Text(_error!)),
      );
    }

    final consultation = _consultation!;
    final vet = consultation['vet'];
    final List tests = consultation['tests'] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Consulta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TIPO DE CONSULTA
            Text(
              consultation['type'] ?? 'Consulta',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            /// FECHA
            Text(
              'Fecha: ${consultation['date'] ?? '-'}',
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(height: 32),

            _section('Motivo', consultation['reason']),
            _section('Diagnóstico', consultation['diagnosis']),
            _section('Tratamiento', consultation['treatment']),

            /// PRUEBAS REALIZADAS
            if (tests.isNotEmpty) ...[
              const Divider(height: 32),
              Text(
                'Pruebas realizadas',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              Column(
                children: tests.map<Widget>((test) {
                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(test.split('/').last),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TestViewerScreen(path: test),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ],

            const Divider(height: 32),

            /// VETERINARIO
            Text(
              'Veterinario',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),

            Text(vet != null ? vet['name'] ?? '-' : 'No especificado'),
            Text(vet != null ? vet['email'] ?? '' : ''),
            if (vet != null && vet['license'] != null)
              Text('Nº colegiado: ${vet['license']}'),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String? content) {
    if (content == null || content.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}
