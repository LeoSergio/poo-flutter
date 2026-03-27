import 'package:flutter/material.dart';

// Classe simples para estruturar as opções de tema do menu
class ThemeOption {
  final String name;
  final MaterialColor swatch;

  ThemeOption({required this.name, required this.swatch});
}

// Nossa nova AppBar customizada estendendo a AppBar padrão
class MyAppBar extends AppBar {
  // Lista de opções de cores transformada em estática para ser acessada no construtor
  static final List<ThemeOption> menuCores = [
    ThemeOption(name: 'Roxo Profundo (Padrão)', swatch: Colors.deepPurple),
    ThemeOption(name: 'Vermelho', swatch: Colors.red),
    ThemeOption(name: 'Azul', swatch: Colors.blue),
    ThemeOption(name: 'Verde', swatch: Colors.green),
    ThemeOption(name: 'Laranja', swatch: Colors.orange),
  ];

  MyAppBar({super.key})
      : super(
          title: const Text("Bebidas"),
          actions: [
            PopupMenuButton<ThemeOption>(
              icon: const Icon(Icons.more_vert),
              onSelected: (ThemeOption choice) {
                print('Selecionada a cor: ${choice.name}');
                // A lógica de trocar o tema entrará aqui futuramente.
              },
              itemBuilder: (BuildContext context) {
                return menuCores.map((ThemeOption choice) {
                  return PopupMenuItem<ThemeOption>(
                    value: choice,
                    child: Text(choice.name),
                  );
                }).toList();
              },
            ),
          ],
        );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Chamando nossa AppBar modularizada
        appBar: MyAppBar(),
        body: DataBodyWidget(objects: const [
          "La Fin Du Monde - Bock - 65 ibu",
          "Sapporo Premiume - Sour Ale - 54 ibu",
          "Duvel - Pilsner - 82 ibu"
        ]),
        bottomNavigationBar: NewNavBar(icones: const [
          Icons.coffee_outlined,
          Icons.local_drink_outlined,
          Icons.flag_outlined,
        ]),
      ),
    );
  }
}

class NewNavBar extends StatelessWidget {
  final List<IconData> icones;

  NewNavBar({this.icones = const []});

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> itensDaBarra = icones
        .map(
          (icone) => BottomNavigationBarItem(
            label: "Item", // Label genérico por enquanto
            icon: Icon(icone),
          ),
        )
        .toList();

    return BottomNavigationBar(
      onTap: botaoFoiTocado,
      items: itensDaBarra,
    );
  }
}

class DataBodyWidget extends StatelessWidget {
  final List<String> objects;

  DataBodyWidget({this.objects = const []});

  @override
  Widget build(BuildContext context) {
    List<Expanded> allTheLines = objects
        .map(
          (obj) => Expanded(
            child: Center(child: Text(obj)),
          ),
        )
        .toList();

    return Column(children: allTheLines);
  }
}

void main() {
  runApp(MyApp());
}