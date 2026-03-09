import 'package:flutter/material.dart';

void main() {
  MaterialApp app = MaterialApp(
    theme: ThemeData(primarySwatch: Colors.deepPurple),
    home: Scaffold(
      appBar: AppBar(
        title: const Text("Meu app"),
      ),
      body: const Text("Apenas começando..."),
      bottomNavigationBar: const Text("Botão 1"),
    ), // Fecha o Scaffold
  ); // Fecha o MaterialApp

  runApp(app);
}