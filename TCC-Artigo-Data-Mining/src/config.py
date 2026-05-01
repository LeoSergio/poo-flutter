"""
config.py — Configurações centrais do projeto TCC.
Todos os módulos importam daqui. Nunca use caminhos hardcoded fora deste arquivo.
"""

from pathlib import Path

# ── Raiz do projeto (dois níveis acima deste arquivo: src/config.py → raiz) ──
ROOT_DIR = Path(__file__).resolve().parent.parent

# ── Dados ────────────────────────────────────────────────────────────────────
DATA_DIR       = ROOT_DIR / "data"
RAW_DIR        = DATA_DIR / "raw"           # CSVs originais da UFRN (nunca altere)
PROCESSED_DIR  = DATA_DIR / "processed"    # Base achatada pronta para o modelo

# CSV consolidado de discentes de SI (gerado por csv_SI/discentes_SI.py)
CSV_DISCENTES_SI = ROOT_DIR / "csv_SI" / "csv" / "TODOS_ALUNOS_SISTEMAS_INFORMACAO_ID_7191770.0.csv"

# ── Modelos ──────────────────────────────────────────────────────────────────
MODELS_DIR     = ROOT_DIR / "models"        # Modelos treinados (.pkl / .joblib)
MODELS_DIR.mkdir(parents=True, exist_ok=True)

# ── Parâmetros do domínio ─────────────────────────────────────────────────────
ID_CURSO_SI          = "7191770.0"          # ID do curso no sistema da UFRN
SEMESTRES_IDEAIS     = 8                    # Duração prevista do curso
SNAPSHOT_ANO         = 2024                 # Ano de referência para cálculo de semestres

# Classes de atraso (usadas no modelo de classificação)
CLASSES_ATRASO = {
    "FLUXO_IDEAL":      (0, 8),             # Concluiu em até 8 semestres
    "ATRASO_MODERADO":  (9, 12),            # 9 a 12 semestres
    "RETENCAO_SEVERA":  (13, 999),          # 13+ semestres
}

# ── Parâmetros de ETL ─────────────────────────────────────────────────────────
ENCODING_PADRAO    = "utf-8"
SEPARADORES_CSV    = [";", ","]
