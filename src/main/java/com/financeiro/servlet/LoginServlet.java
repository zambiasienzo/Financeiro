package com.financeiro.servlet;

import com.financeiro.dao.UsuarioDAO;
import com.financeiro.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String login = req.getParameter("login");
        String senha = req.getParameter("senha");

        try {
            UsuarioDAO dao = new UsuarioDAO();
            Usuario usuario = dao.autenticar(login, senha);

            if (usuario != null) {
                HttpSession session = req.getSession();
                session.setAttribute("usuario", usuario);
                resp.sendRedirect(req.getContextPath() + "/lancamentos");
            } else {
                req.setAttribute("erro", "Login ou senha inválidos.");
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Erro ao autenticar", e);
        }
    }
}