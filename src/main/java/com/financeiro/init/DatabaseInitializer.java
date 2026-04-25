package com.financeiro.init;

import com.financeiro.util.ConexaoDB;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;

@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🔥 INICIALIZANDO BANCO 🔥");

        try (Connection conn = ConexaoDB.getConnection()) {

            executarSQL(conn, "sql/V2__create_tables.sql");
            executarSQL(conn, "sql/V3__insert_data.sql");

            System.out.println("✅ Banco inicializado com sucesso!");

        } catch (Exception e) {
            System.out.println("❌ Erro ao inicializar banco:");
            e.printStackTrace();
        }
    }

    private void executarSQL(Connection conn, String caminho) throws Exception {

        String sql = lerArquivo(caminho);

        for (String comando : sql.split(";")) {

            if (!comando.trim().isEmpty()) {

                try (Statement stmt = conn.createStatement()) {
                    stmt.execute(comando);
                }
            }
        }
    }

    private String lerArquivo(String caminho) throws Exception {
        InputStream is = getClass().getClassLoader().getResourceAsStream(caminho);

        if (is == null) {
            throw new RuntimeException("Arquivo não encontrado: " + caminho);
        }

        return new String(is.readAllBytes(), StandardCharsets.UTF_8);
    }
}