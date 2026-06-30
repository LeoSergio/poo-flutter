Markdown

# 🏥 RadarSus

> Projeto de Extensão Universitária — Disciplina: Programação Orientada a Objetos  
> Curso: Bacharelado em Sistemas de Informação  
> Tema: **Letramento Digital na Saúde**

---

## 📋 Descrição

O **RadarSus** é um aplicativo móvel desenvolvido em Flutter que centraliza informações públicas de saúde na palma da mão do gestor municipal. O projeto passou por uma evolução estratégica e agora consome a **API do InfoDengue (Fiocruz)**, oferecendo dados reais de vigilância epidemiológica em uma interface institucional, clara e responsiva (*Clean Health*).

O projeto integra o programa de extensão **"Letramento Digital na Saúde"**, voltado para capacitar gestores de municípios como Caicó e Santa Cruz (RN) no uso de tecnologia digital como ferramenta de apoio à tomada de decisão em saúde pública.

---

## 🎯 Objetivos

- Demonstrar na prática os princípios de **Programação Orientada a Objetos** por meio de um produto funcional focado em um domínio real.
- Oferecer aos gestores municipais acesso simplificado a dados oficiais de vigilância epidemiológica da Fiocruz (InfoDengue).
- Introduzir competências digitais de forma orgânica, através da experiência de uso de um aplicativo com UX voltada para clareza e transparência.

---

## 🏗️ Arquitetura e POO na Prática

A estrutura do projeto foi desenhada para evidenciar os quatro pilares de POO e refatorada para o novo domínio epidemiológico:

```text
lib/
├── main.dart
├── models/
│   └── alerta_dengue.dart        # Encapsulamento: atributos privados + getters
├── services/
│   └── dengue_service.dart       # Abstração: contrato de acesso à API InfoDengue
├── viewmodels/
│   └── alertas_viewmodel.dart    # Separação de responsabilidade com ValueNotifier
└── views/
    ├── home_screen.dart
    └── widgets/
        └── alerta_card.dart      # Reutilização: componente genérico

Camada	Pilar de POO	Descrição
models/	Encapsulamento	Dados da API modelados como objetos com atributos controlados e tratamentos de tipagem (ex: double para int).
services/	Abstração	Lógica de requisição HTTP isolada, ocultando a complexidade da API.
viewmodels/	Polimorfismo	Estado reativo desacoplado da interface visual.
widgets/	Herança	Componentes que estendem widgets base do Flutter.
⚙️ Stack Técnica e Soluções
Tecnologia	Versão	Papel
Flutter	≥ 3.x	Framework principal
Dart	≥ 3.x	Linguagem
http	^1.2.1	Requisições HTTP assíncronas
flutter_hooks	^0.20.5	Gerência de estado reativa com ValueNotifier
Destaques Técnicos da Implementação:

    Tratamento de Dados Robusto: Implementação de conversão segura de dados JSON (de double para int) para evitar falhas de tipagem dinâmicas da API.

    Cálculo de Datas Dinâmico: Lógica matemática customizada para converter "Semanas Epidemiológicas" em datas reais legíveis (formato "dia/mês a dia/mês").

    Busca Contextual: Consumo de dados dinâmico filtrado pelo ano corrente (DateTime.now().year).

    Design Clean Health: Interface migrada para o modo claro (Light Mode) com paleta institucional, destacando números críticos para gestores e isolando cores semânticas de risco (Verde, Amarelo, Vermelho).

🌐 API Utilizada

InfoDengue (Fiocruz) — Observatório de Doenças Transmitidas por Mosquitos

    Fonte de dados oficial de vigilância epidemiológica.

    Retorna dados sobre casos notificados, estimativas de incidência e níveis de risco por município e semana epidemiológica.

🚀 Como Rodar o Projeto
Pré-requisitos

    Flutter SDK instalado (flutter --version).

    Android Studio ou VS Code com extensão Flutter.

    Dispositivo físico ou emulador configurado.

Instalação
Bash

# 1. Clonar o repositório
git clone git@github.com:LeoSergio/Faculdade_BSI.git
cd Faculdade_BSI/poo/radar_sus

# 2. Instalar dependências
flutter pub get

# 3. Verificar ambiente
flutter doctor

# 4. Rodar o app
flutter run

🛠️ Solução de Problemas Comuns (Troubleshooting)

    Erro de Gradle no Linux: Caso enfrente falhas de compilação, certifique-se de instalar o JDK 21 (sudo apt install openjdk-21-jdk) e apontar o caminho no Flutter usando o comando flutter config --jdk-dir /usr/lib/jvm/java-21-openjdk-amd64.

    Erro INSTALL_FAILED_USER_RESTRICTED (Aparelhos Xiaomi/MIUI): Vá em Opções do Desenvolvedor, ative "Instalar via USB" e "Depuração USB (Config. de segurança)". Durante o flutter run, fique atento à tela do celular para aceitar o pop-up de instalação em até 10 segundos.

📱 Funcionalidades do MVP

    [x] Consumo da API do InfoDengue (Fiocruz) em tempo real.

    [x] Listagem do histórico semanal de alertas epidemiológicos.

    [x] Conversão automática de Semana Epidemiológica para datas convencionais.

    [x] Interface Clean Health (Modo Claro) focada em acessibilidade e clareza para gestores.

    [x] Gerência de estado reativa sem StatefulWidget.

📂 Contexto no Repositório

Este projeto faz parte do repositório geral da graduação em Sistemas de Informação:
Plaintext

Faculdade_BSI/
├── 1periodo/algoritmo/
├── 2periodo/
├── BD/
├── E.D/
├── FADA/
└── POO/
    └── RadarSus/   ← você está aqui

👤 Autor

Leo Sergio

Bacharelado em Sistemas de Informação

Universidade Federal do Rio Grande do Norte — Caicó, RN
📄 Licença

Este projeto está sob a licença MIT. Consulte o arquivo LICENSE na raiz do repositório.