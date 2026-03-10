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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,//Espaço entre os itens
        children: [
          Text("Botão 1"),
          Text("Botão 2"),
          Text("Botão 3"),
        ],
      )
    ),
  );

  runApp(app);
}