INSERT INTO usuario (nome, login, senha, situacao) VALUES
    ('Administrador', 'admin', 'admin123', 'ATIVO');
    ON CONFLICT (login) DO NOTHING;