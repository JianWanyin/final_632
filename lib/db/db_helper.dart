import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reserva_citas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        email TEXT,
        password TEXT,
        rol TEXT
      );
    ''');
    await db.execute('''
    CREATE TABLE medicos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      especialidad TEXT NOT NULL,
      ubicacion TEXT NOT NULL,
      horarios TEXT NOT NULL
    );
  ''');

    await db.execute('''
      CREATE TABLE horarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medico_id INTEGER,
        fecha TEXT,
        hora TEXT,
        FOREIGN KEY (medico_id) REFERENCES medicos (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE citas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        paciente_id INTEGER,
        medico_id INTEGER,
        fecha TEXT,
        hora TEXT,
        estado TEXT,
        FOREIGN KEY (paciente_id) REFERENCES usuarios (id),
        FOREIGN KEY (medico_id) REFERENCES medicos (id)
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<List<Map<String, dynamic>>> fetchUsuarios() async {
    final db = await instance.database;
    return await db.query('usuarios'); // Recuperar todos los usuarios
  }

  Future<Usuario?> getUsuario(String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return Usuario.fromMap(result.first);
    } else {
      return null; // Usuario no encontrado
    }
  }

  Future<int> insertMedico(Map<String, dynamic> medico) async {
    final db = await instance.database;
    return await db.insert('medicos', medico);
  }

  Future<List<Map<String, dynamic>>> searchMedicos(String query) async {
    final db = await instance.database;
    return await db.query(
      'medicos',
      where: 'nombre LIKE ? OR especialidad LIKE ? OR ubicacion LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
  }

  Future<void> insertInitialMedicos() async {
    final medicos = [
      {
        'nombre': 'Dr. Juan Pérez',
        'especialidad': 'Cardiología',
        'ubicacion': 'Centro Médico A',
        'horarios': 'Lunes-Viernes: 9am-1pm',
      },
      {
        'nombre': 'Dra. María López',
        'especialidad': 'Dermatología',
        'ubicacion': 'Clínica B',
        'horarios': 'Martes-Jueves: 2pm-6pm',
      },
      {
        'nombre': 'Dr. Carlos Gómez',
        'especialidad': 'Pediatría',
        'ubicacion': 'Hospital C',
        'horarios': 'Lunes-Sábado: 8am-12pm',
      },
    ];

    for (var medico in medicos) {
      await insertMedico(medico);
    }
  }

  Future<List<Map<String, dynamic>>> getMedicos() async {
    final db = await instance.database;
    return await db.query('medicos');
  }

  Future<int> addMedicoManual(String nombre, String especialidad,
      String ubicacion, String horarios) async {
    final db =
        await instance.database; // Asegúrate de que se obtiene la base de datos
    final data = {
      'nombre': nombre,
      'especialidad': especialidad,
      'ubicacion': ubicacion,
      'horarios': horarios,
    };

    return await db.insert('medicos', data);
  }

  Future<void> printTables() async {
    final db = await instance.database;
    final tables =
        await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print('Tablas en la base de datos: $tables');
  }

  //añadir la columna que me falto jeje
  Future<void> addColumnHorarios() async {
    final db = await instance.database;
    await db.execute('ALTER TABLE medicos ADD COLUMN horarios TEXT');
    print('Columna horarios añadida a la tabla medicos.');
  }

  Future<int> reservarCita(
      int pacienteId, int medicoId, String fecha, String hora) async {
    final db = await instance.database;
    return await db.insert('citas', {
      'paciente_id': pacienteId,
      'medico_id': medicoId,
      'fecha': fecha,
      'hora': hora,
      'estado': 'pendiente',
    });
  }

  // Obtener citas por paciente
  Future<List<Map<String, dynamic>>> getCitasPorPaciente(int pacienteId) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT citas.id, citas.fecha, citas.hora, medicos.nombre AS medico_nombre
    FROM citas
    INNER JOIN medicos ON citas.medico_id = medicos.id
    WHERE citas.paciente_id = ?
  ''', [pacienteId]);

    return result;
  }

  Future<List<Map<String, dynamic>>> getCitasPorMedico(int medicoId) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT citas.id, citas.fecha, citas.hora, usuarios.nombre AS paciente_nombre
    FROM citas
    INNER JOIN usuarios ON citas.paciente_id = usuarios.id
    WHERE citas.medico_id = ?
  ''', [medicoId]);

    return result;
  }

  // Obtener una cita por ID
  Future<Map<String, dynamic>> getCitaById(int citaId) async {
    final db = await database;
    final result =
        await db.query('citas', where: 'id = ?', whereArgs: [citaId]);
    return result.first;
  }

  Future<List<Map<String, dynamic>>> getCitas() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> citas = await db.rawQuery('''
      SELECT citas.*, medicos.nombre AS medico_nombre
      FROM citas
      JOIN medicos ON citas.medico_id = medicos.id
    ''');
    return citas;
  }

  Future<void> cancelarCita(int citaId) async {
    final db = await instance.database;
    await db.delete(
      'citas',
      where: 'id = ?',
      whereArgs: [citaId],
    );
  }

  // Actualizar cita
  Future<void> actualizarCita(int citaId, String nuevaHora) async {
    final db = await instance.database;
    await db.update(
      'citas',
      {'hora': nuevaHora},
      where: 'id = ?',
      whereArgs: [citaId],
    );
  }
  /* Future<int> actualizarCita(int citaId, String nuevaHora) async {
    final db = await database;
    return await db.update(
      'citas',
      {'hora': nuevaHora},
      where: 'id = ?',
      whereArgs: [citaId],
    );
  } */

  Future<List<Map<String, dynamic>>> getMedicosConHorarios() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> medicos = await db.rawQuery('''
      SELECT medicos.id, medicos.nombre, medicos.especialidad, medicos.ubicacion, medicos.horarios
      FROM medicos
    ''');
    return medicos;
  }

  Future<int> eliminarMedico(int id) async {
    final db = await instance.database;
    return await db.delete(
      'medicos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> actualizarMedico(int id, String nombre, String especialidad,
      String ubicacion, String horarios) async {
    final db = await instance.database;
    final data = {
      'nombre': nombre,
      'especialidad': especialidad,
      'ubicacion': ubicacion,
      'horarios': horarios,
    };
    await db.update(
      'medicos',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
