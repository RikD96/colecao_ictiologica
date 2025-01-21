-- Criação do banco de dados (opcional, caso não exista)
CREATE DATABASE colecao_ictiologica;

-- Conecte-se ao banco de dados antes de executar as tabelas
\c colecao_ictiologica;

-- Tabela para armazenar informações taxonômicas
CREATE TABLE taxonomia (
    id SERIAL PRIMARY KEY,
    reino VARCHAR(100) NOT NULL,
    filo VARCHAR(100) NOT NULL,
    classe VARCHAR(100) NOT NULL,
    ordem VARCHAR(100) NOT NULL,
    familia VARCHAR(100) NOT NULL,
    genero VARCHAR(100) NOT NULL,
    especie VARCHAR(100) NOT NULL,
    nome_autor VARCHAR(200),
    ano_descricao INT
);

-- Tabela para armazenar informações dos coletores
CREATE TABLE coletores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    instituicao VARCHAR(200),
    contato VARCHAR(200)
);

-- Tabela para locais de coleta
CREATE TABLE locais_coleta (
    id SERIAL PRIMARY KEY,
    pais VARCHAR(100) NOT NULL,
    estado VARCHAR(100),
    municipio VARCHAR(100),
    bacia_hidrografica VARCHAR(100),
    rio VARCHAR(100),
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    altitude DECIMAL(5, 2),
    descricao TEXT
);

-- Tabela para espécimes coletados
CREATE TABLE especimes (
    id SERIAL PRIMARY KEY,
    codigo_colecao VARCHAR(50) UNIQUE NOT NULL,
    data_coleta DATE NOT NULL,
    tamanho DECIMAL(5, 2), -- Tamanho do espécime em cm
    peso DECIMAL(5, 2), -- Peso do espécime em g
    sexo VARCHAR(10), -- 'Macho', 'Fêmea', ou 'Indeterminado'
    id_taxonomia INT NOT NULL REFERENCES taxonomia(id),
    id_coletor INT NOT NULL REFERENCES coletores(id),
    id_local_coleta INT NOT NULL REFERENCES locais_coleta(id),
    observacoes TEXT
);

-- Tabela para armazenamento
CREATE TABLE armazenamento (
    id SERIAL PRIMARY KEY,
    tipo_armazenamento VARCHAR(100), -- 'Álcool', 'Congelado', etc.
    temperatura_armazenamento DECIMAL(5, 2), -- Temperatura em °C
    id_especime INT NOT NULL UNIQUE REFERENCES especimes(id),
    local_armazenamento VARCHAR(200) -- Exemplo: 'Gaveta 3, Prateleira 2'
);

-- Tabela para imagens dos espécimes
CREATE TABLE imagens (
    id SERIAL PRIMARY KEY,
    id_especime INT NOT NULL REFERENCES especimes(id),
    url_imagem TEXT NOT NULL,
    data_upload DATE DEFAULT CURRENT_DATE
);
