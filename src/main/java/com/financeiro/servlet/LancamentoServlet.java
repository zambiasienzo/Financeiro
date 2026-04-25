package com.financeiro.servlet;

import com.financeiro.dao.LancamentoDAO;
import com.financeiro.model.Lancamento;
import com.financeiro.model.Usuario;
import com.financeiro.service.EmailService;

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

        String acao = req.getParameter("acao");

        try {
            LancamentoDAO dao = new LancamentoDAO();

            if ("novo".equals(acao)) {
                req.getRequestDispatcher("/WEB-INF/views/form-lancamento.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Lancamento l = dao.buscarPorId(id);
                req.setAttribute("lancamento", l);
                req.getRequestDispatcher("/WEB-INF/views/form-lancamento.jsp").forward(req, resp);

            } else if ("deletar".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.deletar(id);
                resp.sendRedirect(req.getContextPath() + "/lancamentos");

            } else {
                String situacao = req.getParameter("situacao");
                String dataInicio = req.getParameter("dataInicio");
                String dataFim = req.getParameter("dataFim");

                List<Lancamento> lista;

                if ((situacao != null && !situacao.isEmpty()) ||
                        (dataInicio != null && !dataInicio.isEmpty()) ||
                        (dataFim != null && !dataFim.isEmpty())) {

                    lista = dao.filtrar(dataInicio, dataFim, situacao);

                    req.setAttribute("filtroSituacao", situacao);
                    req.setAttribute("filtroDataInicio", dataInicio);
                    req.setAttribute("filtroDataFim", dataFim);

                } else {
                    lista = dao.listarTodos();
                }

                req.setAttribute("lancamentos", lista);
                req.getRequestDispatcher("/WEB-INF/views/lancamentos.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            throw new ServletException("Erro", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String acao = req.getParameter("acao");

        try {
            LancamentoDAO dao = new LancamentoDAO();

            if ("salvar".equals(acao)) {

                String idStr = req.getParameter("id");

                Lancamento l = new Lancamento();
                l.setDescricao(req.getParameter("descricao"));
                l.setDataLancamento(java.time.LocalDate.parse(req.getParameter("data")));
                l.setValor(new java.math.BigDecimal(req.getParameter("valor")));
                l.setTipoLancamento(req.getParameter("tipo"));
                l.setSituacao(req.getParameter("situacao"));

                if (idStr == null || idStr.isEmpty()) {

                    // NOVO
                    dao.inserir(l);

                    EmailService.enviar(
                            "enzo.zambiasi@universo.univates.br",
                            "Novo lançamento criado",
                            "Descrição: " + l.getDescricao() +
                                    "\nValor: R$ " + l.getValor() +
                                    "\nTipo: " + l.getTipoLancamento()
                    );

                } else {

                    // EDITAR
                    l.setId(Integer.parseInt(idStr));
                    dao.atualizar(l);

                    EmailService.enviar(
                            "enzo.zambiasi@universo.univates.br",
                            "Lançamento atualizado",
                            "Atualizado: " + l.getDescricao() +
                                    "\nValor: R$ " + l.getValor()+
                                    "\nTipo: " +l.getTipoLancamento()
                    );
                }

                resp.sendRedirect(req.getContextPath() + "/lancamentos");
            }

        } catch (Exception e) {
            throw new ServletException("Erro ao salvar", e);
        }
    }
}