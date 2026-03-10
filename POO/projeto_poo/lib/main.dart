import 'package:flutter/material.dart';
//exercicio 2 feito, ir para o 3.

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
      bottomNavigationBar: const Text("Botão 1"),
    ),
  );

  runApp(app);
}