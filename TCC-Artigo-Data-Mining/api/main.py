"""
main.py — Servidor FastAPI para o Sistema de Alerta Precoce (Early Warning System).

Fase 2 do TCC. Expõe o modelo treinado como uma API REST.

Execução:
    uvicorn api.main:app --reload

Documentação automática:
    http://localhost:8000/docs   (Swagger UI)
    http://localhost:8000/redoc  (ReDoc)
"""

from fastapi import FastAPI
from api.rotas import router

app = FastAPI(
    title="Early Warning System — Sistemas de Informação UFRN",
    description=(
        "API preditiva que estima o risco de atraso de um discente "
        "com base em seus atributos de ingresso e desempenho inicial."
    ),
    version="0.1.0",
)

app.include_router(router, prefix="/api/v1")


@app.get("/", tags=["Health"])
def health_check():
    """Verifica se o servidor está no ar."""
    return {"status": "ok", "servico": "Early Warning System"}
