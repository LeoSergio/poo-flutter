import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

var dataObjects = [];

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Adicionado o print aqui
    print("no build da classe MyApp");

    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Dicas")),
        body: DataTableWidget(jsonObjects: dataObjects),
        bottomNavigationBar: NewNavBar2(),
      ),
    );
  }
}

// --- Exercício 2: A Barra usando StatefulWidget nativo ---
class NewNavBar2 extends StatefulWidget {
  // A casca do widget. Ela não guarda memória nenhuma.
  const NewNavBar2({super.key});

  @override
  State<NewNavBar2> createState() => _NewNavBar2State();
}

// O "Estado" (A memória da classe). Note o underline (_) indicando que é privada.
class _NewNavBar2State extends State<NewNavBar2> {
  // 1. Criamos a variável de estado (equivalente ao useState)
  int _selectedIndex = 1; 

  void _buttonTapped(int index) {
    print("Tocaram no botão $index");
    
    // 2. O famoso setState! 
    // É ele quem avisa ao Flutter: "Ei, mudei um dado, desenhe a tela de novo!"
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("no build da classe NewNavBar2");

    return BottomNavigationBar(
      onTap: _buttonTapped,
      currentIndex: _selectedIndex, // Usamos a nossa variável de estado aqui
      items: const [
        BottomNavigationBarItem(
          label: "Cafés",
          icon: Icon(Icons.coffee_outlined),
        ),
        BottomNavigationBarItem(
          label: "Cervejas",
          icon: Icon(Icons.local_drink_outlined),
        ),
        BottomNavigationBarItem(
          label: "Nações",
          icon: Icon(Icons.flag_outlined),
        ),
      ],
    );
  }
}

class DataTableWidget extends StatelessWidget {
  final List jsonObjects;

  DataTableWidget({this.jsonObjects = const []});

  @override
  Widget build(BuildContext context) {
    // Adicionado o print aqui
    print("no build da classe DataTableWidget");

    var columnNames = ["Nome", "Estilo", "IBU"],
        propertyNames = ["name", "style", "ibu"];

    return DataTable(
      columns: columnNames
          .map(
            (name) => DataColumn(
              label: Expanded(
                child: Text(
                  name,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          )
          .toList(),
      rows: jsonObjects
          .map(
            (obj) => DataRow(
              cells: propertyNames
                  .map((propName) => DataCell(Text(obj[propName])))
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}