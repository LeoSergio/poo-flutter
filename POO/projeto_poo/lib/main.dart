import 'package:flutter/material.dart';

// --- 1. Nossos Dados (JSON Simulado) ---
// Adicionei itens extras para você testar o scroll vertical
var dataObjects = [
  {"name": "La Fin Du Monde", "style": "Bock", "ibu": "65"},
  {"name": "Sapporo Premiume", "style": "Sour Ale", "ibu": "54"},
  {"name": "Duvel", "style": "Pilsner", "ibu": "82"},
  {"name": "Guinness", "style": "Stout", "ibu": "45"},
  {"name": "Heineken", "style": "Pilsner", "ibu": "23"},
  {"name": "Colorado Índica", "style": "IPA", "ibu": "45"},
  {"name": "Brahma Extra", "style": "Lager", "ibu": "15"},
];

// --- 2. O Gatilho Principal ---
void main() {
  runApp(const MyApp());
}

// --- 3. O Maestro (O Aplicativo Inteiro) ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: NewAppBar(),
        
        // AQUI VOCÊ ESCOLHE O VISUAL!
        // Atualmente está usando a Tabela (DataBodyWidget).
        // Se quiser ver em formato de lista, comente o DataBodyWidget e descomente o MyTileWidget abaixo.
        
        body: DataBodyWidget(
          objects: dataObjects,
          columnNames: const ["Nome", "Estilo", "IBU"],
          propertyNames: const ["name", "style", "ibu"],
        ),

        /*
        body: MyTileWidget(
          objects: dataObjects,
          titleProperty: "name",
          subtitleProperty: "style",
          trailingProperty: "ibu",
        ),
        */

        bottomNavigationBar: const NewNavBar(
          icones: [
            Icon(Icons.coffee_outlined),
            Icon(Icons.local_drink_outlined),
            Icon(Icons.flag_outlined),
          ],
        ),
      ),
    );
  }
}

// --- 4. A Barra Superior (Herança) ---
class NewAppBar extends AppBar {
  NewAppBar({super.key}) : super(
    title: const Text("Dicas de Bebidas"),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => print("Menu Lateral!"),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => print("Pesquisa!"),
      ),
    ],
  );
}

// --- 5. A Barra Inferior (Componente Dinâmico) ---
class NewNavBar extends StatelessWidget {
  final List<Icon> icones;

  const NewNavBar({super.key, required this.icones});

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: botaoFoiTocado,
      type: BottomNavigationBarType.fixed,
      items: icones.map((icone) => BottomNavigationBarItem(
        icon: icone,
        label: "",
      )).toList(),
    );
  }
}

// --- 6. A Tabela Genérica (Issues 1 e 3) ---
class DataBodyWidget extends StatelessWidget {
  final List objects;
  final List<String> columnNames;
  final List<String> propertyNames;

  const DataBodyWidget({
    super.key,
    this.objects = const [],
    required this.columnNames,
    required this.propertyNames,
  });

  @override
  Widget build(BuildContext context) {
    // Solução da Issue 1: SingleChildScrollView na raiz para permitir scroll
    return SingleChildScrollView(
      child: DataTable(
        // Desenhando os cabeçalhos
        columns: columnNames.map((name) => DataColumn(
          label: Text(name, style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))
        )).toList(),
        // Desenhando as linhas e preenchendo as células
        rows: objects.map((obj) => DataRow(
          cells: propertyNames.map(
            (propName) => DataCell(Text(obj[propName].toString()))
          ).toList()
        )).toList()
      ),
    );
  }
}

// --- 7. A Lista em Tiles Genérica (Issues 2 e 4) ---
class MyTileWidget extends StatelessWidget {
  final List objects;
  final String titleProperty;
  final String subtitleProperty;
  final String trailingProperty;

  const MyTileWidget({
    super.key,
    this.objects = const [],
    required this.titleProperty,
    required this.subtitleProperty,
    required this.trailingProperty,
  });

  @override
  Widget build(BuildContext context) {
    // O ListView já possui scroll nativo
    return ListView(
      children: objects.map((obj) => ListTile(
        leading: const Icon(Icons.sports_bar, color: Colors.deepPurple), // Ícone temático
        title: Text(obj[titleProperty].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(obj[subtitleProperty].toString()),
        trailing: Text(
          "${obj[trailingProperty]} IBU", 
          style: const TextStyle(color: Colors.grey)
        ),
      )).toList(),
    );
  }
}