import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class ActualizarCitaScreen extends StatefulWidget {
  final int citaId;

  ActualizarCitaScreen({required this.citaId});

  @override
  _ActualizarCitaScreenState createState() => _ActualizarCitaScreenState();
}

class _ActualizarCitaScreenState extends State<ActualizarCitaScreen> {
  final _horaController = TextEditingController();
  String _nuevaHora = '';

  @override
  void initState() {
    super.initState();
    _cargarCita();
  }

  Future<void> _cargarCita() async {
    final cita = await DBHelper.instance.getCitaById(widget.citaId);
    setState(() {
      _nuevaHora = cita['hora'];
      _horaController.text = _nuevaHora;
    });
  }

  Future<void> _actualizarCita() async {
    final nuevaHora = _horaController.text.trim();
    if (nuevaHora.isNotEmpty) {
      try {
        await DBHelper.instance.actualizarCita(widget.citaId, nuevaHora);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita actualizada con éxito')),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la cita: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingrese una hora válida')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Cita'),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actualizar Hora de la Cita',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            _buildHoraInputField(),
            Spacer(),
            _buildActualizarButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHoraInputField() {
    return TextField(
      controller: _horaController,
      decoration: InputDecoration(
        labelText: 'Nueva Hora (HH:mm)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.access_time, color: Colors.blue[600]),
      ),
      keyboardType: TextInputType.datetime,
    );
  }

  Widget _buildActualizarButton() {
    return ElevatedButton(
      onPressed: _actualizarCita,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Center(
        child: Text(
          'Actualizar Cita',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
