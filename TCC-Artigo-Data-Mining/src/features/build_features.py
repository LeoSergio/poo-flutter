"""
build_features.py — Engenharia de Atributos (Feature Engineering).

Responsabilidades:
  - Calcular indicadores preditivos por aluno a partir dos dados brutos.
  - Produzir a base "achatada" (uma linha por aluno) pronta para o modelo.

Indicadores gerados
-------------------
  semestres_cursados     : estimativa de duração baseada no coorte
  flag_concluinte        : 1 se concluiu, 0 caso contrário
  flag_cancelado         : 1 se cancelou, 0 caso contrário
  classe_atraso          : FLUXO_IDEAL | ATRASO_MODERADO | RETENCAO_SEVERA
  ingressou_periodo_2    : 1 se entrou no 2º semestre do ano

Nota: atributos como IRA, qtd_reprovacoes_ciclo_basico e disciplinas
antecipadas dependem dos microdados de matrículas/notas (ainda não
disponíveis nesta fase). As colunas são reservadas para preenchimento
futuro quando esses dados forem integrados.
"""

import pandas as pd

from src.config import PROCESSED_DIR
from src.data.limpar import limpar, filtrar_cohorts_conclusos


# ─────────────────────────────────────────────────────────────────────────────
def _flag_status(df: pd.DataFrame) -> pd.DataFrame:
    """Cria flags binárias para os principais status."""
    df = df.copy()
    df["flag_concluinte"] = df["status"].str.contains("CONCLU|FORMADO", na=False).astype(int)
    df["flag_cancelado"]  = df["status"].str.contains("CANCEL", na=False).astype(int)
    df["flag_ativo"]      = df["status"].str.contains("ATIVO", na=False).astype(int)
    return df


def _flag_periodo_ingresso(df: pd.DataFrame) -> pd.DataFrame:
    """Indica se o aluno ingressou no 2º semestre (pode influenciar atraso)."""
    df = df.copy()
    df["ingressou_periodo_2"] = (df["periodo_ingresso"] == 2).astype(int)
    return df


def _reservar_colunas_futuras(df: pd.DataFrame) -> pd.DataFrame:
    """
    Reserva colunas que serão preenchidas quando os microdados de notas
    (matriculas_componentes) forem integrados ao projeto.
    """
    df = df.copy()
    for col in ["ira_ciclo_basico", "qtd_reprovacoes_p1", "qtd_reprovacoes_p2",
                "qtd_antecipacoes", "qtd_optativas_cursadas"]:
        if col not in df.columns:
            df[col] = None     # placeholder — preencher em fase futura
    return df


# ─────────────────────────────────────────────────────────────────────────────
def construir_features(df: pd.DataFrame) -> pd.DataFrame:
    """
    Pipeline completo de feature engineering.
    Recebe o DataFrame bruto (já carregado por extrair.py) e
    retorna a base achatada pronta para análise e modelagem.

    Uso:
        from src.features.build_features import construir_features
        df_features = construir_features(df_bruto)
    """
    df = limpar(df)
    df = _flag_status(df)
    df = _flag_periodo_ingresso(df)
    df = _reservar_colunas_futuras(df)

    # Colunas finais na ordem lógica
    colunas_base = [
        "matricula", "nome_discente", "sexo",
        "ano_ingresso", "periodo_ingresso", "ingressou_periodo_2",
        "forma_ingresso", "tipo_discente",
        "status", "flag_concluinte", "flag_cancelado", "flag_ativo",
        "semestres_cursados", "classe_atraso",
        # Atributos futuros (notas/matrículas)
        "ira_ciclo_basico", "qtd_reprovacoes_p1", "qtd_reprovacoes_p2",
        "qtd_antecipacoes", "qtd_optativas_cursadas",
    ]
    colunas_presentes = [c for c in colunas_base if c in df.columns]
    return df[colunas_presentes].reset_index(drop=True)


# ─────────────────────────────────────────────────────────────────────────────
def salvar_base_processada(df_features: pd.DataFrame,
                            nome_arquivo: str = "base_modelo.csv") -> None:
    """Persiste a base processada em data/processed/."""
    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
    destino = PROCESSED_DIR / nome_arquivo
    df_features.to_csv(destino, index=False, encoding="utf-8")
    print(f"  [OK] Base processada salva em: {destino}")
