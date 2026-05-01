# 🎓 Predição de Tempo de Titulação e Gargalos Curriculares

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![Pandas](https://img.shields.io/badge/Pandas-Data_Processing-150458.svg)
![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-Machine_Learning-F7931E.svg)
![Status](https://img.shields.io/badge/Status-Em_Desenvolvimento-green.svg)

## 📌 Sobre o Projeto

Este repositório contém o código-fonte e as análises do Trabalho de Conclusão de Curso (TCC) desenvolvido no Laboratório de Inteligência Computacional Aplicada (**Labican**) da Universidade Federal do Rio Grande do Norte (**UFRN**).

O objetivo principal é aplicar técnicas de **Mineração de Dados Educacionais (MDE)** para analisar o histórico de estudantes do Bacharelado em Sistemas de Informação. O foco atual do projeto é prever, com base no desempenho do ciclo básico (1º e 2º períodos), em qual "classe de atraso" (tempo de titulação) o discente se enquadrará. 

Futuramente, este modelo analítico servirá como motor para um **Sistema de Alerta Precoce (*Early Warning System*)**, alertando alunos sobre combinações de disciplinas (co-matrículas) com alto risco de retenção.

## 🎯 Objetivos Específicos

1. **Análise Exploratória (EDA):** Mapear a distribuição do tempo real de conclusão do curso, evidenciando a dispersão em relação ao fluxo ideal de 8 semestres.
2. **Engenharia de Atributos (Feature Engineering):** Consolidar microdados acadêmicos em indicadores preditivos (ex: reprovações no ciclo básico, antecipações, agrupamento de optativas e IRA consolidado).
3. **Modelagem Preditiva:** Treinar algoritmos de Classificação baseados em árvores (como *Random Forest* e *Decision Trees*) para classificar o risco de retenção severa.

## 🗂️ Estrutura do Repositório

A arquitetura do projeto segue o padrão *Cookiecutter Data Science* para garantir modularidade entre a fase de pesquisa e a futura fase de engenharia de software (API).
```text
├── data/                   <- [IGNORADO NO GIT] Dados brutos (raw) e processados
├── notebooks/              <- Análises exploratórias (Jupyter/Colab)
│   ├── 01_eda_tempo_titulacao.ipynb
│   └── 02_modelagem_classificacao.ipynb
├── src/                    <- Código fonte (Módulos Python)
│   ├── data/               <- Scripts de ETL e limpeza
│   ├── features/           <- Scripts de criação de variáveis preditivas
│   └── models/             <- Treinamento e avaliação do modelo preditivo
├── api/                    <- [Futuro] Aplicação web FastAPI para o Sistema de Alerta
├── .gitignore              <- Arquivos e pastas ignoradas (dados e ambientes)
├── requirements.txt        <- Dependências do projeto
└── README.md               <- Este documento