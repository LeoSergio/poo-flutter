# POO — Receitas (Flutter)

Cada pasta abaixo é um projeto Flutter independente e completo, correspondendo ao estado final de uma receita da disciplina de Programação Orientada a Objetos (POO/UFRN). Todas evoluem o mesmo app (uma tabela de dados consumidos da API [random-data-api.com](https://random-data-api.com/), navegável por uma barra inferior com as abas Cafés, Cervejas e Nações), indo do mais simples (Receita 1) até o mais completo (Receita 7).

| Pasta | Tema |
|---|---|
| `receita1/` | Estrutura base, lista e tabela |
| `receita2/` | Classe `ListaDeBebidas` / `MyApp` |
| `receita3/` | Exercícios de customização |
| `receita4/` | JSON, scroll na tabela, ODBC/ORM |
| `receita5/` | Modificando estado dos objetos |
| `receita6/` | Gerenciamento de estado |
| `receita7/` | Programação assíncrona (versão mais completa) |

## Pré-requisitos

- Flutter SDK com Dart `^3.11.1` (canal **stable**, recomendado Flutter 3.27 ou mais recente)
- Um dispositivo conectado, emulador, ou suporte a Web/Desktop habilitado (`flutter devices`)
- Conexão com a internet — a Receita 7 faz requisição HTTP em tempo de execução

Verifique o ambiente antes de começar:

```bash
flutter doctor
```

## Como executar qualquer receita

Cada pasta tem seu próprio `pubspec.yaml`, então basta entrar nela e rodar normalmente:

```bash
cd POO/receita7      # troque pelo número da receita desejada
flutter pub get
flutter run
```

Na Receita 7, apenas a aba **"Cervejas"** busca dados de fato (via `http.read` na rota `random-data-api.com/api/beer/random_beer`) e popula a tabela com Nome, Estilo e IBU. As abas "Cafés" e "Nações" navegam, mas ainda não têm uma fonte de dados associada — isso é esperado nesse ponto, não é um erro de configuração.
