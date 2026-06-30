#!/usr/bin/env bash
set -e

# Roda este script na RAIZ do repositório poo-flutter
# O projeto será criado em POO/projeto/

if ! command -v flutter &> /dev/null; then
  echo "Erro: flutter nao encontrado no PATH."
  exit 1
fi

if [ ! -d "POO" ]; then
  echo "Erro: pasta POO/ nao encontrada. Rode este script na raiz do repositorio poo-flutter."
  exit 1
fi

if [ -d "POO/projeto" ]; then
  echo "Erro: POO/projeto já existe. Apague a pasta antes de rodar novamente."
  exit 1
fi

echo "==> Criando o projeto Flutter em POO/projeto..."
flutter create POO/projeto
cd POO/projeto

echo "==> Adicionando dependencias (http e provider)..."
flutter pub add http
flutter pub add provider

echo "==> Escrevendo arquivos do projeto..."
rm -f lib/main.dart
mkdir -p lib/models lib/services lib/providers lib/screens lib/widgets

# ---------- models ----------

cat > lib/models/product.dart << 'EOF'
/// Representa um produto vindo do endpoint /products da DummyJSON API.
class Product {
  final int id;
  final String title;
  final String category;
  final double price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
EOF

cat > lib/models/recipe.dart << 'EOF'
/// Representa uma receita culinária vinda do endpoint /recipes da DummyJSON API.
class Recipe {
  final int id;
  final String name;
  final String cuisine;
  final String difficulty;
  final int caloriesPerServing;

  Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.difficulty,
    required this.caloriesPerServing,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['name'] as String,
      cuisine: json['cuisine'] as String,
      difficulty: json['difficulty'] as String,
      caloriesPerServing: json['caloriesPerServing'] as int,
    );
  }
}
EOF

cat > lib/models/app_user.dart << 'EOF'
/// Representa um usuário vindo do endpoint /users da DummyJSON API.
class AppUser {
  final int id;
  final String fullName;
  final String email;
  final int age;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.age,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      fullName: '${json['firstName']} ${json['lastName']}',
      email: json['email'] as String,
      age: json['age'] as int,
    );
  }
}
EOF

# ---------- services ----------

cat > lib/services/api_service.dart << 'EOF'
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_user.dart';
import '../models/product.dart';
import '../models/recipe.dart';

/// Responsável exclusivamente por buscar dados na DummyJSON API.
/// Não tem nenhuma dependência de Flutter/widgets.
/// Usa async/await em todos os métodos — nenhum uso de .then.
class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts(int limit) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/products?limit=$limit'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar produtos (HTTP ${response.statusCode})');
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final items = body['products'] as List<dynamic>;
    return items
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Recipe>> fetchRecipes(int limit) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/recipes?limit=$limit'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar receitas (HTTP ${response.statusCode})');
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final items = body['recipes'] as List<dynamic>;
    return items
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<AppUser>> fetchUsers(int limit) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users?limit=$limit'),
    );
    if (response.statusCode != 200) {
      throw Exception('Falha ao carregar usuários (HTTP ${response.statusCode})');
    }
    final body = json.decode(response.body) as Map<String, dynamic>;
    final items = body['users'] as List<dynamic>;
    return items
        .map((item) => AppUser.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
EOF

# ---------- providers ----------

cat > lib/providers/navigation_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';

/// Controla qual aba está selecionada na barra de navegação.
/// Usa ChangeNotifier — diferente de ValueNotifier, useState e StatefulWidget.
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }
}
EOF

cat > lib/providers/products_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider(this._apiService) {
    loadProducts();
  }

  final ApiService _apiService;
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _maxItems = 5;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get maxItems => _maxItems;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _products = await _apiService.fetchProducts(_maxItems);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeMaxItems(int newMax) async {
    if (newMax == _maxItems) return;
    _maxItems = newMax;
    await loadProducts();
  }
}
EOF

cat > lib/providers/recipes_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';

import '../models/recipe.dart';
import '../services/api_service.dart';

class RecipesProvider extends ChangeNotifier {
  RecipesProvider(this._apiService) {
    loadRecipes();
  }

  final ApiService _apiService;
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _maxItems = 5;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get maxItems => _maxItems;

  Future<void> loadRecipes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _recipes = await _apiService.fetchRecipes(_maxItems);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeMaxItems(int newMax) async {
    if (newMax == _maxItems) return;
    _maxItems = newMax;
    await loadRecipes();
  }
}
EOF

cat > lib/providers/users_provider.dart << 'EOF'
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/api_service.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider(this._apiService) {
    loadUsers();
  }

  final ApiService _apiService;
  List<AppUser> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _maxItems = 5;

  List<AppUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get maxItems => _maxItems;

  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _users = await _apiService.fetchUsers(_maxItems);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> changeMaxItems(int newMax) async {
    if (newMax == _maxItems) return;
    _maxItems = newMax;
    await loadUsers();
  }
}
EOF

# ---------- widgets ----------

cat > lib/widgets/loading_indicator.dart << 'EOF'
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!),
          ],
        ],
      ),
    );
  }
}
EOF

cat > lib/widgets/max_items_menu.dart << 'EOF'
import 'package:flutter/material.dart';

