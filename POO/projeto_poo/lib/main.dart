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
            ElevatedButton(
              onPressed: () => print("Clicou no 1"),
              child: const Text("Botão 1")
            ),
            ElevatedButton(
              onPressed: () => print("Clicou no 2"),
              child: const Text("Botão 2")
            ),
            ElevatedButton(
              onPressed: () => print("Clicou no 3"),
              child: const Text("Botão 3")
            ),
            
          ],
      )
    ),
  );

  runApp(app);
}