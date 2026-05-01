/**
 * conexao.js — Acesso ao banco usando o driver pg (equivalente a ODBC em Node.js)
 *
 * O pacote 'pg' (node-postgres) é o driver nativo do PostgreSQL para Node.js.
 * Ele faz o papel do ODBC: abre uma conexão com o banco usando uma string de
 * conexão, executa SQL puro via cursor e retorna os resultados.
 */

import pg from 'pg';

const { Pool } = pg;

// Configuração da conexão (equivalente à connection string ODBC)
const pool = new Pool({
  host: 'localhost',
  port: 5432,
  database: 'LoginDB',
  user: 'aluno',
  password: 'senha123',
});

// ── Cadastrar usuário ──────────────────────────────────────────────────────────
export async function cadastrarUsuario(nome, email, senha) {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `INSERT INTO usuarios (nome, email, senha)
       VALUES ($1, $2, $3)
       RETURNING id, nome, email, criado_em`,
      [nome, email, senha]
    );
    console.log('[ODBC] Usuário cadastrado:', result.rows[0]);
    return result.rows[0];
  } finally {
    client.release();
  }
}

// ── Login por email e senha ────────────────────────────────────────────────────
export async function loginUsuario(email, senha) {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `SELECT id, nome, email FROM usuarios
       WHERE email = $1 AND senha = $2`,
      [email, senha]
    );
    if (result.rows.length === 0) {
      console.log('[ODBC] Login falhou: credenciais inválidas');
      return null;
    }
    console.log('[ODBC] Login bem-sucedido:', result.rows[0]);
    return result.rows[0];
  } finally {
    client.release();
  }
}

// ── Listar todos os usuários ───────────────────────────────────────────────────
export async function listarUsuarios() {
  const client = await pool.connect();
  try {
    const result = await client.query(
      `SELECT id, nome, email, criado_em FROM usuarios ORDER BY id`
    );
    console.log('[ODBC] Usuários encontrados:', result.rows);
    return result.rows;
  } finally {
    client.release();
  }
}

// ── Teste direto (execute: node src/odbc/conexao.js) ──────────────────────────
if (process.argv[1].endsWith('conexao.js')) {
  console.log('\n=== Teste ODBC (driver pg) ===\n');

  await cadastrarUsuario('João Silva', 'joao@email.com', 'senha456');
  await loginUsuario('joao@email.com', 'senha456');
  await loginUsuario('joao@email.com', 'errada');
  await listarUsuarios();

  await pool.end();
  console.log('\n=== Teste concluído ===');
}

export { pool };
