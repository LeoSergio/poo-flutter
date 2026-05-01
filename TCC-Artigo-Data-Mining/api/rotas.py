"""
rotas.py — Endpoints da API do Sistema de Alerta Precoce.

Endpoints disponíveis:
  POST /api/v1/prever       <- Prediz a classe de risco de um aluno
  GET  /api/v1/classes      <- Lista as classes de atraso e suas definições
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from src.models.predict import prever
from src.config import CLASSES_ATRASO

router = APIRouter()


# ── Schemas de entrada e saída ────────────────────────────────────────────────

class DadosAluno(BaseModel):
    """Atributos de um aluno para predição de risco de atraso."""
    ano_ingresso: int = Field(..., ge=2009, le=2030,
                               example=2023,
                               description="Ano de ingresso do aluno")
    ingressou_periodo_2: int = Field(0, ge=0, le=1,
                                      example=0,
                                      description="1 se ingressou no 2º semestre, 0 se no 1º")
    # Atributos futuros (fase 2) — opcionais por enquanto
    ira_ciclo_basico: float | None = Field(None, description="IRA ao fim do ciclo básico")
    qtd_reprovacoes_p1: int | None = Field(None, description="Reprovações no 1º período")
    qtd_reprovacoes_p2: int | None = Field(None, description="Reprovações no 2º período")


class ResultadoPredição(BaseModel):
    classe: str
    probabilidades: dict[str, float]
    descricao: str


# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.post("/prever", response_model=ResultadoPredição, tags=["Predição"])
def endpoint_prever(aluno: DadosAluno):
    """
    Recebe os atributos de um aluno e retorna a classe de risco de atraso prevista.
    """
    try:
        dados = aluno.model_dump(exclude_none=True)
        resultado = prever(dados)
    except FileNotFoundError:
        raise HTTPException(
            status_code=503,
            detail="Modelo não encontrado. Execute src/models/train.py primeiro."
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    descricoes = {
        "FLUXO_IDEAL":     "Aluno com perfil de conclusão dentro do prazo ideal (≤ 8 semestres).",
        "ATRASO_MODERADO": "Aluno com perfil de conclusão com atraso moderado (9–12 semestres).",
        "RETENCAO_SEVERA": "Aluno com perfil de retenção severa (≥ 13 semestres). Recomenda-se acompanhamento.",
    }

    return ResultadoPredição(
        classe=resultado["classe"],
        probabilidades=resultado["probabilidades"],
        descricao=descricoes.get(resultado["classe"], ""),
    )


@router.get("/classes", tags=["Informações"])
def listar_classes():
    """Retorna as definições das classes de atraso utilizadas pelo modelo."""
    return {
        nome: {"semestre_min": v[0], "semestre_max": v[1]}
        for nome, v in CLASSES_ATRASO.items()
    }
