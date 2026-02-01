import 'package:flutter/material.dart';
import '../services/invoice_service.dart';
import 'invoice_viewer_screen.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final InvoiceService _service = InvoiceService();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Facturas')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error cargando facturas'));
          }

          final invoices = snapshot.data!;

          if (invoices.isEmpty) {
            return const Center(child: Text('No hay facturas'));
          }

          return ListView.separated(
            itemCount: invoices.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final invoice = invoices[index];

              return ListTile(
                leading: const Icon(Icons.description),
                title: Text('Factura #${invoice['id']}'),
                subtitle: Text('Fecha: ${invoice['date'] ?? '-'}'),
                trailing: Text(
                  '${invoice['total']} €',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  final pdfData =
                      await _service.downloadInvoicePdf(invoice['id']);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InvoiceViewerScreen(pdfData: pdfData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
