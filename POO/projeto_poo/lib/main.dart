import 'package:flutter/material.dart';

// Classe simples para estruturar as opções de tema do menu
class ThemeOption {
  final String name;
  final MaterialColor swatch;

  ThemeOption({required this.name, required this.swatch});
}

class MyApp extends StatelessWidget {
  // Lista de opções de cores para o menu
  final List<ThemeOption> menuCores = [
    ThemeOption(name: 'Roxo Profundo (Padrão)', swatch: Colors.deepPurple),
    ThemeOption(name: 'Vermelho', swatch: Colors.red),
    ThemeOption(name: 'Azul', swatch: Colors.blue),
    ThemeOption(name: 'Verde', swatch: Colors.green),
    ThemeOption(name: 'Laranja', swatch: Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Mantendo o tema padrão fixo por enquanto
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Bebidas"),
          // A propriedade 'actions' recebe widgets alinhados ao final da AppBar
          actions: [
            // O widget que cria o menu de 3 pontos
            PopupMenuButton<ThemeOption>(
              // Ícone padrão de 3 pontos verticais
              icon: const Icon(Icons.more_vert), 
              
              // Função chamada quando um item é selecionado (futuro tema)
              onSelected: (ThemeOption choice) {
                print('Selecionada a cor: ${choice.name}');
                // A lógica de trocar o tema entrará aqui futuramente.
              },
              
              // Gera os itens do menu a partir da lista 'menuCores'
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
        ),
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

// --- Componentes Reutilizados (Refatorados anteriormente) ---

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