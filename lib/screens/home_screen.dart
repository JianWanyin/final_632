import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../db/db_helper.dart';
import 'search_medicos_screen.dart';
import 'ver_citas_screen.dart';
import 'ver_horarios_screen.dart';
import 'crud_medico_screen.dart';

class HomeScreen extends StatelessWidget {
  final Usuario usuario;

  HomeScreen({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, ${usuario.nombre}!'),
        backgroundColor: Colors.red[300], // Color rojo claro para AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(usuario),
              SizedBox(height: 20),
              if (usuario.rol == 'paciente') ..._buildPacienteOptions(context),
              if (usuario.rol == 'médico') ..._buildMedicoOptions(context),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400], // Color rojo claro para botón
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Cerrar sesión', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Usuario usuario) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${usuario.nombre}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tu rol es: ${usuario.rol}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPacienteOptions(BuildContext context) {
    return [
      _buildOptionCard(
        context,
        title: 'Buscar Médicos',
        icon: Icons.search,
        onTap: () => Navigator.pushNamed(context, '/search'),
      ),
      _buildOptionCard(
        context,
        title: 'Ver Médicos',
        icon: Icons.list,
        onTap: () => Navigator.pushNamed(context, '/listMedicos'),
      ),
      _buildOptionCard(
        context,
        title: 'Ver Citas Reservadas',
        icon: Icons.calendar_today,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerCitasScreen()),
        ),
      ),
      _buildOptionCard(
        context,
        title: 'Ver Horarios de Médicos',
        icon: Icons.access_time,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerHorariosScreen()),
        ),
      ),
    ];
  }

  List<Widget> _buildMedicoOptions(BuildContext context) {
    return [
      _buildOptionCard(
        context,
        title: 'Buscar Médicos',
        icon: Icons.search,
        onTap: () => Navigator.pushNamed(context, '/search'),
      ),
      _buildOptionCard(
        context,
        title: 'Gestionar Médicos',
        icon: Icons.settings,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CrudMedicoScreen()),
        ),
      ),
      _buildOptionCard(
        context,
        title: 'Ver Citas Reservadas',
        icon: Icons.calendar_today,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerCitasScreen()),
        ),
      ),
      _buildOptionCard(
        context,
        title: 'Ver Médicos',
        icon: Icons.list,
        onTap: () => Navigator.pushNamed(context, '/listMedicos'),
      ),
      _buildOptionCard(
        context,
        title: 'Ver Horarios de Médicos',
        icon: Icons.access_time,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerHorariosScreen()),
        ),
      ),
    ];
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.red[300]), // Iconos en rojo claro
        title: Text(title, style: TextStyle(fontSize: 16)),
        onTap: onTap,
      ),
    );
  }
}
