package com.financeiro.dao;

import com.financeiro.model.Lancamento;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class LancamentoDAOTest {

    @Test
    void listarTodosNaoDeveRetornarNulo() throws Exception {
        LancamentoDAO dao = new LancamentoDAO();
        List<Lancamento> lista = dao.listarTodos();
        assertNotNull(lista);
    }

    @Test
    void inserirDeveSalvarLancamento() throws Exception {
        LancamentoDAO dao = new LancamentoDAO();

        Lancamento l = new Lancamento();
        l.setDescricao("Teste Inserir");
        l.setDataLancamento(LocalDate.now());
        l.setValor(new BigDecimal("50.00"));
        l.setTipoLancamento("RECEITA");
        l.setSituacao("ABERTO");

        dao.inserir(l);

        List<Lancamento> lista = dao.listarTodos();

        Lancamento encontrado = lista.stream()
                .filter(x -> "Teste Inserir".equals(x.getDescricao()))
                .findFirst()
                .orElse(null);

        assertNotNull(encontrado);


        dao.deletar(encontrado.getId());
    }

    @Test
    void buscarPorIdNaoDeveRetornarNuloQuandoIdExiste() throws Exception {
        LancamentoDAO dao = new LancamentoDAO();
        List<Lancamento> lista = dao.listarTodos();

        if (!lista.isEmpty()) {
            Lancamento l = dao.buscarPorId(lista.get(0).getId());
            assertNotNull(l);
        }
    }

    @Test
    void filtrarPorSituacaoDeveRetornarApenasRegistrosDaSituacao() throws Exception {
        LancamentoDAO dao = new LancamentoDAO();
        List<Lancamento> lista = dao.filtrar(null, null, "ABERTO");

        for (Lancamento l : lista) {
            assertEquals("ABERTO", l.getSituacao());
        }
    }

    @Test
    void filtrarPorDataNaoDeveRetornarNulo() throws Exception {
        LancamentoDAO dao = new LancamentoDAO();
        List<Lancamento> lista = dao.filtrar("2026-04-01", "2026-04-10", null);
        assertNotNull(lista);
    }
}