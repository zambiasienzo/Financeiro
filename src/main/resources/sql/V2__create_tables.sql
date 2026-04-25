DROP TABLE IF EXISTS lancamento;
DROP TABLE IF EXISTS usuario;

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