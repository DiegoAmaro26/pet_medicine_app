import 'package:flutter/material.dart';
import '../services/consultation_detail_service.dart';

class TestViewerScreen extends StatefulWidget {
  final String path;

  const TestViewerScreen({
    super.key,
    required this.path,
  });

  @override
  State<TestViewerScreen> createState() => _TestViewerScreenState();
}

class _TestViewerScreenState extends State<TestViewerScreen> {
  final ConsultationDetailService _service = ConsultationDetailService();

  late Future<dynamic> _fileFuture;

  bool get _isPdf => widget.path.toLowerCase().endsWith('.pdf');

  @override
  void initState() {
    super.initState();
    _fileFuture = _service.fetchProtectedFile(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba clínica')),
      body: FutureBuilder(
        future: _fileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error cargando la imagen'));
          }

          return InteractiveViewer(
            child: Image.memory(snapshot.data),
          );
        },
      ),
    );
  }
}