class MaxItemsMenu extends StatelessWidget {
  const MaxItemsMenu({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  final int currentValue;
  final ValueChanged<int> onChanged;

  static const List<int> _options = [5, 10, 15];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: currentValue,
      icon: const Icon(Icons.filter_list),
      tooltip: 'Quantidade de itens',
      onSelected: onChanged,
      itemBuilder: (context) => _options
          .map(
            (option) => PopupMenuItem<int>(
              value: option,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mostrar $option itens'),
                  if (option == currentValue)
                    const Icon(Icons.check, size: 18),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
EOF

cat > lib/widgets/app_bottom_nav_bar.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigation = context.watch<NavigationProvider>();

    return BottomNavigationBar(
      currentIndex: navigation.currentIndex,
      onTap: (index) => context.read<NavigationProvider>().changeTab(index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Produtos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu_outlined),
          label: 'Receitas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Usuários',
        ),
      ],
    );
  }
}
EOF

# ---------- screens ----------

cat > lib/screens/products_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/max_items_menu.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          MaxItemsMenu(
            currentValue: provider.maxItems,
            onChanged: (value) =>
                context.read<ProductsProvider>().changeMaxItems(value),
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(ProductsProvider provider) {
    if (provider.isLoading) {
      return const LoadingIndicator(message: 'Carregando produtos...');
    }
    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Título')),
            DataColumn(label: Text('Categoria')),
            DataColumn(label: Text('Preço (US\$)')),
            DataColumn(label: Text('Avaliação')),
          ],
          rows: provider.products
              .map((p) => DataRow(cells: [
                    DataCell(Text(p.title)),
                    DataCell(Text(p.category)),
                    DataCell(Text(p.price.toStringAsFixed(2))),
                    DataCell(Text(p.rating.toStringAsFixed(1))),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
EOF

cat > lib/screens/recipes_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipes_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/max_items_menu.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas'),
        actions: [
          MaxItemsMenu(
            currentValue: provider.maxItems,
            onChanged: (value) =>
                context.read<RecipesProvider>().changeMaxItems(value),
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(RecipesProvider provider) {
    if (provider.isLoading) {
      return const LoadingIndicator(message: 'Carregando receitas...');
    }
    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nome')),
            DataColumn(label: Text('Cozinha')),
            DataColumn(label: Text('Dificuldade')),
            DataColumn(label: Text('Calorias/porção')),
          ],
          rows: provider.recipes
              .map((r) => DataRow(cells: [
                    DataCell(Text(r.name)),
                    DataCell(Text(r.cuisine)),
                    DataCell(Text(r.difficulty)),
                    DataCell(Text('${r.caloriesPerServing}')),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
EOF

cat > lib/screens/users_page.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/max_items_menu.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        actions: [
          MaxItemsMenu(
            currentValue: provider.maxItems,
            onChanged: (value) =>
                context.read<UsersProvider>().changeMaxItems(value),
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(UsersProvider provider) {
    if (provider.isLoading) {
      return const LoadingIndicator(message: 'Carregando usuários...');
    }
    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Nome')),
            DataColumn(label: Text('E-mail')),
            DataColumn(label: Text('Idade')),
          ],
          rows: provider.users
              .map((u) => DataRow(cells: [
                    DataCell(Text(u.fullName)),
                    DataCell(Text(u.email)),
                    DataCell(Text('${u.age}')),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
EOF

cat > lib/screens/home_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'products_page.dart';
import 'recipes_page.dart';
import 'users_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Widget> _pages = [
    ProductsPage(),
    RecipesPage(),
    UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigation = context.watch<NavigationProvider>();

    return Scaffold(
      body: IndexedStack(
        index: navigation.currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
EOF

# ---------- main.dart ----------

cat > lib/main.dart << 'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/navigation_provider.dart';
import 'providers/products_provider.dart';
import 'providers/recipes_provider.dart';
import 'providers/users_provider.dart';
import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const DummyApiApp());
}

class DummyApiApp extends StatelessWidget {
  const DummyApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider(apiService)),
        ChangeNotifierProvider(create: (_) => RecipesProvider(apiService)),
        ChangeNotifierProvider(create: (_) => UsersProvider(apiService)),
      ],
      child: MaterialApp(
        title: 'Unidade 2 - Dummy API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
        home: const HomeScreen(),
      ),
    );
  }
}
EOF

# ---------- README ----------

cat > README.md << 'EOF'
# Projeto — Unidade 2 (DummyJSON API)

App Flutter que consome a [DummyJSON API](https://dummyjson.com/) com três abas na barra de navegação inferior: **Produtos**, **Receitas** e **Usuários**.

## Como rodar

```bash
cd POO/projeto
flutter pub get
flutter run
```

## Decisões de arquitetura

| Requisito | Solução |
|---|---|
| Gerência de estado diferente de `ValueNotifier`/`useState`/`StatefulWidget` | `Provider` + `ChangeNotifier` |
| Programação assíncrona sem misturar | 100% `async`/`await` |
| Separação de classes UI das demais | `models/`, `services/`, `providers/` sem imports de Flutter |
| Menu de quantidade (5, 10 ou 15 itens) | Ícone de filtro na AppBar de cada página |
| Indicador de carregamento | `CircularProgressIndicator` em todas as páginas |
EOF

echo ""
echo "======================================="
echo " Projeto criado em POO/projeto/"
echo "======================================="
echo ""
echo "Para testar:"
echo "  cd POO/projeto && flutter run"
echo ""
echo "Para commitar e publicar (na raiz do poo-flutter):"
echo "  git add POO/projeto"
echo "  git commit -m \"Adiciona projeto Unidade 2 - DummyJSON API com Provider\""
echo "  git push origin main"
