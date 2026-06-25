import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // CORREÇÃO 1: Import do HTTP

class DataService {
  final ValueNotifier<List> tableStateNotifier = ValueNotifier([]);

  void carregar(index) {
    var res = null;
    print('carregar #1 - antes de carregarCervejas');

    if (index == 1) res = carregarCervejas();
    print('carregar #2 - carregarCervejas retornou $res');
  }

  Future<void> carregarCervejas() async {
    var beersUri = Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/beer/random_beer',
      queryParameters: {'size': '5'},
    );

    // Agora o http é reconhecido graças ao import lá em cima
    var jsonString = await http.read(beersUri);
    print('carregarCervejas #2 - depois do await');

    var beersJson = jsonDecode(jsonString);

    tableStateNotifier.value = beersJson;
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
        appBar: AppBar(title: const Text("Dicas")),
        body: ValueListenableBuilder(
          valueListenable: dataService.tableStateNotifier,
          builder: (_, value, __) {
            return DataTableWidget(
              jsonObjects: value,
              propertyNames: ["name", "style", "ibu"],
              columnNames: ["Nome", "Estilo", "IBU"],
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