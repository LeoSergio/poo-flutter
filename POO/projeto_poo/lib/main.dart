import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Bebidas")),
        body: DataBodyWidget(objects: const [
          "La Fin Du Monde - Bock - 65 ibu",
          "Sapporo Premiume - Sour Ale - 54 ibu",
          "Duvel - Pilsner - 82 ibu"
        ]),
        // Passando a lista de ícones para o NewNavBar
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
  // Propriedade para receber os ícones
  final List<IconData> icones;

  // Construtor atualizado
  NewNavBar({this.icones = const []});

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    // Mapeando a lista de IconData para uma lista de BottomNavigationBarItem
    List<BottomNavigationBarItem> itensDaBarra = icones
        .map(
          (icone) => BottomNavigationBarItem(
            label: "Label", // Label genérico por enquanto
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

  Expanded processarUmElemento(String obj) {
    return Expanded(
      child: Center(child: Text(obj)),
    );
  }

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
  MyApp app = MyApp();
  runApp(app);
}