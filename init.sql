CREATE TABLE usuario (
                         id SERIAL PRIMARY KEY,
                         nome VARCHAR(100),
                         login VARCHAR(50),
                         senha VARCHAR(100),
                         situacao VARCHAR(20)
);

CREATE TABLE lancamento (
                            id SERIAL PRIMARY KEY,
                            descricao VARCHAR(255),
                            data_lancamento DATE,
                            valor NUMERIC(10,2),
                            tipo_lancamento VARCHAR(20),
                            situacao VARCHAR(20)
);

INSERT INTO usuario (nome, login, senha, situacao) VALUES
    ('Administrador', 'admin', 'admin123', 'ATIVO');

INSERT INTO lancamento (descricao, data_lancamento, valor, tipo_lancamento, situacao) VALUES
('Salário Mensal', '2025-03-05', 5000.00, 'RECEITA', 'EFETIVADO'),
('Aluguel Apartamento', '2025-03-10', 1200.00, 'DESPESA', 'EFETIVADO'),
('Conta de Luz', '2025-03-12', 180.50, 'DESPESA', 'ABERTO'),
('Freelance Desenvolvimento', '2025-03-15', 1500.00, 'RECEITA', 'EFETIVADO'),
('Supermercado Mensal', '2025-03-17', 650.00, 'DESPESA', 'EFETIVADO'),
('Plano de Saúde', '2025-03-20', 320.00, 'DESPESA', 'ABERTO'),
('Venda de Equipamento Usado', '2025-03-22', 800.00, 'RECEITA', 'EFETIVADO'),
('Internet Banda Larga', '2025-03-25', 99.90, 'DESPESA', 'ABERTO'),
('Dividendos Investimentos', '2025-03-28', 250.00, 'RECEITA', 'EFETIVADO'),
('Academia Mensal', '2025-03-30', 89.90, 'DESPESA', 'ABERTO');
