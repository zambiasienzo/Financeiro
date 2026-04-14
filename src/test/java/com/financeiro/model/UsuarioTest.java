package com.financeiro.model;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class UsuarioTest {

    @Test
    void deveSetarIdCorretamente() {
        Usuario u = new Usuario();
        u.setId(1);
        assertEquals(1, u.getId());
    }

    @Test
    void deveSetarNomeCorretamente() {
        Usuario u = new Usuario();
        u.setNome("Enzo");
        assertEquals("Enzo", u.getNome());
    }

    @Test
    void deveSetarLoginCorretamente() {
        Usuario u = new Usuario();
        u.setLogin("admin");
        assertEquals("admin", u.getLogin());
    }

    @Test
    void deveSetarSenhaCorretamente() {
        Usuario u = new Usuario();
        u.setSenha("123456");
        assertEquals("123456", u.getSenha());
    }

    @Test
    void deveSetarSituacaoCorretamente() {
        Usuario u = new Usuario();
        u.setSituacao("ATIVO");
        assertEquals("ATIVO", u.getSituacao());
    }
}
