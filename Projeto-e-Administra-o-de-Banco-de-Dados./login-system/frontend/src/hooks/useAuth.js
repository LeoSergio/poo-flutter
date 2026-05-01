import { useState } from 'react'

export function useAuth() {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  async function login(email, senha) {
    setLoading(true)
    setError('')
    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, senha }),
      })
      const data = await res.json()
      if (!res.ok) { setError(data.erro); return false }
      setUser(data.usuario)
      return true
    } catch {
      setError('Erro de conexão com o servidor.')
      return false
    } finally {
      setLoading(false)
    }
  }

  async function cadastro(nome, email, senha) {
    setLoading(true)
    setError('')
    try {
      const res = await fetch('/api/cadastro', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ nome, email, senha }),
      })
      const data = await res.json()
      if (!res.ok) { setError(data.erro); return false }
      setUser(data.usuario)
      return true
    } catch {
      setError('Erro de conexão com o servidor.')
      return false
    } finally {
      setLoading(false)
    }
  }

  function logout() { setUser(null); setError('') }

  return { user, loading, error, login, cadastro, logout, setError }
}
