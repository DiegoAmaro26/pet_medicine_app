import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PetMedicineApp());
}

class PetMedicineApp extends StatelessWidget {
  const PetMedicineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
