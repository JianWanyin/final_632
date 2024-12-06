import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class ReservarCitaScreen extends StatefulWidget {
  final int medicoId; // ID del médico seleccionado
  final int pacienteId; // ID del paciente que está haciendo la reserva

  ReservarCitaScreen({required this.medicoId, required this.pacienteId});

  @override
  _ReservarCitaScreenState createState() => _ReservarCitaScreenState();
}

class _ReservarCitaScreenState extends State<ReservarCitaScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _reservarCita() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor selecciona una fecha y hora.')),
      );
      return;
    }

    String fecha =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    String hora =
        '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';

    try {
      int id = await DBHelper.instance.reservarCita(
        widget.pacienteId,
        widget.medicoId,
        fecha,
        hora,
      );
      if (id > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita reservada con éxito!')),
        );
        Navigator.pop(context); // Regresar a la pantalla anterior
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reservar la cita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Cita'),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDateSelector(),
            SizedBox(height: 16.0),
            _buildTimeSelector(),
            Spacer(),
            _buildReserveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return ElevatedButton.icon(
      onPressed: _selectDate,
      icon: Icon(Icons.calendar_today, color: Colors.white),
      label: Text(
        _selectedDate == null
            ? 'Seleccionar Fecha'
            : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return ElevatedButton.icon(
      onPressed: _selectTime,
      icon: Icon(Icons.access_time, color: Colors.white),
      label: Text(
        _selectedTime == null
            ? 'Seleccionar Hora'
            : 'Hora: ${_selectedTime!.format(context)}',
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }

  Widget _buildReserveButton() {
    return ElevatedButton(
      onPressed: _reservarCita,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      child: Text(
        'Reservar Cita',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
