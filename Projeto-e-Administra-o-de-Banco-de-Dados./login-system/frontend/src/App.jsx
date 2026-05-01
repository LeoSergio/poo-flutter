import { useAuth } from './hooks/useAuth'
import AuthForm from './components/AuthForm'
import Dashboard from './components/Dashboard'

export default function App() {
  const { user, loading, error, login, cadastro, logout, setError } = useAuth()

  if (user) return <Dashboard user={user} onLogout={logout} />

  return (
    <AuthForm
      onLogin={login}
      onCadastro={cadastro}
      loading={loading}
      error={error}
      setError={setError}
    />
  )
}
