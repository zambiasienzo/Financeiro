CREATE TABLE usuario (
                         id SERIAL PRIMARY KEY,
                         nome VARCHAR(100),
                         login VARCHAR(50),
                         senha VARCHAR(100),
                         situacao VARCHAR(20)
);