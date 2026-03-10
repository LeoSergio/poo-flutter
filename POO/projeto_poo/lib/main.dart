import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Filmes..."),
      ),
      
      // O corpo do app com a nossa lista expansível
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text("O Poderoso Chefão", style: TextStyle(fontSize: 18)),
            subtitle: Text("Crime/Drama"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Interestelar", style: TextStyle(fontSize: 18)),
            subtitle: Text("Ficção Científica"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in odio in velit iaculis sollicitudin.",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("Pulp Fiction", style: TextStyle(fontSize: 18)),
            subtitle: Text("Crime"),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero.",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ],
      ),
      
      // Trazendo de volta a barra inferior!
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0), // Um respiro extra
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.movie), 
              iconSize: 30, 
              color: Colors.deepPurple, // Dando uma cor para mostrar que está "ativo"
              onPressed: () => print("Aba Filmes"),
            ),
            IconButton(
              icon: const Icon(Icons.search), 
              iconSize: 30, 
              onPressed: () => print("Aba Busca"),
            ),
            IconButton(
              icon: const Icon(Icons.settings), 
              iconSize: 30, 
              onPressed: () => print("Aba Configurações"),
            ),
          ],
        ),
      ),
    ),
  );

  runApp(app);
}