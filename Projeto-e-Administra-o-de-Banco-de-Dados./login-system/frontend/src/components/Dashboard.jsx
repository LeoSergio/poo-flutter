import { useState, useEffect } from 'react'

const s = {
  wrap: {
    minHeight: '100vh',
    background: 'var(--bg)',
    padding: '0',
    display: 'flex',
    flexDirection: 'column',
  },
  nav: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: '1.25rem 2rem',
    borderBottom: '1px solid var(--border)',
    background: 'var(--surface)',
  },
  navBrand: {
    fontFamily: 'var(--font-display)',
    fontSize: 20,
    color: 'var(--text)',
  },
  navRight: { display: 'flex', alignItems: 'center', gap: 12 },
  avatar: {
    width: 34,
    height: 34,
    borderRadius: '50%',
    background: 'var(--accent-dim)',
    border: '1px solid rgba(200,240,96,0.3)',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 12,
    fontWeight: 500,
    color: 'var(--accent)',
  },
  logoutBtn: {
    background: 'transparent',
    border: '1px solid var(--border)',
    color: 'var(--text-muted)',
    padding: '6px 14px',
    borderRadius: 'var(--radius-sm)',
    fontSize: 13,
    cursor: 'pointer',
    fontFamily: 'var(--font-body)',
    transition: 'all 0.2s',
  },
  main: { flex: 1, padding: '3rem 2rem', maxWidth: 800, margin: '0 auto', width: '100%' },
  greeting: {
    fontFamily: 'var(--font-display)',
    fontSize: 32,
    color: 'var(--text)',
    marginBottom: '0.4rem',
  },
  greetingSub: { fontSize: 14, color: 'var(--text-muted)', marginBottom: '2.5rem' },
  grid: { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: '2rem' },
  card: {
    background: 'var(--surface)',
    border: '1px solid var(--border)',
    borderRadius: 'var(--radius)',
    padding: '1.25rem 1.5rem',
  },
  cardLabel: { fontSize: 11, fontWeight: 500, letterSpacing: '0.12em', textTransform: 'uppercase', color: 'var(--text-dim)', marginBottom: 6 },
  cardValue: { fontSize: 14, color: 'var(--text)', wordBreak: 'break-all' },
  section: { marginTop: '2rem' },
  sectionTitle: {
    fontSize: 11,
    fontWeight: 500,
    letterSpacing: '0.12em',
    textTransform: 'uppercase',
    color: 'var(--text-dim)',
    marginBottom: '1rem',
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  badge: {
    background: 'var(--accent-dim)',
    color: 'var(--accent)',
    borderRadius: 99,
    padding: '2px 8px',
    fontSize: 10,
    fontWeight: 500,
  },
  table: {
    width: '100%',
    borderCollapse: 'collapse',
    fontSize: 13,
    background: 'var(--surface)',
    border: '1px solid var(--border)',
    borderRadius: 'var(--radius)',
    overflow: 'hidden',
  },
  th: {
    textAlign: 'left',
    padding: '10px 16px',
    fontSize: 11,
    fontWeight: 500,
    letterSpacing: '0.1em',
    textTransform: 'uppercase',
    color: 'var(--text-dim)',
    borderBottom: '1px solid var(--border)',
    background: 'var(--surface2)',
  },
  td: {
    padding: '10px 16px',
    color: 'var(--text-muted)',
    borderBottom: '1px solid var(--border)',
  },
  dot: {
    display: 'inline-block',
    width: 6,
    height: 6,
    borderRadius: '50%',
    background: 'var(--accent)',
    marginRight: 6,
  },
}

export default function Dashboard({ user, onLogout }) {
  const [usuarios, setUsuarios] = useState([])
  const [loadingUsers, setLoadingUsers] = useState(true)

  useEffect(() => {
    fetch('/api/usuarios')
      .then(r => r.json())
      .then(data => { setUsuarios(data); setLoadingUsers(false) })
      .catch(() => setLoadingUsers(false))
  }, [])

  const initials = user.nome.split(' ').map(w => w[0]).slice(0, 2).join('').toUpperCase()
  const hora = new Date().getHours()
  const saudacao = hora < 12 ? 'Bom dia' : hora < 18 ? 'Boa tarde' : 'Boa noite'

  return (
    <div style={s.wrap}>
      <nav style={s.nav}>
        <span style={s.navBrand}>Login System</span>
        <div style={s.navRight}>
          <div style={s.avatar}>{initials}</div>
          <button
            style={s.logoutBtn}
            onClick={onLogout}
            onMouseEnter={e => { e.target.style.borderColor = 'var(--border-hover)'; e.target.style.color = 'var(--text)' }}
            onMouseLeave={e => { e.target.style.borderColor = 'var(--border)'; e.target.style.color = 'var(--text-muted)' }}
          >
            Sair
          </button>
        </div>
      </nav>

      <main style={s.main}>
        <h2 style={s.greeting}>{saudacao}, {user.nome.split(' ')[0]}.</h2>
        <p style={s.greetingSub}>Login realizado com sucesso via Prisma ORM.</p>

        <div style={s.grid}>
          <div style={s.card}>
            <p style={s.cardLabel}>ID no banco</p>
            <p style={s.cardValue}>#{user.id}</p>
          </div>
          <div style={s.card}>
            <p style={s.cardLabel}>Nome</p>
            <p style={s.cardValue}>{user.nome}</p>
          </div>
          <div style={{ ...s.card, gridColumn: '1 / -1' }}>
            <p style={s.cardLabel}>E-mail</p>
            <p style={s.cardValue}>{user.email}</p>
          </div>
        </div>

        <div style={s.section}>
          <p style={s.sectionTitle}>
            <span style={s.dot} />
            Usuários cadastrados (GET /api/usuarios)
            {!loadingUsers && <span style={s.badge}>{usuarios.length}</span>}
          </p>

          {loadingUsers ? (
            <p style={{ color: 'var(--text-dim)', fontSize: 13 }}>Carregando...</p>
          ) : (
            <table style={s.table}>
              <thead>
                <tr>
                  <th style={s.th}>ID</th>
                  <th style={s.th}>Nome</th>
                  <th style={s.th}>E-mail</th>
                  <th style={s.th}>Cadastro</th>
                </tr>
              </thead>
              <tbody>
                {usuarios.map((u, i) => (
                  <tr key={u.id} style={{ background: u.id === user.id ? 'rgba(200,240,96,0.04)' : 'transparent' }}>
                    <td style={s.td}>{u.id}</td>
                    <td style={{ ...s.td, color: u.id === user.id ? 'var(--accent)' : 'var(--text)' }}>
                      {u.nome} {u.id === user.id && <span style={{ fontSize: 11, opacity: 0.6 }}>(você)</span>}
                    </td>
                    <td style={s.td}>{u.email}</td>
                    <td style={s.td}>
                      {new Date(u.criadoEm || u.criado_em).toLocaleDateString('pt-BR')}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </main>
    </div>
  )
}
