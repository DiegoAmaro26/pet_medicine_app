import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoiceViewerScreen extends StatelessWidget {
  final Uint8List pdfData;

  const InvoiceViewerScreen({
    super.key,
    required this.pdfData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Factura')),
      body: SfPdfViewer.memory(pdfData),
    );
  }
}
