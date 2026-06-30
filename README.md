# POO — Receitas e Projeto (Flutter)

Repositório da disciplina de Programação Orientada a Objetos (POO/UFRN), contendo as 7 receitas da Unidade 1 e o projeto da Unidade 2.

---

## Receitas — Unidade 1

Cada pasta é um projeto Flutter independente e completo, correspondendo ao estado final de uma receita. Todas evoluem o mesmo app (uma tabela de dados consumidos da API [random-data-api.com](https://random-data-api.com/), navegável por uma barra inferior com as abas Cafés, Cervejas e Nações).

| Pasta | Tema |
|---|---|
| `receita1/` | Estrutura base, lista e tabela |
| `receita2/` | Classe `ListaDeBebidas` / `MyApp` |
| `receita3/` | Exercícios de customização |
| `receita4/` | JSON, scroll na tabela, ODBC/ORM |
| `receita5/` | Modificando estado dos objetos |
| `receita6/` | Gerenciamento de estado |
| `receita7/` | Programação assíncrona (versão mais completa) |

### Como executar qualquer receita

```bash
cd POO/receita7      # troque pelo número desejado
flutter pub get
flutter run
```

---

## RadarSUS — Projeto Unidade 2

App Flutter que consome a API [InfoDengue](https://info.dengue.mat.br/) para exibir dados epidemiológicos de dengue, zika e chikungunya por município. Desenvolvido como projeto da Unidade 2 da disciplina.

**Destaques técnicos:**
- Gerência de estado com `ValueNotifier` + `flutter_hooks` (sem `StatefulWidget`)
- Sealed classes para modelar os estados de carregamento (`Loading`, `Success`, `Error`)
- Programação assíncrona com `async`/`await`
- Paleta dark-navy

### Como executar

```bash
cd POO/radar_sus
flutter pub get
flutter run
```

---

## Pré-requisitos (comuns a todos os projetos)

- Flutter SDK com Dart `^3.11.1` (canal **stable**, recomendado Flutter 3.27 ou mais recente)
- Um dispositivo conectado, emulador, ou suporte a Web/Desktop habilitado
- Conexão com a internet

```bash
flutter doctor
```