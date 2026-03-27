package com.financeiro.servlet;

import com.financeiro.dao.LancamentoDAO;
import com.financeiro.model.Lancamento;
import com.financeiro.model.Usuario;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/lancamentos")
public class LancamentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            LancamentoDAO dao = new LancamentoDAO();
            List<Lancamento> lista = dao.listarTodos();
            req.setAttribute("lancamentos", lista);
            req.getRequestDispatcher("/WEB-INF/views/lancamentos.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Erro ao listar lançamentos", e);
        }
    }
}