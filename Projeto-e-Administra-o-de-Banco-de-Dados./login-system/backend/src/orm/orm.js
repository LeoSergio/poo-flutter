/**
 * orm.js — Acesso ao banco usando Prisma ORM
 *
 * O Prisma mapeia a tabela "usuarios" para a classe Usuario.
 * Não escrevemos SQL: usamos métodos como .create(), .findUnique(), .findMany().
 * O Prisma gera as queries automaticamente a partir do schema.prisma.
 */

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// ── Cadastrar usuário ──────────────────────────────────────────────────────────
export async function cadastrarUsuario(nome, email, senha) {
  const usuario = await prisma.usuario.create({
    data: { nome, email, senha },
    select: { id: true, nome: true, email: true, criadoEm: true },
  });
  console.log('[ORM] Usuário cadastrado:', usuario);
  return usuario;
}

// ── Login por email e senha ────────────────────────────────────────────────────
export async function loginUsuario(email, senha) {
  const usuario = await prisma.usuario.findFirst({
    where: { email, senha },
    select: { id: true, nome: true, email: true },
  });
  if (!usuario) {
    console.log('[ORM] Login falhou: credenciais inválidas');
    return null;
  }
  console.log('[ORM] Login bem-sucedido:', usuario);
  return usuario;
}

// ── Listar todos os usuários ───────────────────────────────────────────────────
export async function listarUsuarios() {
  const usuarios = await prisma.usuario.findMany({
    select: { id: true, nome: true, email: true, criadoEm: true },
    orderBy: { id: 'asc' },
  });
  console.log('[ORM] Usuários encontrados:', usuarios);
  return usuarios;
}

// ── Buscar por email ───────────────────────────────────────────────────────────
export async function buscarPorEmail(email) {
  return prisma.usuario.findUnique({ where: { email } });
}

// ── Teste direto (execute: node src/orm/orm.js) ────────────────────────────────
if (process.argv[1].endsWith('orm.js')) {
  console.log('\n=== Teste Prisma ORM ===\n');

  await cadastrarUsuario('Maria Lima', 'maria@email.com', 'abc123');
  await loginUsuario('maria@email.com', 'abc123');
  await loginUsuario('maria@email.com', 'errada');
  await listarUsuarios();

  await prisma.$disconnect();
  console.log('\n=== Teste concluído ===');
}

export { prisma };
