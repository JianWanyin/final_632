import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class CrudMedicoScreen extends StatefulWidget {
  @override
  _CrudMedicoScreenState createState() => _CrudMedicoScreenState();
}

class _CrudMedicoScreenState extends State<CrudMedicoScreen> {
  final _nombreController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _horariosController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _medicos = [];

  @override
  void initState() {
    super.initState();
    _cargarMedicos();
  }

  Future<void> _cargarMedicos() async {
    final medicos = await DBHelper.instance.getMedicos();
    setState(() {
      _medicos = medicos;
    });
  }

  Future<void> _agregarMedico() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final especialidad = _especialidadController.text;
      final ubicacion = _ubicacionController.text;
      final horarios = _horariosController.text;

      await DBHelper.instance
          .addMedicoManual(nombre, especialidad, ubicacion, horarios);
      _cargarMedicos();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Médico agregado correctamente')),
      );
    }
  }

  Future<void> _eliminarMedico(int id) async {
    await DBHelper.instance.eliminarMedico(id);
    _cargarMedicos();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Médico eliminado')),
    );
  }

  Future<void> _actualizarMedico(int id) async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final especialidad = _especialidadController.text;
      final ubicacion = _ubicacionController.text;
      final horarios = _horariosController.text;

      await DBHelper.instance
          .actualizarMedico(id, nombre, especialidad, ubicacion, horarios);
      _cargarMedicos();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Médico actualizado correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestionar Médicos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMedicoList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMedicoList() {
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
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.person, color: Colors.blue[600]),
        ),
        title: Text(medico['nombre'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${medico['especialidad']} - ${medico['ubicacion']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                _nombreController.text = medico['nombre'];
                _especialidadController.text = medico['especialidad'];
                _ubicacionController.text = medico['ubicacion'];
                _horariosController.text = medico['horarios'];
                _showFormDialog(isEdit: true, medicoId: medico['id']);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _eliminarMedico(medico['id']),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showFormDialog({bool isEdit = false, int? medicoId}) async {
    if (!isEdit) {
      _nombreController.clear();
      _especialidadController.clear();
      _ubicacionController.clear();
      _horariosController.clear();
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Actualizar Médico' : 'Agregar Médico'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(_nombreController, 'Nombre del Médico'),
                _buildTextField(_especialidadController, 'Especialidad'),
                _buildTextField(_ubicacionController, 'Ubicación'),
                _buildTextField(_horariosController, 'Horarios'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (isEdit && medicoId != null) {
                _actualizarMedico(medicoId);
              } else {
                _agregarMedico();
              }
            },
            child: Text(isEdit ? 'Actualizar' : 'Agregar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }
}
