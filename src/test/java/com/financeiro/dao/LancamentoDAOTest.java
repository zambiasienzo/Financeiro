package com.financeiro.dao;

import com.financeiro.model.Lancamento;
import org.junit.jupiter.api.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class LancamentoDAOTest {

    private LancamentoDAO dao;
    private Integer idTeste;

    @BeforeAll
    void setup() throws Exception {
        dao = new LancamentoDAO();

        // cria dado fixo
        Lancamento l = new Lancamento();
        l.setDescricao("TESTE_FIXO");
        l.setDataLancamento(LocalDate.now());
        l.setValor(new BigDecimal("100"));
        l.setTipoLancamento("RECEITA");
        l.setSituacao("ABERTO");

        dao.inserir(l);

        // pega id gerado
        List<Lancamento> lista = dao.listarTodos();
        Lancamento encontrado = lista.stream()
                .filter(x -> "TESTE_FIXO".equals(x.getDescricao()))
                .findFirst()
                .orElse(null);

        if (encontrado != null) {
            idTeste = encontrado.getId();
        }
    }

    @AfterAll
    void cleanup() throws Exception {
        if (idTeste != null) {
            dao.deletar(idTeste);
        }
    }

    @Test
    void listarTodosNaoDeveRetornarNulo() throws Exception {
        List<Lancamento> lista = dao.listarTodos();
        assertNotNull(lista);
    }

    @Test
    void buscarPorIdNaoDeveRetornarNuloQuandoIdExiste() throws Exception {
        if (idTeste != null) {
            Lancamento l = dao.buscarPorId(idTeste);
            assertNotNull(l);
        }
    }

    @Test
    void filtrarPorSituacaoDeveRetornarApenasRegistrosDaSituacao() throws Exception {
        List<Lancamento> lista = dao.filtrar(null, null, "ABERTO");

        for (Lancamento l : lista) {
            assertEquals("ABERTO", l.getSituacao());
        }
    }

    @Test
    void filtrarPorDataNaoDeveRetornarNulo() throws Exception {
        String hoje = LocalDate.now().toString();
        List<Lancamento> lista = dao.filtrar(hoje, hoje, null);
        assertNotNull(lista);
    }

    @Test
    void inserirDeveSalvarLancamento() throws Exception {
        Lancamento l = new Lancamento();
        l.setDescricao("TESTE_INSERIR");
        l.setDataLancamento(LocalDate.now());
        l.setValor(new BigDecimal("50"));
        l.setTipoLancamento("RECEITA");
        l.setSituacao("ABERTO");

        dao.inserir(l);

        List<Lancamento> lista = dao.listarTodos();

        Lancamento encontrado = lista.stream()
                .filter(x -> "TESTE_INSERIR".equals(x.getDescricao()))
                .findFirst()
                .orElse(null);

        assertNotNull(encontrado);

        // limpa
        if (encontrado != null) {
            dao.deletar(encontrado.getId());
        }
    }
}