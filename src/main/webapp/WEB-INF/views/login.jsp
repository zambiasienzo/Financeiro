<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ambiente = System.getenv("AMBIENTE");
    if (ambiente == null || ambiente.isEmpty()) {
        ambiente = "LOCAL";
    }

    String corAmbiente = "PRODUÇÃO".equals(ambiente) ? "#16a34a" : "#f59e0b";
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Login - Sistema Financeiro</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
        }
        .card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 48px 40px;
            width: 380px;
        }
        .logo { text-align: center; margin-bottom: 32px; }
        .logo-icon {
            width: 64px; height: 64px;
            background: linear-gradient(135deg, #4ade80, #22c55e);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px; font-size: 28px;
        }
        .logo h1 { color: #fff; font-size: 22px; font-weight: 700; }
        .logo p  { color: rgba(255,255,255,0.5); font-size: 13px; margin-top: 4px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; color: rgba(255,255,255,0.7); font-size: 13px;
                margin-bottom: 8px; font-weight: 500; }
        input {
            width: 100%; padding: 12px 16px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 8px; color: #fff; font-size: 15px;
            outline: none; transition: border-color 0.2s;
        }
        input:focus { border-color: #4ade80; }
        input::placeholder { color: rgba(255,255,255,0.3); }
        .btn {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, #4ade80, #22c55e);
            color: #fff; font-size: 15px; font-weight: 600;
            border: none; border-radius: 8px; cursor: pointer; margin-top: 8px;
        }
        .btn:hover { opacity: 0.9; }
        .erro {
            background: rgba(239,68,68,0.15);
            border: 1px solid rgba(239,68,68,0.4);
            color: #fca5a5; padding: 10px 14px;
            border-radius: 8px; font-size: 13px;
            margin-bottom: 20px; text-align: center;
        }
        .hint { text-align: center; color: rgba(255,255,255,0.35); font-size: 12px; margin-top: 20px; }
    </style>
</head>
<body>
<div style="position:absolute; top:0; left:0; width:100%;
        background:<%= corAmbiente %>; color:white;
        padding:10px; text-align:center; font-weight:bold;">
    Ambiente: <%= ambiente %>
</div>
<div class="card">
    <div class="logo">
        <div class="logo-icon">💰</div>
        <h1>FinançasPro</h1>
        <p>Controle de Despesas e Receitas</p>
    </div>

    <% if (request.getAttribute("erro") != null) { %>
    <div class="erro">${erro}</div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="form-group">
            <label>Usuário</label>
            <input type="text" name="login" placeholder="Digite seu login" required autofocus>
        </div>
        <div class="form-group">
            <label>Senha</label>
            <input type="password" name="senha" placeholder="Digite sua senha" required>
        </div>
        <button type="submit" class="btn">Entrar</button>
    </form>
    <p class="hint">Credenciais: admin / admin123</p>
</div>
</body>
</html>