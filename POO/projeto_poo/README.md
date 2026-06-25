# projeto_poo — Receitas de POO (Flutter)

App Flutter desenvolvido para a disciplina de Programação Orientada a Objetos (POO/UFRN). É **um único projeto** que evoluiu ao longo de 7 receitas (RC1 a RC7): cada receita foi implementada como uma sequência de commits sobre o mesmo `lib/main.dart`, em vez de pastas separadas. Por isso, o código que está no `main` hoje corresponde ao estado **final** (Receita 7), e as receitas anteriores ficam preservadas no histórico do Git.

O app exibe, em uma tabela, dados consumidos da API pública [random-data-api.com](https://random-data-api.com/) e usa uma barra de navegação inferior com três abas: Cafés, Cervejas e Nações.

## Pré-requisitos

- Flutter SDK com Dart `^3.11.1` (canal **stable**, recomendado Flutter 3.27 ou mais recente)
- Um dispositivo conectado, emulador, ou suporte a Web/Desktop habilitado (`flutter devices`)
- Conexão com a internet — a Receita 7 faz requisição HTTP em tempo de execução

Verifique o ambiente antes de começar:

```bash
flutter doctor
```

## Como executar a versão atual (estado final — Receita 7)

```bash
git clone https://github.com/LeoSergio/poo-flutter.git
cd poo-flutter/POO/projeto_poo
flutter pub get
flutter run
```

> O `pubspec.yaml` e o app ficam dentro de `POO/projeto_poo`, não na raiz do repositório.

Na execução atual, apenas a aba **"Cervejas"** busca dados (via `http.read` na rota `random-data-api.com/api/beer/random_beer`) e popula a tabela com Nome, Estilo e IBU. As abas "Cafés" e "Nações" navegam, mas ainda não têm uma fonte de dados associada — isso é esperado no ponto em que a Receita 7 está, não é um erro de configuração.

## Executando cada receita individualmente

Como o professor vai testar receita por receita, o jeito mais simples é dar checkout no commit final de cada uma em uma branch separada e rodar normalmente:

```bash
git checkout <hash-do-commit> -b receita-N
cd POO/projeto_poo
flutter pub get
flutter run

# para voltar à versão mais atual depois:
git checkout main
```

| Receita | Tema | Commit final | Comando para testar |
|---|---|---|---|
| 1 | Estrutura base, lista e tabela | `61c6f09` | `git checkout 61c6f09 -b receita-1` |
| 2 | Classe `ListaDeBebidas` / `MyApp` | `6ef5c0b` | `git checkout 6ef5c0b -b receita-2` |
| 3 | Exercícios de customização | `dee583a` | `git checkout dee583a -b receita-3` |
| 4 | JSON, scroll na tabela, ODBC/ORM | `b0674c4` | `git checkout b0674c4 -b receita-4` |
| 5 | Modificando estado dos objetos | `e3d9f20` | `git checkout e3d9f20 -b receita-5` |
| 6 | Gerenciamento de estado | `cd6815b` | `git checkout cd6815b -b receita-6` |
| 7 | Programação assíncrona (estado atual do `main`) | `057f96d` | já é o `main` |

Depois de rodar `flutter pub get` em receitas mais antigas, pode ser necessário rodar de novo ao voltar para o `main`, já que as dependências em `pubspec.yaml` também evoluíram entre as receitas.

## Histórico completo

Para ver a lista de commits de uma receita específica (não só o final), use:

```bash
git log --oneline <commit-inicial>..<commit-final>
```

Por exemplo, para ver todos os passos da Receita 6:

```bash
git log --oneline e3d9f20..cd6815b
```