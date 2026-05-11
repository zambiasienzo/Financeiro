package com.financeiro.dao;

import com.financeiro.model.Lancamento;
import com.financeiro.util.ConexaoDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.SQLException;
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
    public void inserir(Lancamento l) throws SQLException {
        String sql = "INSERT INTO lancamento (descricao, data_lancamento, valor, tipo_lancamento, situacao) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, l.getDescricao());
            ps.setDate(2, Date.valueOf(l.getDataLancamento()));
            ps.setBigDecimal(3, l.getValor());
            ps.setString(4, l.getTipoLancamento());
            ps.setString(5, l.getSituacao());

            ps.executeUpdate();
        }
    }

    public void atualizar(Lancamento l) throws SQLException {
        String sql = "UPDATE lancamento SET descricao=?, data_lancamento=?, valor=?, tipo_lancamento=?, situacao=? WHERE id=?";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, l.getDescricao());
            ps.setDate(2, Date.valueOf(l.getDataLancamento()));
            ps.setBigDecimal(3, l.getValor());
            ps.setString(4, l.getTipoLancamento());
            ps.setString(5, l.getSituacao());
            ps.setInt(6, l.getId());

            ps.executeUpdate();
        }
    }

    public void deletar(int id) throws SQLException {
        String sql = "DELETE FROM lancamento WHERE id=?";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Lancamento buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM lancamento WHERE id=?";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Lancamento l = new Lancamento();
                l.setId(rs.getInt("id"));
                l.setDescricao(rs.getString("descricao"));
                l.setDataLancamento(rs.getDate("data_lancamento").toLocalDate());
                l.setValor(rs.getBigDecimal("valor"));
                l.setTipoLancamento(rs.getString("tipo_lancamento"));
                l.setSituacao(rs.getString("situacao"));
                return l;
            }
        }
        return null;
    }
    public List<Lancamento> filtrar(String dataInicio, String dataFim, String situacao) throws SQLException {
        List<Lancamento> lista = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM lancamento WHERE 1=1");

        if (dataInicio != null && !dataInicio.isEmpty()) {
            sql.append(" AND data_lancamento >= ?");
        }

        if (dataFim != null && !dataFim.isEmpty()) {
            sql.append(" AND data_lancamento <= ?");
        }

        if (situacao != null && !situacao.isEmpty()) {
            sql.append(" AND situacao = ?");
        }

        sql.append(" ORDER BY data_lancamento DESC");

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;

            if (dataInicio != null && !dataInicio.isEmpty()) {
                ps.setDate(i++, Date.valueOf(dataInicio));
            }

            if (dataFim != null && !dataFim.isEmpty()) {
                ps.setDate(i++, Date.valueOf(dataFim));
            }

            if (situacao != null && !situacao.isEmpty()) {
                ps.setString(i++, situacao);
            }

            try (ResultSet rs = ps.executeQuery()) {
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
        }

        return lista;
    }
}