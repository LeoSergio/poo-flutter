# Login System — Node.js + Prisma + React

Sistema de login com PostgreSQL, driver `pg` (ODBC), Prisma ORM e interface React.

## 📄 Documentação da tarefa

👉 [tarefa-orm.md](./tarefa-orm.md)

## Stack

| Camada | Tecnologia |
|---|---|
| Banco de dados | PostgreSQL 15 (Docker) |
| Driver ODBC | `pg` (node-postgres) |
| ORM | Prisma |
| API | Express (Node.js) |
| Frontend | React + Vite |
| Admin BD | PgAdmin 4 |

## Estrutura

```
login-system/
├── docker-compose.yml       ← PostgreSQL + PgAdmin
├── tarefa-orm.md            ← Documentação da tarefa
├── backend/
│   ├── prisma/
│   │   └── schema.prisma    ← Modelo do banco (Prisma)
│   ├── sql/
│   │   └── init.sql         ← Script de criação da tabela
│   └── src/
│       ├── odbc/
│       │   └── conexao.js   ← Acesso via driver pg (ODBC)
│       ├── orm/
│       │   └── orm.js       ← Acesso via Prisma ORM
│       └── server.js        ← API REST
└── frontend/
    └── src/
        ├── components/
        │   ├── AuthForm.jsx  ← Tela de login/cadastro
        │   └── Dashboard.jsx ← Tela pós-login
        ├── hooks/
        │   └── useAuth.js   ← Hook de autenticação
        └── App.jsx
```

## Como rodar

### 1. Banco de dados

```bash
docker compose up -d
```

Acesse o PgAdmin em http://localhost:8080
- Email: admin@admin.com / Senha: admin
- Conectar ao servidor: host=`postgres`, user=`aluno`, senha=`senha123`

### 2. Backend

```bash
cd backend
npm install
npx prisma generate
npm run dev
```

API disponível em http://localhost:3001

### 3. Frontend

```bash
cd frontend
npm install
npm run dev
```

Acesse em http://localhost:5173

## Endpoints da API

| Método | Rota | Descrição |
|---|---|---|
| POST | /api/login | Autenticar usuário |
| POST | /api/cadastro | Criar novo usuário |
| GET | /api/usuarios | Listar usuários |

## Testar ODBC e ORM isoladamente

```bash
# Testar driver pg (ODBC) direto
node backend/src/odbc/conexao.js

# Testar Prisma ORM direto
node backend/src/orm/orm.js
```
