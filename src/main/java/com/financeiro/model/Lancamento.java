package com.financeiro.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Lancamento {
    private Integer id;
    private String descricao;
    private LocalDate dataLancamento;
    private BigDecimal valor;
    private String tipoLancamento;
    private String situacao;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public LocalDate getDataLancamento() { return dataLancamento; }
    public void setDataLancamento(LocalDate dataLancamento) { this.dataLancamento = dataLancamento; }

    public BigDecimal getValor() { return valor; }
    public void setValor(BigDecimal valor) { this.valor = valor; }

    public String getTipoLancamento() { return tipoLancamento; }
    public void setTipoLancamento(String tipoLancamento) { this.tipoLancamento = tipoLancamento; }

    public String getSituacao() { return situacao; }
    public void setSituacao(String situacao) { this.situacao = situacao; }
}