import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataService{

  final ValueNotifier<List> tableStateNotifier = new ValueNotifier([]);

  

  void carregar(int index) {
    if (index == 0) {
      carregarCafes();
    } else if (index == 1) {
      carregarCervejas();
    } else if (index == 2) {
      carregarNacoes();
    }
  }

  void carregarCervejas() {
    tableStateNotifier.value = [
      {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
      {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
      {"name": "Duvel", "style": "Pilsner", "ibu": "82"}
    ];
  }

  void carregarCafes() {
    // Usando "style" e "ibu" obrigatoriamente para a tabela não quebrar (por enquanto)
    tableStateNotifier.value = [
      {"name": "Espresso Tradicional", "style": "Forte", "ibu": "12"},
      {"name": "Cappuccino", "style": "Com Leite", "ibu": "5"},
      {"name": "Mocha", "style": "Com Chocolate", "ibu": "8"}
    ];
  }

  void carregarNacoes() {
    // Usando "ibu" como uma brincadeira para representar algo numérico (ex: população em milhões)
    tableStateNotifier.value = [
      {"name": "Brasil", "style": "América do Sul", "ibu": "214"},
      {"name": "Japão", "style": "Ásia", "ibu": "125"},
      {"name": "Alemanha", "style": "Europa", "ibu": "83"}
    ];
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
        bottomNavigationBar: NewNavBar(itemSelectedCallback: dataService.carregar),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  var itemSelectedCallback; 

  NewNavBar({this.itemSelectedCallback}) {
    itemSelectedCallback ??= (_) {}; // Correção de segurança: adicionei o (_) para aceitar o parâmetro index
  }

  @override
  Widget build(BuildContext context) {
    var state = useState(1);

    return BottomNavigationBar(
      onTap: (index) {
        state.value = index;           // 1. Atualiza o visual (qual botão tá selecionado)
        itemSelectedCallback(index);   // 2. Avisa o DataService para fazer a mágica dele!
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
    // CORREÇÃO 2: Removido o Expanded de dentro da DataColumn
    // e adicionado um SingleChildScrollView para evitar transbordamento de tela
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
                    // CORREÇÃO 3: Prevenção de NullPointerException (.toString() ?? "")
                    // Se faltar um dado no JSON, a célula fica vazia em vez de quebrar o app!
                    .map(
                      (propName) =>
                          DataCell(Text(obj[propName]?.toString() ?? "")),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
