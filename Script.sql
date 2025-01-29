-- Criação do banco de dados (opcional, caso não exista)
CREATE DATABASE colecao_ictiologica;

-- Conecte-se ao banco de dados antes de executar as tabelas
\c colecao_ictiologica;

-- ==========================
-- CRIAÇÃO DAS TABELAS
-- ==========================

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
    ano_descricao INT,
    UNIQUE (genero, especie, nome_autor, ano_descricao) -- Evita duplicação de espécies
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
    id_taxonomia INT NOT NULL REFERENCES taxonomia(id) ON DELETE CASCADE,
    id_coletor INT NOT NULL REFERENCES coletores(id) ON DELETE SET NULL,
    id_local_coleta INT NOT NULL REFERENCES locais_coleta(id) ON DELETE SET NULL,
    observacoes TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Data de inserção
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Data de última atualização
);

-- Criando tipo ENUM para armazenamento
CREATE TYPE tipo_armazenamento_enum AS ENUM ('Álcool', 'Congelado', 'Seco');

-- Tabela para armazenamento
CREATE TABLE armazenamento (
    id SERIAL PRIMARY KEY,
    tipo_armazenamento tipo_armazenamento_enum NOT NULL,
    temperatura_armazenamento DECIMAL(5, 2), -- Temperatura em °C
    id_especime INT NOT NULL UNIQUE REFERENCES especimes(id) ON DELETE CASCADE,
    local_armazenamento VARCHAR(200) -- Exemplo: 'Gaveta 3, Prateleira 2'
);

-- Tabela para imagens dos espécimes
CREATE TABLE imagens (
    id SERIAL PRIMARY KEY,
    id_especime INT NOT NULL REFERENCES especimes(id) ON DELETE CASCADE,
    url_imagem TEXT NOT NULL,
    data_upload DATE DEFAULT CURRENT_DATE,
    descricao TEXT -- Campo opcional para descrição da imagem
);

-- ==========================
-- CRIAÇÃO DE ÍNDICES PARA OTIMIZAÇÃO
-- ==========================

-- Índice para busca eficiente de espécies
CREATE INDEX idx_especie ON taxonomia (genero, especie);

-- Índice para facilitar busca por código de coleção
CREATE INDEX idx_codigo_colecao ON especimes (codigo_colecao);

-- ==========================
-- CRIAÇÃO DE FUNÇÃO E TRIGGER PARA ATUALIZAÇÃO AUTOMÁTICA DO TIMESTAMP
-- ==========================

-- Função para atualizar automaticamente a data de atualização
CREATE OR REPLACE FUNCTION atualizar_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.data_atualizacao = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para chamar a função em cada atualização
CREATE TRIGGER trg_update_especimes
BEFORE UPDATE ON especimes
FOR EACH ROW
EXECUTE FUNCTION atualizar_timestamp();

--################################################################################################--
--################################################################################################--
--##### Adicionando informações na tabela taxonomia usando o comando INSERT INTO no PostgreSQL: ##--
--################################################################################################--
--################################################################################################--

INSERT INTO taxonomia (
    reino, filo, classe, ordem, familia, genero, especie, nome_autor, ano_descricao
) VALUES
    ('Animalia', 'Chordata', 'Actinopterygii', 'Characiformes', 'Characidae', 'Astyanax', 'Astyanax bimaculatus', 'Linnaeus', 1758),
    ('Animalia', 'Chordata', 'Actinopterygii', 'Siluriformes', 'Pimelodidae', 'Pseudoplatystoma', 'Pseudoplatystoma corruscans', 'Spix & Agassiz', 1829),
    ('Animalia', 'Chordata', 'Actinopterygii', 'Perciformes', 'Cichlidae', 'Cichla', 'Cichla temensis', 'Humboldt', 1821);

SELECT * FROM taxonomia

