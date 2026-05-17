CREATE TABLE lancamento (
                            id SERIAL PRIMARY KEY,
                            descricao VARCHAR(255),
                            data_lancamento DATE,
                            valor NUMERIC(10,2),
                            tipo_lancamento VARCHAR(20),
                            situacao VARCHAR(20)
);