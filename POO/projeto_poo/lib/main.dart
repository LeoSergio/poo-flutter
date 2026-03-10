import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      fontFamily: 'Georgia',
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Filmes Favoritos"),
      ),
      // Aqui está a caixa mágica que habilita o scroll!
      body: SingleChildScrollView(
        child: Center(
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Título", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Gênero", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Nota", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            // Agora com dados suficientes para ultrapassar o limite da tela
            rows: const [
              DataRow(cells: [DataCell(Text("O Poderoso Chefão")), DataCell(Text("Crime")), DataCell(Text("9.2"))]),
              DataRow(cells: [DataCell(Text("Interestelar")), DataCell(Text("Ficção")), DataCell(Text("8.7"))]),
              DataRow(cells: [DataCell(Text("Pulp Fiction")), DataCell(Text("Crime")), DataCell(Text("8.9"))]),
              DataRow(cells: [DataCell(Text("O Senhor dos Anéis")), DataCell(Text("Fantasia")), DataCell(Text("9.0"))]),
              DataRow(cells: [DataCell(Text("Matrix")), DataCell(Text("Ficção")), DataCell(Text("8.7"))]),
              DataRow(cells: [DataCell(Text("Clube da Luta")), DataCell(Text("Drama")), DataCell(Text("8.8"))]),
              DataRow(cells: [DataCell(Text("Forrest Gump")), DataCell(Text("Drama")), DataCell(Text("8.8"))]),
              DataRow(cells: [DataCell(Text("A Origem")), DataCell(Text("Ficção")), DataCell(Text("8.8"))]),
              DataRow(cells: [DataCell(Text("O Iluminado")), DataCell(Text("Terror")), DataCell(Text("8.4"))]),
              DataRow(cells: [DataCell(Text("Gladiador")), DataCell(Text("Ação")), DataCell(Text("8.5"))]),
              DataRow(cells: [DataCell(Text("Parasita")), DataCell(Text("Suspense")), DataCell(Text("8.5"))]),
              DataRow(cells: [DataCell(Text("De Volta para o Futuro")), DataCell(Text("Ficção")), DataCell(Text("8.5"))]),
              DataRow(cells: [DataCell(Text("O Rei Leão")), DataCell(Text("Animação")), DataCell(Text("8.5"))]),
              DataRow(cells: [DataCell(Text("Cidade de Deus")), DataCell(Text("Crime")), DataCell(Text("8.6"))]),
              DataRow(cells: [DataCell(Text("Vingadores: Ultimato")), DataCell(Text("Ação")), DataCell(Text("8.4"))]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.home), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
    ),
  );

  runApp(app);
}