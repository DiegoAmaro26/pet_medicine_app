import 'package:flutter/material.dart';
import '../services/appointment_service.dart';
import '../theme/app_icons.dart';
import '../theme/app_theme.dart';

class UpcomingAppointmentsSection extends StatefulWidget {
  const UpcomingAppointmentsSection({super.key});

  @override
  State<UpcomingAppointmentsSection> createState() =>
      _UpcomingAppointmentsSectionState();
}

class _UpcomingAppointmentsSectionState
    extends State<UpcomingAppointmentsSection> {
  final AppointmentService _service = AppointmentService();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getUpcomingAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          /// 📅 TÍTULO CENTRADO
          Center(
            child: Text(
              'Próximas citas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          const SizedBox(height: 12),

          FutureBuilder<List<dynamic>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Text('Error cargando citas');
              }

              final appointments = snapshot.data ?? [];

              if (appointments.isEmpty) {
                return const Text('No tienes citas próximas');
              }

              return Column(
                children: appointments.map((appointment) {
                  final pet = appointment['pet'];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          AppIcons.appointments,
                          color: AppTheme.primaryColor,
                        ),
                        title: Text(
                          '${appointment['appointment_date']} · '
                          '${appointment['appointment_time'].substring(0, 5)}',
                        ),
                        subtitle: Text(
                          '${appointment['reason']} · ${pet['name']}',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
