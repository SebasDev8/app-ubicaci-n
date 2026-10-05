import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();

  String _location = 'consultar ubicación.';
  bool _loadingLocation = false;

  Future<void> _getLocation() async {
    setState(() {
      _loadingLocation = true;
    });

    final position =
        await _locationService.getCurrentLocation();

    if (!mounted) return;

    setState(() {
      _loadingLocation = false;

      if (position != null) {
        _location =
            'Latitud: ${position.latitude.toStringAsFixed(5)}\n'
            'Longitud: ${position.longitude.toStringAsFixed(5)}';
      } else {
        _location = 'No fue posible obtener la ubicación.';
      }
    });
  }

  Future<void> _logout() async {
    await context.read<AppState>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appState.username}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                const SizedBox(height: 32),

                const Divider(),

                const SizedBox(height: 24),

                const Text(
                  'Ubicación',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _location,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed:
                      _loadingLocation ? null : _getLocation,
                  icon: _loadingLocation
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.location_on_outlined,
                        ),
                  label: Text(
                    _loadingLocation
                        ? 'Obteniendo ubicación...'
                        : 'Obtener ubicación',
                  ),
                ),

                const SizedBox(height: 32),

                const Divider(),

                const SizedBox(height: 24),

                const SizedBox(height: 16),

                const SizedBox(height: 12),

                const SizedBox(height: 32),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar sesión'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}