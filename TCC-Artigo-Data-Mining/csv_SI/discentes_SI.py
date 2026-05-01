import pandas as pd
import os
import re
import glob

# ==============================================================================
# CONFIGURAÇÕES
# ==============================================================================
ID_CURSO_SI = '7191770.0'
PASTA_DISCENTES = os.path.join("csv", "discentes")
ARQUIVO_SAIDA = os.path.join("csv", "TODOS_ALUNOS_SISTEMAS_INFORMACAO_ID_7191770.0.csv")

# ==============================================================================
# FUNÇÃO DE LEITURA ROBUSTA
# ==============================================================================
def ler_csv_robusto(arquivo_csv):
    """
    Lê um CSV tentando diferentes encodings e separadores.
    Retorna um DataFrame ou None em caso de falha.
    """
    configs = [
        {'encoding': 'utf-8',   'sep': ';'},
        {'encoding': 'utf-8',   'sep': ','},
        {'encoding': 'latin-1', 'sep': ';'},
        {'encoding': 'latin-1', 'sep': ','},
        {'encoding': 'cp1252',  'sep': ';'},
        {'encoding': 'cp1252',  'sep': ','},
        {'encoding': 'utf-8',   'sep': ';', 'on_bad_lines': 'skip'},
        {'encoding': 'utf-8',   'sep': ',', 'on_bad_lines': 'skip'},
    ]
    for config in configs:
        try:
            df = pd.read_csv(arquivo_csv, **config)
            if len(df.columns) > 3:
                return df
        except Exception:
            continue
    try:
        return pd.read_csv(arquivo_csv, sep=None, engine='python', on_bad_lines='skip')
    except Exception:
        return None

# ==============================================================================
# FUNÇÃO DE FILTRAGEM POR CURSO
# ==============================================================================
def filtrar_por_curso(df, id_curso=ID_CURSO_SI, coluna='id_curso'):
    """
    Filtra o DataFrame pelo id_curso informado.
    Busca a coluna automaticamente se o nome exato não existir.
    """
    if coluna not in df.columns:
        candidatas = [c for c in df.columns
                      if any(p in c.lower() for p in ['id_curso', 'idcurso', 'curso_id', 'cod_curso'])]
        if not candidatas:
            return pd.DataFrame()
        coluna = candidatas[0]

    df[coluna] = df[coluna].astype(str).str.strip()
    return df[df[coluna] == str(id_curso)].copy()

# ==============================================================================
# GERAÇÃO DO CSV CONSOLIDADO (2009 - 2026)
# ==============================================================================
def gerar_csv_todos_alunos():
    """
    Varre AUTOMATICAMENTE todos os arquivos CSV da pasta csv/discentes/,
    filtra os alunos de Sistemas de Informação (id_curso = 7191770.0)
    e gera um único CSV consolidado cobrindo 2009 a 2026.
    """
    print("\n=== Gerando CSV consolidado de alunos de Sistemas de Informacao ===")

    if not os.path.isdir(PASTA_DISCENTES):
        print(f"ERRO: Pasta nao encontrada: {PASTA_DISCENTES}")
        return

    # Pega todos os .csv da pasta, ordenados pelo nome (cronologico)
    arquivos = sorted(glob.glob(os.path.join(PASTA_DISCENTES, "*.csv")))
    if not arquivos:
        print("ERRO: Nenhum arquivo CSV encontrado na pasta de discentes.")
        return

    todos_os_dados = []

    for arquivo in arquivos:
        df = ler_csv_robusto(arquivo)
        if df is None:
            print(f"  [AVISO] Nao foi possivel ler: {arquivo}")
            continue

        filtrado = filtrar_por_curso(df)
        if filtrado.empty:
            print(f"  [INFO]  Nenhum aluno de SI em: {os.path.basename(arquivo)}")
            continue

        # Extrai o ano a partir do nome do arquivo (aceita discentes_YYYY.csv e discentes-YYYY.csv)
        match = re.search(r'(\d{4})', os.path.basename(arquivo))
        ano = int(match.group(1)) if match else None
        filtrado['ano_arquivo'] = ano

        todos_os_dados.append(filtrado)
        print(f"  [OK]    {os.path.basename(arquivo):30s} -> {len(filtrado):3d} alunos de SI")

    if not todos_os_dados:
        print("Nenhum aluno de Sistemas de Informacao encontrado.")
        return

    df_final = pd.concat(todos_os_dados, ignore_index=True)

    # Remove duplicatas mantendo o registro mais recente por matricula
    df_final['matricula_str'] = df_final['matricula'].astype(str).str.strip()
    df_final = (df_final
                .sort_values('ano_arquivo', ascending=False)
                .drop_duplicates(subset='matricula_str', keep='first')
                .sort_values(['ano_arquivo', 'matricula_str'])
                .drop(columns='matricula_str')
                .reset_index(drop=True))

    # Garante que a pasta de saida existe
    os.makedirs(os.path.dirname(ARQUIVO_SAIDA), exist_ok=True)
    df_final.to_csv(ARQUIVO_SAIDA, index=False, encoding='utf-8')

    anos_cobertos = sorted(df_final['ano_arquivo'].dropna().astype(int).unique())
    print(f"\n  CSV consolidado gerado: '{ARQUIVO_SAIDA}'")
    print(f"   Total de alunos unicos : {len(df_final)}")
    print(f"   Anos cobertos          : {anos_cobertos[0]} - {anos_cobertos[-1]}")
    print(f"   Arquivos processados   : {len(todos_os_dados)}")

# ==============================================================================
# EXECUÇÃO
# ==============================================================================
if __name__ == "__main__":
    gerar_csv_todos_alunos()
    print("\nProcessamento concluido.")
