import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import os

plt.rcParams['figure.figsize'] = [10, 6]

# ==============================================================================
# CARREGAMENTO DOS DADOS
# ==============================================================================
caminho_csv = os.path.join("..", "csv", "TODOS_ALUNOS_SISTEMAS_INFORMACAO_ID_7191770.0.csv")

try:
    if not os.path.exists(caminho_csv):
        st.error(f"Arquivo não encontrado: {caminho_csv}")
        st.info("Execute primeiro o script `discentes_SI.py` para gerar o CSV consolidado.")
        st.stop()

    df = pd.read_csv(caminho_csv)

    # Normalização
    df["status"] = df["status"].astype(str).str.strip().str.upper()
    df["ano_ingresso"] = pd.to_numeric(df["ano_ingresso"], errors="coerce")
    df["periodo_ingresso"] = pd.to_numeric(df["periodo_ingresso"], errors="coerce").fillna(1)
    df = df.dropna(subset=["ano_ingresso"])
    df["ano_ingresso"] = df["ano_ingresso"].astype(int)

    # Máscara de concluintes (CONCLUÍDO ou FORMADO)
    mask_conc = df["status"].str.contains("CONCLU|FORMADO", na=False)

    # ==============================================================================
    # CABEÇALHO
    # ==============================================================================
    st.title("🎓 Dashboard de Concluintes — Sistemas de Informação")
    st.markdown("Análise dos alunos que concluíram o curso de Sistemas de Informação (2009 – 2026).")

    # ==============================================================================
    # MÉTRICAS GERAIS
    # ==============================================================================
    total = len(df)
    n_conc = mask_conc.sum()
    n_cancel = df["status"].str.contains("CANCEL", na=False).sum()
    n_ativo = df["status"].str.contains("ATIVO", na=False).sum()
    taxa_conc = (n_conc / total * 100) if total > 0 else 0

    c1, c2, c3, c4 = st.columns(4)
    c1.metric("Total de Alunos", f"{total:,}")
    c2.metric("Concluintes", f"{n_conc:,}", f"{taxa_conc:.1f}%")
    c3.metric("Cancelados", f"{n_cancel:,}", f"{n_cancel/total*100:.1f}%", delta_color="inverse")
    c4.metric("Ativos", f"{n_ativo:,}")

    st.divider()

    # ==============================================================================
    # HISTOGRAMA PRINCIPAL — CONCLUINTES POR SEMESTRES CURSADOS
    # ==============================================================================
    st.subheader("📊 Histograma de Concluintes por Semestres Cursados")

    st.markdown(
        """
        **Como é calculado:** cada arquivo anual representa a turma que ingressou naquele ano.
        O número de semestres é estimado como `(2024 − ano_ingresso) × 2`.
        Por exemplo, a turma de 2020 (8 semestres) e a de 2016 (16 semestres).
        """
    )

    # Filtra apenas concluintes e calcula semestres
    df_conc = df[mask_conc].copy()
    SNAPSHOT_ANO = 2024
    df_conc["semestres_cursados"] = (SNAPSHOT_ANO - df_conc["ano_ingresso"]) * 2

    # Faixa razoável: 8 a 20 semestres (4 a 10 anos)
    df_hist = df_conc[df_conc["semestres_cursados"].between(8, 20)]
    hist_data = df_hist.groupby("semestres_cursados").size().reset_index(name="quantidade")

    if hist_data.empty:
        st.warning("Sem dados suficientes para o histograma.")
    else:
        fig_hist, ax = plt.subplots(figsize=(10, 6))

        bars = ax.bar(
            hist_data["semestres_cursados"],
            hist_data["quantidade"],
            color="#2196F3",
            edgecolor="white",
            linewidth=0.8,
            width=0.7,
        )

        # Rótulos nas barras
        for bar, val in zip(bars, hist_data["quantidade"]):
            ax.text(
                bar.get_x() + bar.get_width() / 2,
                bar.get_height() + 0.3,
                str(val),
                ha="center", va="bottom",
                fontsize=11, fontweight="bold", color="#1a237e"
            )

        ax.set_title("Concluintes por Número de Semestres Cursados", fontsize=14, pad=15)
        ax.set_xlabel("Semestres cursados até a conclusão", fontsize=12)
        ax.set_ylabel("Quantidade de concluintes", fontsize=12)
        ax.set_xticks(hist_data["semestres_cursados"])
        ax.set_xticklabels(
            [f"Sem. {s}" for s in hist_data["semestres_cursados"]],
            rotation=0, fontsize=11
        )
        ax.yaxis.set_major_locator(mticker.MaxNLocator(integer=True))
        ax.grid(axis="y", alpha=0.3, linestyle="--")
        ax.spines[["top", "right"]].set_visible(False)

        st.pyplot(fig_hist)

        # Tabela resumo
        with st.expander("Ver tabela de dados do histograma"):
            tabela = hist_data.copy()
            tabela.columns = ["Semestres Cursados", "Nº de Concluintes"]
            st.dataframe(tabela.set_index("Semestres Cursados"), use_container_width=True)

    st.divider()

    # ==============================================================================
    # CONCLUINTES POR ANO DE INGRESSO (turma)
    # ==============================================================================
    st.subheader("📅 Concluintes por Turma (Ano de Ingresso)")

    resumo_turma = (
        df.groupby("ano_ingresso")
        .agg(
            total=("status", "count"),
            concluintes=("status", lambda x: x.str.contains("CONCLU|FORMADO", na=False).sum()),
            cancelados=("status", lambda x: x.str.contains("CANCEL", na=False).sum()),
            ativos=("status", lambda x: x.str.contains("ATIVO", na=False).sum()),
        )
        .reset_index()
    )
    resumo_turma["taxa_conclusao_%"] = (
        resumo_turma["concluintes"] / resumo_turma["total"] * 100
    ).round(1)

    fig2, ax2 = plt.subplots(figsize=(12, 6))
    cores = ["#2196F3" if c > 0 else "#B0BEC5" for c in resumo_turma["concluintes"]]
    bars2 = ax2.bar(resumo_turma["ano_ingresso"], resumo_turma["concluintes"],
                    color=cores, edgecolor="white", width=0.7)

    for bar, val in zip(bars2, resumo_turma["concluintes"]):
        if val > 0:
            ax2.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.1,
                     str(val), ha="center", va="bottom", fontsize=9, fontweight="bold")

    ax2.set_title("Número de Concluintes por Turma (Ano de Ingresso)", fontsize=14, pad=15)
    ax2.set_xlabel("Ano de Ingresso", fontsize=12)
    ax2.set_ylabel("Concluintes", fontsize=12)
    ax2.set_xticks(resumo_turma["ano_ingresso"])
    ax2.tick_params(axis="x", rotation=45)
    ax2.yaxis.set_major_locator(mticker.MaxNLocator(integer=True))
    ax2.grid(axis="y", alpha=0.3, linestyle="--")
    ax2.spines[["top", "right"]].set_visible(False)
    st.pyplot(fig2)

    st.divider()

    # ==============================================================================
    # EVOLUÇÃO TEMPORAL — TAXAS DE CONCLUSÃO E CANCELAMENTO
    # ==============================================================================
    st.subheader("📈 Evolução das Taxas de Conclusão e Cancelamento (2009–2024)")

    df_evo = resumo_turma[(resumo_turma["ano_ingresso"] >= 2009) &
                          (resumo_turma["ano_ingresso"] <= 2024)].copy()
    df_evo["taxa_cancelados_%"] = (df_evo["cancelados"] / df_evo["total"] * 100).round(1)

    fig3, ax3 = plt.subplots(figsize=(12, 6))
    ax3.plot(df_evo["ano_ingresso"], df_evo["taxa_conclusao_%"],
             marker="o", linewidth=2, label="Taxa de Conclusão (%)", color="#2196F3")
    ax3.plot(df_evo["ano_ingresso"], df_evo["taxa_cancelados_%"],
             marker="s", linewidth=2, linestyle="--", label="Taxa de Cancelamento (%)", color="#F44336")
    ax3.set_title("Evolução das Taxas de Conclusão e Cancelamento por Turma", fontsize=14, pad=15)
    ax3.set_xlabel("Ano de Ingresso", fontsize=12)
    ax3.set_ylabel("Percentual (%)", fontsize=12)
    ax3.legend(fontsize=11)
    ax3.grid(True, alpha=0.3, linestyle="--")
    ax3.tick_params(axis="x", rotation=45)
    ax3.spines[["top", "right"]].set_visible(False)
    st.pyplot(fig3)

    st.divider()

    # ==============================================================================
    # TABELA COMPLETA POR TURMA
    # ==============================================================================
    st.subheader("📋 Resumo Completo por Turma")
    tabela_final = resumo_turma.rename(columns={
        "ano_ingresso": "Ano Ingresso",
        "total": "Total",
        "concluintes": "Concluintes",
        "cancelados": "Cancelados",
        "ativos": "Ativos",
        "taxa_conclusao_%": "Taxa Conclusão (%)",
    })
    st.dataframe(tabela_final.set_index("Ano Ingresso"), use_container_width=True)

    # ==============================================================================
    # DETALHAMENTO POR STATUS
    # ==============================================================================
    st.subheader("🔍 Filtrar por Ano de Ingresso")
    anos_disp = sorted(df["ano_ingresso"].unique())
    ano_sel = st.selectbox("Selecione o ano de ingresso", options=anos_disp)
    df_sel = df[df["ano_ingresso"] == ano_sel]

    c1, c2, c3 = st.columns(3)
    c1.metric("Ingressantes", len(df_sel))
    c2.metric("Concluintes", df_sel["status"].str.contains("CONCLU|FORMADO", na=False).sum())
    c3.metric("Cancelados", df_sel["status"].str.contains("CANCEL", na=False).sum())

    fig_pie, ax_pie = plt.subplots(figsize=(7, 5))
    contagem = df_sel["status"].value_counts()
    cores_pie = {"CONCLUÍDO": "#4CAF50", "FORMADO": "#66BB6A",
                 "CANCELADO": "#F44336", "ATIVO": "#2196F3",
                 "ATIVO - FORMANDO": "#42A5F5", "TRANCADO": "#FF9800"}
    c_list = [cores_pie.get(s, "#90A4AE") for s in contagem.index]
    ax_pie.pie(contagem.values, labels=contagem.index, autopct="%1.1f%%",
               colors=c_list, startangle=90)
    ax_pie.set_title(f"Distribuição de Status — Turma {ano_sel}", fontsize=13)
    st.pyplot(fig_pie)

    st.dataframe(df_sel.reset_index(drop=True), use_container_width=True)

except Exception as e:
    st.error(f"Erro inesperado: {e}")
    st.exception(e)
