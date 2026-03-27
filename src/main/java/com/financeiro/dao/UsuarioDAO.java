package com.financeiro.dao;

import com.financeiro.model.Usuario;
import com.financeiro.util.ConexaoDB;

import java.sql.*;

public class UsuarioDAO {

    public Usuario autenticar(String login, String senha) throws SQLException {
        String sql = "SELECT * FROM usuario WHERE login = ? AND senha = ? AND situacao = 'ATIVO'";

        try (Connection conn = ConexaoDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, login);
            ps.setString(2, senha);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNome(rs.getString("nome"));
                    u.setLogin(rs.getString("login"));
                    u.setSituacao(rs.getString("situacao"));
                    return u;
                }
            }
        }
        return null;
    }
}