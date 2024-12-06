import 'package:flutter/material.dart';
import '../db/db_helper.dart';
import 'reservar_cita.dart';

class SearchMedicosScreen extends StatefulWidget {
  @override
  _SearchMedicosScreenState createState() => _SearchMedicosScreenState();
}

class _SearchMedicosScreenState extends State<SearchMedicosScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchMedicos(String query) async {
    setState(() {
      _isLoading = true;
    });

    final results = await DBHelper.instance.searchMedicos(query);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Médicos'),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 20),
            _isLoading ? _buildLoadingIndicator() : _buildResultsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Buscar por nombre, especialidad o ubicación',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            if (_searchController.text.trim().isNotEmpty) {
              _searchMedicos(_searchController.text);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildResultsList() {
    return Expanded(
      child: _searchResults.isEmpty
          ? Center(
              child: Text(
                'No se encontraron resultados.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final medico = _searchResults[index];
                return _buildMedicoCard(medico);
              },
            ),
    );
  }

  Widget _buildMedicoCard(Map<String, dynamic> medico) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue[600]),
        ),
        title: Text(medico['nombre'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${medico['especialidad']} - ${medico['ubicacion']}'),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservarCitaScreen(
                  medicoId: medico['id'],
                  pacienteId:
                      1, // Cambia esto por el ID del paciente autenticado
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
