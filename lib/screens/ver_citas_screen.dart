import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import 'actualizar_cita_screen.dart';

class VerCitasScreen extends StatefulWidget {
  @override
  _VerCitasScreenState createState() => _VerCitasScreenState();
}

class _VerCitasScreenState extends State<VerCitasScreen> {
  List<Map<String, dynamic>> _citas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCitas();
  }

  Future<void> _cargarCitas() async {
    final citas = await DBHelper.instance.getCitas();
    setState(() {
      _citas = citas;
      _isLoading = false;
    });
  }

  Future<void> _cancelarCita(int citaId) async {
    await DBHelper.instance.cancelarCita(citaId);
    _cargarCitas();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cita cancelada con éxito')),
    );
  }

  Future<void> _actualizarCita(int citaId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActualizarCitaScreen(citaId: citaId),
      ),
    ).then((_) => _cargarCitas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas Reservadas'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _citas.isEmpty
              ? Center(
                  child: Text(
                    'No tienes citas reservadas.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : _buildCitasList(),
    );
  }

  Widget _buildCitasList() {
    return ListView.builder(
      itemCount: _citas.length,
      itemBuilder: (context, index) {
        final cita = _citas[index];
        return _buildCitaCard(cita);
      },
    );
  }

  Widget _buildCitaCard(Map<String, dynamic> cita) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.calendar_today, color: Colors.blue[600]),
        ),
        title: Text(
          'Dr. ${cita['medico_nombre']}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Fecha: ${cita['fecha']}\nHora: ${cita['hora']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () => _actualizarCita(cita['id']),
            ),
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () => _cancelarCita(cita['id']),
            ),
          ],
        ),
      ),
    );
  }
}
