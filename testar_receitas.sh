#!/usr/bin/env bash
set -e

if [ ! -d "POO" ]; then
  echo "Erro: pasta POO/ nao encontrada. Rode este script na raiz do repositorio."
  exit 1
fi

echo "============================================="
echo " Testando receita por receita"
echo "============================================="

resultados=()

for num in 1 2 3 4 5 6 7; do
  dir="POO/receita${num}"
  if [ ! -d "$dir" ]; then
    resultados+=("receita${num}: PASTA NAO ENCONTRADA")
    continue
  fi

  echo ""
  echo "--- receita${num} ---"
  cd "$dir"

  if ! flutter pub get > /tmp/pubget_${num}.log 2>&1; then
    echo "FALHOU no 'flutter pub get'. Veja /tmp/pubget_${num}.log"
    resultados+=("receita${num}: ERRO no pub get")
    cd - > /dev/null
    continue
  fi
  echo "pub get OK"

  flutter analyze > /tmp/analyze_${num}.log 2>&1 || true
  n_erros=$(grep -E "error •" /tmp/analyze_${num}.log | wc -l)
  n_avisos=$(grep -E "warning •" /tmp/analyze_${num}.log | wc -l)

  if [ "$n_erros" -eq 0 ]; then
    echo "analyze OK (0 erros, $n_avisos avisos)"
    resultados+=("receita${num}: OK (0 erros, $n_avisos avisos)")
  else
    echo "analyze encontrou $n_erros erro(s) reais. Veja /tmp/analyze_${num}.log"
    resultados+=("receita${num}: $n_erros ERRO(S) REAIS - ver /tmp/analyze_${num}.log")
  fi

  cd - > /dev/null
done

echo ""
echo "============================================="
echo " Resumo"
echo "============================================="
for r in "${resultados[@]}"; do
  echo "$r"
done

echo ""
echo "Para testar visualmente uma receita especifica (abrir no dispositivo/emulador):"
echo "  cd POO/receitaN && flutter run"
