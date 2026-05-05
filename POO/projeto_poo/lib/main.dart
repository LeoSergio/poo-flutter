import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  // 1. Voltamos para o Estado Inteligente (Map) que guarda dados e colunas juntos!
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    "dataObjects": [],
    "columnNames": [],
    "propertyNames": []
  });

  // 2. O Maestro das chamadas
  void carregar(index) {
    if (index == 0) carregarCafes();
    if (index == 1) carregarCervejas();
    if (index == 2) carregarNacoes();
  }

  // 3. Chamada da API de Cervejas
  Future<void> carregarCervejas() async {
    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/beer/random_beer',
      queryParameters: {'size': '5'},
    );

    var jsonString = await http.read(beersUri);
    var beersJson = jsonDecode(jsonString);

    tableStateNotifier.value = {
      "dataObjects": beersJson,
      "columnNames": ["Nome", "Estilo", "IBU"],
      "propertyNames": ["name", "style", "ibu"] // Chaves reais da API de Cervejas
    };
  }

  // 4. Chamada da API de Cafés
  Future<void> carregarCafes() async {
    var coffeeUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/coffee/random_coffee',
      queryParameters: {'size': '5'},
    );

    var jsonString = await http.read(coffeeUri);
    var coffeeJson = jsonDecode(jsonString);

    tableStateNotifier.value = {
      "dataObjects": coffeeJson,
      "columnNames": ["Nome do Blend", "Origem", "Intensificador"],
      "propertyNames": ["blend_name", "origin", "intensifier"] // Chaves reais da API de Cafés
    };
  }

  // 5. Chamada da API de Nações
  Future<void> carregarNacoes() async {
    var nationUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/nation/random_nation',
      queryParameters: {'size': '5'},
    );

    var jsonString = await http.read(nationUri);
    var nationJson = jsonDecode(jsonString);

    tableStateNotifier.value = {
      "dataObjects": nationJson,
      "columnNames": ["Nacionalidade", "Capital", "Idioma"],
      "propertyNames": ["nationality", "capital", "language"] // Chaves reais da API de Nações
    };
  }
}

final dataService = DataService();

void main() {
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Dicas da Web")),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            // Proteção para a primeira vez que o app abre (lista vazia)
            if (value["dataObjects"].isEmpty) {
              return const Center(child: Text("Clique num botão para buscar na internet!"));
            }

            // Desempacotando o estado dinâmico
            return DataTableWidget(
              jsonObjects: value["dataObjects"],
              columnNames: value["columnNames"],
              propertyNames: value["propertyNames"],
            );
          },
        ),
        bottomNavigationBar: NewNavBar(
          itemSelectedCallback: dataService.carregar,
        ),
      ),
    );
  }
}

// ... As classes NewNavBar e DataTableWidget continuam iguais às que eu te mandei na correção anterior!

class NewNavBar extends HookWidget {
  final _itemSelectedCallback;

  // CORREÇÃO 2: Sintaxe corrigida para a função vazia (adicionado o ponto e vírgula e o '(_)')
  NewNavBar({itemSelectedCallback})
      : _itemSelectedCallback = itemSelectedCallback ?? ((_) {});

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;
        _itemSelectedCallback(index);
      },
      currentIndex: state.value,
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
  final List<String> columnNames;
  final List<String> propertyNames;

  DataTableWidget({
    this.jsonObjects = const [],
    this.columnNames = const ["Nome", "Estilo", "IBU"],
    this.propertyNames = const ["name", "style", "ibu"],
  });

  @override
  Widget build(BuildContext context) {
    // CORREÇÃO 3: SingleChildScrollView no lugar de Expanded dentro da tabela
    return SingleChildScrollView(
      child: DataTable(
        columns: columnNames
            .map(
              (name) => DataColumn(
                label: Text(
                  name,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            )
            .toList(),
        rows: jsonObjects
            .map(
              (obj) => DataRow(
                cells: propertyNames
                    // CORREÇÃO 4: Convertendo tudo para String pra evitar quebrar com números
                    .map((propName) => DataCell(Text(obj[propName]?.toString() ?? "")))
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}