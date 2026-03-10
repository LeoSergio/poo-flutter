import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(primarySwatch: Colors.teal), // <-- Nova cor aqui!
    home: Scaffold(
      appBar: AppBar(
        title: Text("Filmes",
        style: TextStyle(
                fontWeight: FontWeight.bold, // Deixa em negrito
                fontFamily: 'monospace',     // Altera a família da fonte
                fontSize: 24,
        ),
        ),
          
      ),
      body:  Center(
        child: Column(
          children: [
            Text("Apenas começando..."),
            Text("No meio..."),
            Text("Terminando...")
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [
          ElevatedButton(
            onPressed: () {}, 
            child: const Text("Anterior")
          ),
          
          // O IconButton entra aqui!
          IconButton(
            icon: const Icon(Icons.favorite), 
            color: Colors.red, // Deixando o coração vermelho
            iconSize: 32,      // Ajustando o tamanho
            onPressed: () => print("Favoritado!"),
          ),

          ElevatedButton(
            onPressed: () {}, 
            child: const Text("Próximo")
          ),
        ],
      ),
    ),
  );

  runApp(app);
}