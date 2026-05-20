CREATE TABLE usuario (
                         id SERIAL PRIMARY KEY,
                         nome VARCHAR(100) NOT NULL,
                         login VARCHAR(50) NOT NULL UNIQUE,
                         senha VARCHAR(100) NOT NULL,
                         situacao VARCHAR(20) NOT NULL
);