#!/usr/bin/env bash
set -e

# Roda este script a partir da raiz do repositório (onde fica a pasta POO/)
if [ ! -d "POO/projeto_poo" ]; then
  echo "Erro: pasta POO/projeto_poo nao encontrada. Rode este script na raiz do repositorio."
  exit 1
fi

echo "Verificando se a working tree esta limpa..."
if [ -n "$(git status --porcelain)" ]; then
  echo "Aviso: existem mudancas nao commitadas. Recomendo fazer commit ou stash antes de continuar."
  read -p "Continuar mesmo assim? (s/N) " resp
  [ "$resp" = "s" ] || exit 1
fi

declare -A receitas=( [1]=61c6f09 [2]=6ef5c0b [3]=dee583a [4]=b0674c4 [5]=e3d9f20 [6]=cd6815b [7]=057f96d )

rm -rf POO_new
mkdir -p POO_new

for num in 1 2 3 4 5 6 7; do
  hash="${receitas[$num]}"
  dest="POO_new/receita${num}"
  mkdir -p "$dest"
  git archive "$hash" -- POO/projeto_poo | tar -x -C "$dest" --strip-components=2
  echo "receita${num} ($hash) extraida com sucesso"
done

git rm -r --cached POO/projeto_poo > /dev/null
rm -rf POO/projeto_poo
mv POO_new/* POO/
rmdir POO_new

cat > POO/README.md << 'EOF'
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
EOF

git add POO
echo ""
echo "Tudo certo. Pastas criadas:"
find POO -maxdepth 1 -type d
echo ""
echo "Revise com 'git status' e 'git diff --staged --stat', depois finalize com:"
echo "  git commit -m \"Reestrutura: cada receita em sua propria pasta dentro de POO/\""
echo "  git push origin main"
