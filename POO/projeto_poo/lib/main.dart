import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.indigo, // Um tom mais "cinema"
      fontFamily: 'Georgia',
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Filmes Favoritos"),
      ),
      body: SingleChildScrollView( // Adicionado para garantir que caiba em telas menores
        child: Center(
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Título", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Gênero", style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text("Nota", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text("O Poderoso Chefão")),
                DataCell(Text("Crime/Drama")),
                DataCell(Text("9.2")),
              ]),
              DataRow(cells: [
                DataCell(Text("Interestelar")),
                DataCell(Text("Ficção Científica")),
                DataCell(Text("8.7")),
              ]),
              DataRow(cells: [
                DataCell(Text("Vingadores Ultimato")),
                DataCell(Text("Ficção Científica")),
                DataCell(Text("8.9")),
              ]),
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