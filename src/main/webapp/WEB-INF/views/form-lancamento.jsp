<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.financeiro.model.Lancamento, com.financeiro.model.Usuario" %>
<%
    Lancamento l = (Lancamento) request.getAttribute("lancamento");
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean editando = (l != null);
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title><%= editando ? "Editar" : "Novo" %> Lançamento - Sistema Financeiro</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: #0f172a;
            color: #e2e8f0;
            min-height: 100vh;
        }

        /* ── HEADER ── */
        header {
            background: rgba(255,255,255,0.04);
            border-bottom: 1px solid rgba(255,255,255,0.08);
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
        }

        .brand { font-size: 18px; font-weight: 700; color: #fff; }

        .user-info { display: flex; align-items: center; gap: 16px; }
        .user-info span { color: rgba(255,255,255,0.6); font-size: 14px; }

        .btn-logout {
            background: rgba(239,68,68,0.15);
            color: #fca5a5;
            border: 1px solid rgba(239,68,68,0.3);
            padding: 7px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
        }

        /* ── MAIN ── */
        main {
            padding: 32px;
            max-width: 600px;
            margin: 0 auto;
        }

        .main-top {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 28px;
        }

        .btn-voltar {
            background: rgba(255,255,255,0.06);
            color: rgba(255,255,255,0.5);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 6px 12px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
        }

        .btn-voltar:hover { background: rgba(255,255,255,0.09); color: #e2e8f0; }

        h2 { font-size: 22px; font-weight: 700; color: #fff; }

        /* ── CARD DO FORM ── */
        .form-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 32px;
        }

        /* ── CAMPOS ── */
        .field { margin-bottom: 20px; }

        label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: rgba(255,255,255,0.5);
            margin-bottom: 8px;
        }

        input[type="text"],
        input[type="date"],
        input[type="number"],
        select {
            width: 100%;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 8px;
            color: #e2e8f0;
            font-size: 14px;
            font-family: 'Segoe UI', sans-serif;
            padding: 10px 14px;
            outline: none;
            transition: border-color 0.15s;
        }

        input[type="text"]:focus,
        input[type="date"]:focus,
        input[type="number"]:focus,
        select:focus {
            border-color: rgba(99,179,237,0.5);
        }

        input[type="date"]::-webkit-calendar-picker-indicator { filter: invert(0.6); cursor: pointer; }

        select option { background: #1e293b; color: #e2e8f0; }

        /* ── GRID 2 COLUNAS ── */
        .field-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        /* ── DIVISOR ── */
        .divider {
            border: none;
            border-top: 1px solid rgba(255,255,255,0.08);
            margin: 24px 0;
        }

        /* ── AÇÕES ── */
        .form-actions { display: flex; align-items: center; justify-content: flex-end; gap: 12px; }

        .btn-cancelar {
            background: transparent;
            color: rgba(255,255,255,0.4);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 9px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-cancelar:hover { background: rgba(255,255,255,0.05); color: #e2e8f0; }

        .btn-salvar {
            background: rgba(74,222,128,0.15);
            color: #4ade80;
            border: 1px solid rgba(74,222,128,0.3);
            padding: 9px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Segoe UI', sans-serif;
            transition: background 0.15s;
        }

        .btn-salvar:hover { background: rgba(74,222,128,0.25); }
    </style>
</head>

<body>

<header>
    <div class="brand">💰 FinançasPro</div>
    <div class="user-info">
        <% if (usuario != null) { %>
        <span>Olá, <strong><%= usuario.getNome() %></strong></span>
        <% } %>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sair</a>
    </div>
</header>

<main>

    <div class="main-top">
        <a href="${pageContext.request.contextPath}/lancamentos" class="btn-voltar">← Voltar</a>
        <h2><%= editando ? "Editar" : "Novo" %> Lançamento</h2>
    </div>

    <div class="form-card">
        <form method="post" action="${pageContext.request.contextPath}/lancamentos">
            <input type="hidden" name="acao" value="salvar"/>
            <% if (editando) { %>
            <input type="hidden" name="id" value="<%= l.getId() %>"/>
            <% } %>

            <div class="field">
                <label for="descricao">Descrição</label>
                <input type="text" id="descricao" name="descricao"
                       value="<%= editando ? l.getDescricao() : "" %>"
                       placeholder="Ex: Salário, Aluguel..." required/>
            </div>

            <div class="field-row">
                <div class="field">
                    <label for="data">Data</label>
                    <input type="date" id="data" name="data"
                           value="<%= editando ? l.getDataLancamento() : "" %>" required/>
                </div>
                <div class="field">
                    <label for="valor">Valor (R$)</label>
                    <input type="number" id="valor" name="valor" step="0.01" min="0"
                           value="<%= editando ? l.getValor() : "" %>"
                           placeholder="0,00" required/>
                </div>
            </div>

            <div class="field-row">
                <div class="field">
                    <label for="tipo">Tipo</label>
                    <select id="tipo" name="tipo">
                        <option value="RECEITA" <%= editando && "RECEITA".equals(l.getTipoLancamento()) ? "selected" : "" %>>Receita</option>
                        <option value="DESPESA" <%= editando && "DESPESA".equals(l.getTipoLancamento()) ? "selected" : "" %>>Despesa</option>
                    </select>
                </div>
                <div class="field">
                    <label for="situacao">Situação</label>
                    <select id="situacao" name="situacao">
                        <option value="ABERTO"    <%= editando && "ABERTO".equals(l.getSituacao())    ? "selected" : "" %>>Aberto</option>
                        <option value="EFETIVADO" <%= editando && "EFETIVADO".equals(l.getSituacao()) ? "selected" : "" %>>Efetivado</option>
                    </select>
                </div>
            </div>

            <hr class="divider"/>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/lancamentos" class="btn-cancelar">Cancelar</a>
                <button type="submit" class="btn-salvar">
                    <%= editando ? "Salvar alterações" : "Criar lançamento" %>
                </button>
            </div>

        </form>
    </div>

</main>
</body>
</html>
