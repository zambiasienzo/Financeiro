package com.financeiro.model;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

public class LancamentoTest {

    @Test
    void deveSetarIdCorretamente() {
        Lancamento l = new Lancamento();
        l.setId(1);
        assertEquals(1, l.getId());
    }

    @Test
    void deveSetarDescricaoCorretamente() {
        Lancamento l = new Lancamento();
        l.setDescricao("Salário");
        assertEquals("Salário", l.getDescricao());
    }

    @Test
    void deveSetarDataLancamentoCorretamente() {
        Lancamento l = new Lancamento();
        LocalDate data = LocalDate.of(2026, 4, 11);
        l.setDataLancamento(data);
        assertEquals(data, l.getDataLancamento());
    }

    @Test
    void deveSetarValorCorretamente() {
        Lancamento l = new Lancamento();
        BigDecimal valor = new BigDecimal("1500.00");
        l.setValor(valor);
        assertEquals(valor, l.getValor());
    }

    @Test
    void deveSetarTipoLancamentoCorretamente() {
        Lancamento l = new Lancamento();
        l.setTipoLancamento("RECEITA");
        assertEquals("RECEITA", l.getTipoLancamento());
    }

    @Test
    void deveSetarSituacaoCorretamente() {
        Lancamento l = new Lancamento();
        l.setSituacao("ABERTO");
        assertEquals("ABERTO", l.getSituacao());
    }
}