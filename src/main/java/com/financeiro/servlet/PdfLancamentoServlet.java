package com.financeiro.servlet;

import com.financeiro.dao.LancamentoDAO;
import com.financeiro.model.Lancamento;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/lancamentos/pdf")
public class PdfLancamentoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=lancamentos.pdf");

        try {
            LancamentoDAO dao = new LancamentoDAO();

            String situacao = req.getParameter("situacao");
            String dataStr = req.getParameter("data");

            List<Lancamento> lista;

            if ((situacao != null && !situacao.isEmpty()) || (dataStr != null && !dataStr.isEmpty())) {
                LocalDate data = (dataStr != null && !dataStr.isEmpty())
                        ? LocalDate.parse(dataStr)
                        : null;

                lista = dao.filtrar(situacao, data);
            } else {
                lista = dao.listarTodos();
            }

            Document document = new Document();
            PdfWriter.getInstance(document, resp.getOutputStream());

            document.open();
            document.add(new Paragraph("Relatório de Lançamentos"));
            document.add(new Paragraph(" "));

            if (situacao != null && !situacao.isEmpty()) {
                document.add(new Paragraph("Filtro situação: " + situacao));
            }

            if (dataStr != null && !dataStr.isEmpty()) {
                document.add(new Paragraph("Filtro data: " + dataStr));
            }

            document.add(new Paragraph(" "));

            PdfPTable tabela = new PdfPTable(6);

            tabela.addCell("ID");
            tabela.addCell("Descrição");
            tabela.addCell("Data");
            tabela.addCell("Valor");
            tabela.addCell("Tipo");
            tabela.addCell("Situação");

            for (Lancamento l : lista) {
                tabela.addCell(String.valueOf(l.getId()));
                tabela.addCell(l.getDescricao());
                tabela.addCell(l.getDataLancamento().toString());
                tabela.addCell(l.getValor().toString());
                tabela.addCell(l.getTipoLancamento());
                tabela.addCell(l.getSituacao());
            }

            document.add(tabela);
            document.close();

        } catch (Exception e) {
            throw new ServletException("Erro ao gerar PDF", e);
        }
    }
}