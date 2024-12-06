import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'db/db_helper.dart';
import 'screens/search_medicos_screen.dart';
import 'screens/list_medicos_screen.dart';

void main() {
  runApp(MyApp());
}

//para que inserte datos de medicos
/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.insertInitialMedicos();
  runApp(MyApp());
} */

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.printTables(); // Imprime las tablas existentes
  runApp(MyApp());
} */

//para añadir mi columna que olvide jaja
/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.addColumnHorarios();
  runApp(MyApp());
} */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reserva de Citas',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/search': (context) => SearchMedicosScreen(),
        '/listMedicos': (context) => ListMedicosScreen(),
      },
    );
  }
}
