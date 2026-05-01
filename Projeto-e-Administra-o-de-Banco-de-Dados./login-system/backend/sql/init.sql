-- Criação da tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id         SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    senha      VARCHAR(255) NOT NULL,
    criado_em  TIMESTAMP DEFAULT NOW()
);

-- Usuário de demonstração (senha: demo123)
INSERT INTO usuarios (nome, email, senha)
VALUES ('Demo User', 'demo@email.com', 'demo123')
ON CONFLICT (email) DO NOTHING;
