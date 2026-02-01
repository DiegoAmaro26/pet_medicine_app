import 'package:flutter/material.dart';
import '../services/pet_service.dart';
import '../widgets/upcoming_appointments_section.dart';
import '../theme/app_theme.dart';
import 'pet_detail_screen.dart';
import 'invoices_screen.dart';
import 'profile_screen.dart';
import '../theme/app_icons.dart';
import '../utils/launcher_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PetService _petService = PetService();
  late Future<Map<String, dynamic>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _petsFuture = _petService.getPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🐶 HEADER COMPACTO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 48, bottom: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 72,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PetMedicine',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🐾 MASCOTAS
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Mascotas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            FutureBuilder<Map<String, dynamic>>(
              future: _petsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Error cargando mascotas'),
                  );
                }

                final pets = snapshot.data!['data'] as List<dynamic>;

                if (pets.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No tienes mascotas registradas'),
                  );
                }

                return Column(
                  children: pets.map((pet) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            AppIcons.pets,
                            size: 26,
                            color: AppTheme.primaryColor,
                          ),
                          title: Text(pet['name']),
                          subtitle: Text(
                            '${pet['species']} - ${pet['breed'] ?? ''}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PetDetailScreen(petId: pet['id']),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const Divider(height: 32),

            /// 📅 PRÓXIMAS CITAS
            const UpcomingAppointmentsSection(),

            const Divider(height: 32),

            /// 🧾 FACTURAS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    AppIcons.invoices, // o AppIcons.profile
                    size: 26,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text(
                    'Facturas',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const InvoicesScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// 👤 PERFIL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    AppIcons.profile,
                    size: 26,
                    color: AppTheme.primaryColor,
                  ),
                  title: const Text(
                    'Perfil',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// 📞 CONTACTO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Contacto',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// 🏥 NOMBRE
                      Row(
                        children: const [
                          Icon(Icons.local_hospital, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Clínica Veterinaria San Jorge',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 📍 DIRECCIÓN
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'C/ Infanta Mercedes 79, Madrid',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 📞 TELÉFONO
                      InkWell(
                        onTap: () {
                          LauncherUtils.callPhone('912345678');
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.phone, color: AppTheme.primaryColor),
                            SizedBox(width: 8),
                            Text(
                              '912 345 678',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ✉️ EMAIL (opcional)
                      InkWell(
                        onTap: () {
                          LauncherUtils.sendEmail('info@vetsanjorge.es');
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.email, color: AppTheme.primaryColor),
                            SizedBox(width: 8),
                            Text(
                              'info@vetsanjorge.es',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
