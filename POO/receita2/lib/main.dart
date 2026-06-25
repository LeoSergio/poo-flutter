import 'package:flutter/material.dart';

// --- Caixa 4: A Barra Superior Customizada ---
class NewAppBar extends AppBar {
  NewAppBar({super.key}) : super(
    title: const Text("Dicas"), 
    centerTitle: true,
    
    // O Menu Hambúrguer entra aqui no lado esquerdo (leading)
    leading: IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => print("Abriu o Menu Lateral!"),
    ),
    
    // A Lupa entra aqui no lado direito (actions)
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => print("Abriu a Pesquisa!"),
      ),
    ],
  );
}

// --- Caixa 1: A Barra de Navegação Dinâmica ---
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

// --- Caixa 2: A Lista de Bebidas Centralizada ---
class ListaDeBebidas extends StatelessWidget {
  const ListaDeBebidas({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(child: Center(child: Text("La Fin Du Monde - Bock - 65 ibu"))),
        Expanded(child: Center(child: Text("Sapporo Premiume - Sour Ale - 54 ibu"))),
        Expanded(child: Center(child: Text("Duvel - Pilsner - 82 ibu")))
      ]
    );
  }
}

// --- Caixa 3: O Aplicativo Inteiro ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        appBar: NewAppBar(), 
        body: const ListaDeBebidas(), 
        
        // Nossa barra inferior volta a ter apenas o seu propósito principal de navegação
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

// --- O Gatilho Principal ---
void main() {
  runApp(const MyApp());
}