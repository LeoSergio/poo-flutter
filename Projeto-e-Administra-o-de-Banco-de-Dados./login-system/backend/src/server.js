import express from 'express';
import cors from 'cors';
import { cadastrarUsuario, loginUsuario, listarUsuarios, buscarPorEmail } from './orm/orm.js';

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors({ origin: 'http://localhost:5173' }));
app.use(express.json());

// ── POST /api/cadastro ─────────────────────────────────────────────────────────
app.post('/api/cadastro', async (req, res) => {
  const { nome, email, senha } = req.body;

  if (!nome || !email || !senha)
    return res.status(400).json({ erro: 'Preencha todos os campos.' });

  if (senha.length < 6)
    return res.status(400).json({ erro: 'Senha deve ter ao menos 6 caracteres.' });

  try {
    const existente = await buscarPorEmail(email);
    if (existente)
      return res.status(409).json({ erro: 'E-mail já cadastrado.' });

    const usuario = await cadastrarUsuario(nome, email, senha);
    return res.status(201).json({ mensagem: 'Conta criada com sucesso!', usuario });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ erro: 'Erro ao cadastrar usuário.' });
  }
});

// ── POST /api/login ────────────────────────────────────────────────────────────
app.post('/api/login', async (req, res) => {
  const { email, senha } = req.body;

  if (!email || !senha)
    return res.status(400).json({ erro: 'Informe e-mail e senha.' });

  try {
    const usuario = await loginUsuario(email, senha);
    if (!usuario)
      return res.status(401).json({ erro: 'E-mail ou senha incorretos.' });

    return res.json({ mensagem: 'Login realizado!', usuario });
  } catch (err) {
    console.error(err);
    return res.status(500).json({ erro: 'Erro ao realizar login.' });
  }
});

// ── GET /api/usuarios ──────────────────────────────────────────────────────────
app.get('/api/usuarios', async (_req, res) => {
  try {
    const usuarios = await listarUsuarios();
    return res.json(usuarios);
  } catch (err) {
    console.error(err);
    return res.status(500).json({ erro: 'Erro ao listar usuários.' });
  }
});

app.listen(PORT, () => {
  console.log(`\n🚀 Servidor rodando em http://localhost:${PORT}`);
  console.log(`   Endpoints:`);
  console.log(`   POST /api/cadastro`);
  console.log(`   POST /api/login`);
  console.log(`   GET  /api/usuarios\n`);
});
