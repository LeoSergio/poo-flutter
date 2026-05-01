import { useState } from 'react'

const styles = {
  wrap: {
    minHeight: '100vh',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: '2rem',
    background: 'var(--bg)',
    position: 'relative',
    overflow: 'hidden',
  },
  glow: {
    position: 'absolute',
    width: 500,
    height: 500,
    borderRadius: '50%',
    background: 'radial-gradient(circle, rgba(200,240,96,0.06) 0%, transparent 70%)',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -60%)',
    pointerEvents: 'none',
  },
  card: {
    width: '100%',
    maxWidth: 400,
    position: 'relative',
    zIndex: 1,
  },
  eyebrow: {
    fontFamily: 'var(--font-body)',
    fontSize: 11,
    fontWeight: 500,
    letterSpacing: '0.15em',
    textTransform: 'uppercase',
    color: 'var(--accent)',
    marginBottom: '0.75rem',
  },
  title: {
    fontFamily: 'var(--font-display)',
    fontSize: 38,
    fontWeight: 400,
    lineHeight: 1.1,
    color: 'var(--text)',
    marginBottom: '0.4rem',
  },
  subtitle: {
    fontSize: 14,
    color: 'var(--text-muted)',
    marginBottom: '2.5rem',
    lineHeight: 1.6,
  },
  tabs: {
    display: 'flex',
    gap: 0,
    background: 'var(--surface)',
    border: '1px solid var(--border)',
    borderRadius: 'var(--radius-sm)',
    padding: 3,
    marginBottom: '1.75rem',
  },
  tab: (active) => ({
    flex: 1,
    height: 34,
    border: 'none',
    borderRadius: 6,
    fontSize: 13,
    fontWeight: 500,
    cursor: 'pointer',
    transition: 'all 0.2s',
    background: active ? 'var(--surface2)' : 'transparent',
    color: active ? 'var(--text)' : 'var(--text-muted)',
    fontFamily: 'var(--font-body)',
  }),
  field: { marginBottom: '1.1rem' },
  label: {
    display: 'block',
    fontSize: 12,
    fontWeight: 500,
    color: 'var(--text-muted)',
    marginBottom: 6,
    letterSpacing: '0.03em',
    textTransform: 'uppercase',
  },
  input: {
    width: '100%',
    height: 46,
    padding: '0 14px',
    background: 'var(--surface)',
    border: '1px solid var(--border)',
    borderRadius: 'var(--radius-sm)',
    color: 'var(--text)',
    fontSize: 14,
    outline: 'none',
    transition: 'border-color 0.2s',
    fontFamily: 'var(--font-body)',
  },
  btn: {
    width: '100%',
    height: 48,
    marginTop: '1.25rem',
    background: 'var(--accent)',
    color: '#0e0e10',
    border: 'none',
    borderRadius: 'var(--radius-sm)',
    fontSize: 14,
    fontWeight: 500,
    cursor: 'pointer',
    fontFamily: 'var(--font-body)',
    letterSpacing: '0.02em',
    transition: 'opacity 0.2s, transform 0.1s',
  },
  error: {
    background: 'var(--red-dim)',
    border: '1px solid rgba(255,95,95,0.2)',
    color: 'var(--red)',
    borderRadius: 'var(--radius-sm)',
    padding: '10px 14px',
    fontSize: 13,
    marginBottom: '1rem',
  },
}

export default function AuthForm({ onLogin, onCadastro, loading, error, setError }) {
  const [tab, setTab] = useState('login')
  const [form, setForm] = useState({ nome: '', email: '', senha: '' })

  const set = (k) => (e) => {
    setForm((f) => ({ ...f, [k]: e.target.value }))
    if (error) setError('')
  }

  const submit = (e) => {
    e.preventDefault()
    if (tab === 'login') onLogin(form.email, form.senha)
    else onCadastro(form.nome, form.email, form.senha)
  }

  const switchTab = (t) => { setTab(t); setForm({ nome: '', email: '', senha: '' }); setError('') }

  return (
    <div style={styles.wrap}>
      <div style={styles.glow} />
      <div style={styles.card}>
        <p style={styles.eyebrow}>Sistema de Login</p>
        <h1 style={styles.title}>
          {tab === 'login' ? 'Bem-vindo\nde volta.' : 'Crie sua\nconta.'}
        </h1>
        <p style={styles.subtitle}>
          {tab === 'login'
            ? 'Entre com suas credenciais para acessar o sistema.'
            : 'Preencha os dados abaixo para criar sua conta.'}
        </p>

        <div style={styles.tabs}>
          <button style={styles.tab(tab === 'login')} onClick={() => switchTab('login')}>Entrar</button>
          <button style={styles.tab(tab === 'cadastro')} onClick={() => switchTab('cadastro')}>Cadastrar</button>
        </div>

        {error && <div style={styles.error}>{error}</div>}

        <form onSubmit={submit}>
          {tab === 'cadastro' && (
            <div style={styles.field}>
              <label style={styles.label}>Nome completo</label>
              <input
                style={styles.input}
                type="text"
                placeholder="João Silva"
                value={form.nome}
                onChange={set('nome')}
                required
                onFocus={e => e.target.style.borderColor = 'var(--accent)'}
                onBlur={e => e.target.style.borderColor = 'var(--border)'}
              />
            </div>
          )}

          <div style={styles.field}>
            <label style={styles.label}>E-mail</label>
            <input
              style={styles.input}
              type="email"
              placeholder="seu@email.com"
              value={form.email}
              onChange={set('email')}
              required
              onFocus={e => e.target.style.borderColor = 'var(--accent)'}
              onBlur={e => e.target.style.borderColor = 'var(--border)'}
            />
          </div>

          <div style={styles.field}>
            <label style={styles.label}>Senha</label>
            <input
              style={styles.input}
              type="password"
              placeholder={tab === 'cadastro' ? 'mínimo 6 caracteres' : '••••••••'}
              value={form.senha}
              onChange={set('senha')}
              required
              onFocus={e => e.target.style.borderColor = 'var(--accent)'}
              onBlur={e => e.target.style.borderColor = 'var(--border)'}
            />
          </div>

          <button
            type="submit"
            style={{ ...styles.btn, opacity: loading ? 0.6 : 1 }}
            disabled={loading}
          >
            {loading ? 'Aguarde...' : tab === 'login' ? 'Entrar' : 'Criar conta'}
          </button>
        </form>

        <p style={{ marginTop: '2rem', fontSize: 12, color: 'var(--text-dim)', textAlign: 'center' }}>
          Teste: demo@email.com / demo123
        </p>
      </div>
    </div>
  )
}
