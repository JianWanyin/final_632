import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import 'reservar_cita.dart';

class VerHorariosScreen extends StatefulWidget {
  @override
  _VerHorariosScreenState createState() => _VerHorariosScreenState();
}

class _VerHorariosScreenState extends State<VerHorariosScreen> {
  List<Map<String, dynamic>> _medicosConHorarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarMedicosConHorarios();
  }

  Future<void> _cargarMedicosConHorarios() async {
    final medicos = await DBHelper.instance.getMedicosConHorarios();
    setState(() {
      _medicosConHorarios = medicos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios Disponibles de Médicos'),
        backgroundColor: Colors.blue[600],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _medicosConHorarios.isEmpty
              ? _buildEmptyState()
              : _buildHorariosList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No hay horarios disponibles.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildHorariosList() {
    return ListView.builder(
      itemCount: _medicosConHorarios.length,
      itemBuilder: (context, index) {
        final medico = _medicosConHorarios[index];
        return _buildMedicoCard(medico);
      },
    );
  }

  Widget _buildMedicoCard(Map<String, dynamic> medico) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue[600]),
        ),
        title: Text(
          medico['nombre'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Especialidad: ${medico['especialidad']}'),
            Text('Ubicación: ${medico['ubicacion']}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservarCitaScreen(
                  medicoId: medico['id'],
                  pacienteId: 1, // Cambiar con el ID del paciente autenticado
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Reservar'),
        ),
      ),
    );
  }
}
