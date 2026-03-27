<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.financeiro.model.Lancamento,
                 com.financeiro.model.Usuario, java.math.BigDecimal,
                 java.time.format.DateTimeFormatter" %>
<%
    List<Lancamento> lancamentos = (List<Lancamento>) request.getAttribute("lancamentos");
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    BigDecimal totalReceitas = BigDecimal.ZERO;
    BigDecimal totalDespesas = BigDecimal.ZERO;
    for (Lancamento l : lancamentos) {
        if ("RECEITA".equals(l.getTipoLancamento()))
            totalReceitas = totalReceitas.add(l.getValor());
        else
            totalDespesas = totalDespesas.add(l.getValor());
    }
    BigDecimal saldo = totalReceitas.subtract(totalDespesas);
    String corSaldo = saldo.compareTo(BigDecimal.ZERO) >= 0 ? "#4ade80" : "#f87171";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Lançamentos - Sistema Financeiro</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #0f172a; color: #e2e8f0; min-height: 100vh; }
        header {
            background: rgba(255,255,255,0.04);
            border-bottom: 1px solid rgba(255,255,255,0.08);
            padding: 0 32px; display: flex;
            align-items: center; justify-content: space-between; height: 64px;
        }
        .brand { font-size: 18px; font-weight: 700; color: #fff; }
        .user-info { display: flex; align-items: center; gap: 16px; }
        .user-info span { color: rgba(255,255,255,0.6); font-size: 14px; }
        .logout {
            background: rgba(239,68,68,0.15); color: #fca5a5;
            border: 1px solid rgba(239,68,68,0.3);
            padding: 7px 16px; border-radius: 6px;
            text-decoration: none; font-size: 13px;
        }
        main { padding: 32px; max-width: 1200px; margin: 0 auto; }
        h2 { font-size: 22px; font-weight: 700; margin-bottom: 24px; color: #fff; }
        .cards { display: grid; grid-template-columns: repeat(3,1fr); gap: 20px; margin-bottom: 32px; }
        .card {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 12px; padding: 24px;
        }
        .card-label { font-size: 12px; color: rgba(255,255,255,0.5);
                      text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .card-value { font-size: 26px; font-weight: 700; }
        .table-wrapper {
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 12px; overflow: hidden;
        }
        .table-header {
            padding: 20px 24px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            display: flex; justify-content: space-between; align-items: center;
        }
        .table-header h3 { font-size: 15px; font-weight: 600; }
        .count { font-size: 13px; color: rgba(255,255,255,0.4); }
        table { width: 100%; border-collapse: collapse; }
        thead th {
            padding: 12px 20px; font-size: 11px; font-weight: 600;
            text-transform: uppercase; letter-spacing: 1px;
            color: rgba(255,255,255,0.4);
            background: rgba(255,255,255,0.03); text-align: left;
        }
        tbody tr { border-top: 1px solid rgba(255,255,255,0.05); }
        tbody tr:hover { background: rgba(255,255,255,0.04); }
        td { padding: 14px 20px; font-size: 14px; }
        .id-col { color: rgba(255,255,255,0.3); font-size: 12px; }
        .valor-receita { color: #4ade80; font-weight: 600; }
        .valor-despesa { color: #f87171; font-weight: 600; }
        .badge {
            display: inline-block; padding: 3px 10px;
            border-radius: 20px; font-size: 11px; font-weight: 600;
        }
        .badge-receita   { background: rgba(74,222,128,0.15); color: #4ade80; border: 1px solid rgba(74,222,128,0.3); }
        .badge-despesa   { background: rgba(248,113,113,0.15); color: #f87171; border: 1px solid rgba(248,113,113,0.3); }
        .badge-efetivado { background: rgba(59,130,246,0.15);  color: #93c5fd; border: 1px solid rgba(59,130,246,0.3); }
        .badge-aberto    { background: rgba(234,179,8,0.15);   color: #fde047; border: 1px solid rgba(234,179,8,0.3); }
        .badge-cancelado { background: rgba(100,116,139,0.15); color: #94a3b8; border: 1px solid rgba(100,116,139,0.3); }
    </style>
</head>
<body>
<header>
    <div class="brand">💰 FinançasPro</div>
    <div class="user-info">
        <span>Olá, <strong><%= usuario.getNome() %></strong></span>
        <a href="${pageContext.request.contextPath}/logout" class="logout">Sair</a>
    </div>
</header>

<main>
    <h2>Painel de Lançamentos</h2>

    <div class="cards">
        <div class="card">
            <div class="card-label">Total Receitas</div>
            <div class="card-value" style="color:#4ade80">
                R$ <%= String.format("%,.2f", totalReceitas) %>
            </div>
        </div>
        <div class="card">
            <div class="card-label">Total Despesas</div>
            <div class="card-value" style="color:#f87171">
                R$ <%= String.format("%,.2f", totalDespesas) %>
            </div>
        </div>
        <div class="card">
            <div class="card-label">Saldo</div>
            <div class="card-value" style="color:<%= corSaldo %>">
                R$ <%= String.format("%,.2f", saldo) %>
            </div>
        </div>
    </div>

    <div class="table-wrapper">
        <div class="table-header">
            <h3>Lista de Lançamentos</h3>
            <span class="count"><%= lancamentos.size() %> registros</span>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th><th>Descrição</th><th>Data</th>
                    <th>Valor</th><th>Tipo</th><th>Situação</th>
                </tr>
            </thead>
            <tbody>
            <% for (Lancamento l : lancamentos) {
                String tipoClass  = l.getTipoLancamento().toLowerCase();
                String sitClass   = l.getSituacao().toLowerCase();
                String valorClass = "RECEITA".equals(l.getTipoLancamento()) ? "valor-receita" : "valor-despesa";
                String sinal      = "RECEITA".equals(l.getTipoLancamento()) ? "+" : "-";
            %>
                <tr>
                    <td class="id-col"><%= l.getId() %></td>
                    <td><%= l.getDescricao() %></td>
                    <td><%= l.getDataLancamento().format(fmt) %></td>
                    <td class="<%= valorClass %>"><%= sinal %> R$ <%= String.format("%,.2f", l.getValor()) %></td>
                    <td><span class="badge badge-<%= tipoClass %>"><%= l.getTipoLancamento() %></span></td>
                    <td><span class="badge badge-<%= sitClass %>"><%= l.getSituacao() %></span></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>