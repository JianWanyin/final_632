class Usuario {
  int? id;
  String nombre;
  String email;
  String password;
  String rol;

  Usuario({
    this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.rol,
  });

  // Método para convertir un mapa a un objeto Usuario
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      rol: map['rol'] as String,
    );
  }

  // Método para convertir un objeto Usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'password': password,
      'rol': rol,
    };
  }
}
