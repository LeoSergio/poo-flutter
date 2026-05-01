# Tarefa - ODBC e ORM

## Links dos arquivos

| Arquivo | Descrição |
|---|---|
| [`backend/src/odbc/conexao.js`](./backend/src/odbc/conexao.js) | Acesso ao banco via driver pg (ODBC) |
| [`backend/src/orm/orm.js`](./backend/src/orm/orm.js) | Acesso ao banco via Prisma ORM |
| [`backend/src/server.js`](./backend/src/server.js) | API REST Express |
| [`backend/prisma/schema.prisma`](./backend/prisma/schema.prisma) | Schema do Prisma |
| [`backend/sql/init.sql`](./backend/sql/init.sql) | Script SQL de inicialização |
| [`frontend/src/`](./frontend/src/) | Aplicação React |
| [`docker-compose.yml`](./docker-compose.yml) | Configuração Docker |

---

## ODBC em Node.js

ODBC (Open Database Connectivity) é uma API padrão que permite que programas acessem sistemas de banco de dados de forma independente. Em Node.js, o equivalente direto é o uso de **drivers nativos** de cada banco de dados.

Para PostgreSQL, o pacote utilizado foi o **`pg` (node-postgres)**, que funciona como um driver de conexão de baixo nível:

- Abre uma conexão com o banco usando host, porta, usuário e senha
- Executa **SQL puro** por meio de um cursor (`pool.query()`)
- Retorna os resultados em formato de objeto JavaScript
- Gerencia um **pool de conexões** para reutilização eficiente

```js
// Exemplo de uso do driver pg (ODBC)
import pg from 'pg'
const pool = new pg.Pool({ host: 'localhost', database: 'LoginDB', ... })

const result = await pool.query(
  'SELECT * FROM usuarios WHERE email = $1',
  ['joao@email.com']
)
```

Diferente de um ORM, o driver pg não abstrai o SQL — o desenvolvedor escreve as queries manualmente e tem controle total sobre o que é executado no banco.

---

## ORM em Node.js — Prisma

ORM (Object-Relational Mapping) é uma técnica que mapeia tabelas do banco de dados para classes/objetos da linguagem de programação. O desenvolvedor manipula dados usando métodos da linguagem, sem escrever SQL diretamente.

O framework utilizado foi o **Prisma**, considerado o ORM mais moderno para Node.js/TypeScript. Suas principais características:

### Schema declarativo

O Prisma define os modelos em um arquivo `schema.prisma`:

```prisma
model Usuario {
  id    Int    @id @default(autoincrement())
  nome  String
  email String @unique
  senha String
}
```

### Queries type-safe

```js
// Criar usuário
await prisma.usuario.create({ data: { nome, email, senha } })

// Buscar por campo
await prisma.usuario.findUnique({ where: { email } })

// Listar todos
await prisma.usuario.findMany()
```

### Vantagens do Prisma sobre SQL direto

| Aspecto | Driver pg (ODBC) | Prisma (ORM) |
|---|---|---|
| SQL | Manual, escrito pelo dev | Gerado automaticamente |
| Type safety | Nenhuma | Total (TypeScript) |
| Migrações | Manual | Automáticas (`prisma migrate`) |
| Legibilidade | SQL strings | Código JavaScript limpo |
| Flexibilidade | Total | Alta (com `queryRaw` para SQL puro) |

### Quando usar cada um

- **Driver pg**: quando você precisa de queries complexas, otimizadas, ou total controle do SQL
- **Prisma**: na maioria dos projetos — aumenta a produtividade, reduz erros e facilita manutenção
