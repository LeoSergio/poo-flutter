import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData
      (primarySwatch: Colors.teal,
      fontFamily: 'Georgia', // Define a fonte padrão para o app INTEIRO
        
        // Também podemos customizar partes específicas do texto
      textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 18.0), // Texto padrão do corpo
        ),
      ),
      
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
            Text("Terminando..."),

            Image.network(
              'https://m.media-amazon.com/images/I/51v5ZpFyaFL._AC_.jpg',
              height: 300
            )
          ],
        ),
      ),
      bottomNavigationBar: Row(
  children: [
    Expanded(
      child: ElevatedButton(onPressed: () {}, child: const Text("Anterior")),
    ),
    Expanded(
      child: IconButton(
        icon: const Icon(Icons.favorite),
        color: Colors.red,
        onPressed: () {},
      ),
    ),
    Expanded(
      child: ElevatedButton(onPressed: () {}, child: const Text("Próximo")),
    ),
  ],
),
    ),
  );

  runApp(app);
}

//questão 7

//questão 7 e 8