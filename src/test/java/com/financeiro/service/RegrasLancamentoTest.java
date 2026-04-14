package com.financeiro.service;

import com.financeiro.model.Lancamento;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class RegrasLancamentoTest {

    @Test
    void valorReceitaDeveSerPositivo() {
        Lancamento l = new Lancamento();
        l.setTipoLancamento("RECEITA");
        l.setValor(new BigDecimal("100.00"));

        assertTrue(l.getValor().compareTo(BigDecimal.ZERO) > 0);
    }

    @Test
    void valorDespesaDeveSerPositivo() {
        Lancamento l = new Lancamento();
        l.setTipoLancamento("DESPESA");
        l.setValor(new BigDecimal("25.00"));

        assertTrue(l.getValor().compareTo(BigDecimal.ZERO) > 0);
    }

    @Test
    void descricaoNaoDeveSerVazia() {
        Lancamento l = new Lancamento();
        l.setDescricao("Mercado");

        assertNotNull(l.getDescricao());
        assertFalse(l.getDescricao().isBlank());
    }

    @Test
    void situacaoDeveSerAbertoEfetivadoOuCancelado() {
        Lancamento l = new Lancamento();
        l.setSituacao("ABERTO");

        assertTrue(
                l.getSituacao().equals("ABERTO") ||
                        l.getSituacao().equals("EFETIVADO") ||
                        l.getSituacao().equals("CANCELADO")
        );
    }
}
