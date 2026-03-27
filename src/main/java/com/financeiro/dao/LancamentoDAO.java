package com.financeiro.dao;

import com.financeiro.model.Lancamento;
import com.financeiro.util.ConexaoDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LancamentoDAO {

    public List<Lancamento> listarTodos() throws SQLException {
        List<Lancamento> lista = new ArrayList<>();
        String sql = "SELECT * FROM lancamento ORDER BY data_lancamento DESC";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Lancamento l = new Lancamento();
                l.setId(rs.getInt("id"));
                l.setDescricao(rs.getString("descricao"));
                l.setDataLancamento(rs.getDate("data_lancamento").toLocalDate());
                l.setValor(rs.getBigDecimal("valor"));
                l.setTipoLancamento(rs.getString("tipo_lancamento"));
                l.setSituacao(rs.getString("situacao"));
                lista.add(l);
            }
        }
        return lista;
    }
}