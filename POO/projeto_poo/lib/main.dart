import 'package:flutter/material.dart';

// --- Caixa 1: A Barra de Navegação ---
class NewNavBar extends StatelessWidget {
  NewNavBar();

  void botaoFoiTocado(int index) {
    print("Tocaram no botão $index");
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: botaoFoiTocado, 
      items: const [
        BottomNavigationBarItem(label: "Cafés", icon: Icon(Icons.coffee_outlined)),
        BottomNavigationBarItem(label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),
        BottomNavigationBarItem(label: "Nações", icon: Icon(Icons.flag_outlined))
      ]
    );
  }
}

// --- Caixa 2: A Lista de Bebidas ---
class ListaDeBebidas extends StatelessWidget {
  ListaDeBebidas();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(child: Text("La Fin Du Monde - Bock - 65 ibu")),
        Expanded(child: Text("Sapporo Premiume - Sour Ale - 54 ibu")),
        Expanded(child: Text("Duvel - Pilsner - 82 ibu"))
      ]
    );
  }
}

// --- Caixa 3 (NOVA): O Aplicativo Inteiro ---
// Ela junta o MaterialApp, o Scaffold e as nossas caixas customizadas.
class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        appBar: AppBar(title: const Text("Dicas")),
        // Composição: Chamando as outras classes aqui!
        body: ListaDeBebidas(), 
        bottomNavigationBar: NewNavBar(),
      ),
    );
  }
}

// --- O Gatilho Principal ---
void main() {
  // Conforme você pediu: instanciamos o objeto e rodamos!
  MyApp app = MyApp();
  runApp(app);
  
  // Dica: Profissionais geralmente abreviam para uma linha só: 
  // runApp(MyApp());
}