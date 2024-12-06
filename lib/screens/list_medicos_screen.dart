import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class ListMedicosScreen extends StatefulWidget {
  @override
  _ListMedicosScreenState createState() => _ListMedicosScreenState();
}

class _ListMedicosScreenState extends State<ListMedicosScreen> {
  List<Map<String, dynamic>> _medicos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getMedicos();
  }

  Future<void> _getMedicos() async {
    final medicos = await DBHelper.instance.getMedicos();
    setState(() {
      _medicos = medicos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Médicos'),
        backgroundColor: Colors.blue[600],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _medicos.isEmpty
              ? _buildEmptyState()
              : _buildMedicosList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No hay médicos en la base de datos.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicosList() {
    return ListView.builder(
      itemCount: _medicos.length,
      itemBuilder: (context, index) {
        final medico = _medicos[index];
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
        subtitle: Text(
          '${medico['especialidad']} - ${medico['ubicacion']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
