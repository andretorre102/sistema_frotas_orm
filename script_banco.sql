DROP TABLE IF EXISTS abastecimento CASCADE;
DROP TABLE IF EXISTS manutencao CASCADE;
DROP TABLE IF EXISTS viagem CASCADE;
DROP TABLE IF EXISTS veiculo CASCADE;
DROP TABLE IF EXISTS motorista CASCADE;
-- Tabela MOTORISTA
CREATE TABLE motorista (
    cpf VARCHAR(14) NOT NULL,
    nome_motorista VARCHAR(100) NOT NULL,
    categoria_cnh VARCHAR(5) NOT NULL, 
    tempo_experiencia INT DEFAULT 0,   
    disponibilidade BOOLEAN DEFAULT TRUE,     
    CONSTRAINT pk_motorista PRIMARY KEY (cpf),
    CONSTRAINT ck_experiencia_valida CHECK (tempo_experiencia >=0)
);

-- Tabela VEICULO
CREATE TABLE veiculo (
    placa VARCHAR(10) NOT NULL,
    tipo VARCHAR(20) NOT NULL, 
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    status VARCHAR(20) DEFAULT 'ATIVO',
    quilometragem NUMERIC(10, 2) DEFAULT 0 CHECK (quilometragem >= 0),
    consumo_medio NUMERIC(10, 2),     
    CONSTRAINT pk_veiculo PRIMARY KEY (placa),
    CONSTRAINT ck_status_veiculo CHECK (status IN ('ATIVO', 'MANUTENCAO', 'INATIVO')),
    CONSTRAINT ck_tipo_veiculo CHECK (tipo IN ('Carro', 'Moto', 'Caminhao')),
    CONSTRAINT ck_consumo_medio_valido CHECK (consumo_medio >=0)
);

-- Tabela VIAGEM 
CREATE TABLE viagem (
    id_viagem SERIAL NOT NULL,
    origem VARCHAR(100) NOT NULL,
    destino VARCHAR(100) NOT NULL,
    data_saida TIMESTAMP NOT NULL,
    data_chegada TIMESTAMP, 
    distancia NUMERIC(10, 2) CHECK (distancia > 0), 
    cpf VARCHAR(14) NOT NULL,
    placa VARCHAR(10) NOT NULL,
    CONSTRAINT pk_viagem PRIMARY KEY (id_viagem),

    CONSTRAINT fk_viagem_motorista FOREIGN KEY (cpf) 
        REFERENCES motorista (cpf) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_viagem_veiculo FOREIGN KEY (placa) 
        REFERENCES veiculo (placa) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- Tabela MANUTENCAO
CREATE TABLE manutencao (
    id_manutencao SERIAL NOT NULL,
    data_manutencao DATE NOT NULL DEFAULT CURRENT_DATE,
    tipo_manutencao VARCHAR(20) NOT NULL, 
    descricao_manutencao TEXT,
    custo NUMERIC(10, 2) NOT NULL CHECK (custo >= 0),
    placa VARCHAR(10) NOT NULL,
    CONSTRAINT pk_manutencao PRIMARY KEY (id_manutencao),
    
    CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (placa) 
        REFERENCES veiculo (placa) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT ck_tipo_manutencao CHECK (tipo_manutencao IN ('Preventiva', 'Corretiva'))
);

-- Tabela ABASTECIMENTO
CREATE TABLE abastecimento (
    id_abastecimento SERIAL NOT NULL,
    data_abastecimento DATE NOT NULL DEFAULT CURRENT_DATE,
    tipo_combustivel VARCHAR(20) NOT NULL, -- Ex: Gasolina, Diesel, Etanol
    litros NUMERIC(10, 2) NOT NULL CHECK (litros > 0),
    valor NUMERIC(10, 2) NOT NULL CHECK (valor >= 0),
    placa VARCHAR(10) NOT NULL,

    CONSTRAINT pk_abastecimento PRIMARY KEY (id_abastecimento),
    
    CONSTRAINT fk_abastecimento_veiculo FOREIGN KEY (placa) 
        REFERENCES veiculo (placa) 
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- DADOS (INSERTS) --

-- INSERÇÕES NA TABELA MOTORISTAS
INSERT INTO motorista (cpf, nome_motorista, categoria_cnh, tempo_experiencia, disponibilidade) VALUES
('111.111.111-11', 'André Silva', 'AB', 5, TRUE),
('222.222.222-22', 'Bruno Souza', 'E', 12, TRUE), 
('333.333.333-33', 'Carlos Pereira', 'A', 3, TRUE), 
('444.444.444-44', 'Diana Soares', 'B', 8, FALSE), 
('555.555.555-55', 'Eduardo Mota', 'D', 20, TRUE),
('666.666.666-66', 'Francisco Chagas', 'C', 15, FALSE),
('777.777.777-77', 'Gustavo Lima', 'AB', 1, TRUE),
('888.888.888-88', 'Henrique Alves', 'B', 4, TRUE),
('999.999.999-99', 'Isabela Martins', 'AB', 6, TRUE),
('101.101.101-10', 'João Batista', 'D', 18, FALSE);

-- INSERÇÕES NA TABELA VEICULOS
INSERT INTO veiculo (placa, tipo, marca, modelo, ano, status, quilometragem, consumo_medio) VALUES
('ABC-1234', 'Carro', 'Audi', 'R8', 2020, 'ATIVO', 45000.00, 12.5),
('DEF-5678', 'Caminhao', 'Mercedes', 'L610', 2019, 'ATIVO', 150000.00, 3.5),
('GHI-0001', 'Moto', 'Honda', 'CG 150 Titan', 2022, 'ATIVO', 12000.00, 40.0),
('JKL-1000', 'Caminhao', 'Scania', 'R 450', 2018, 'MANUTENCAO', 200000.00, 3.2),
('FUS-9999', 'Carro', 'Volkswagen', 'Fusca', 1977, 'INATIVO', 1000000.00, 14.0),
('MNO-2020', 'Carro', 'Toyota', 'Corolla', 2021, 'ATIVO', 30000.00, 11.8),
('PQR-3030', 'Caminhao', 'Volvo', 'FH 540', 2020, 'ATIVO', 180000.00, 2.9);

-- INSERÇÕES VIAGENS
INSERT INTO viagem (origem, destino, data_saida, data_chegada, distancia, cpf, placa) VALUES
('São Paulo - SP', 'Rio de Janeiro - RJ', '2023-10-01 08:00:00', '2023-10-01 14:00:00', 430.00, '111.111.111-11', 'ABC-1234'),
('Fortaleza - CE', 'Juazeiro do Norte - CE', '2023-10-02 06:00:00', '2023-10-02 10:30:00', 560.00, '222.222.222-22', 'DEF-5678'),
('Bairro Aeroporto (Juazeiro)', 'Bairro João Cabral (Juazeiro)', '2023-10-03 09:00:00', '2023-10-03 09:45:00', 6.00, '333.333.333-33', 'GHI-0001'),
('Petrolina - PE', 'Salvador - BA', '2023-10-05 05:00:00', NULL, 740.00, '555.555.555-55', 'JKL-1000'), -- Viagem em andamento, por isso data_chegada = NULL)
('Recife - PE', 'Maceió - AL', '2023-10-06 07:00:00', '2023-10-06 12:00:00', 260.00, '888.888.888-88', 'MNO-2020'),
('Natal - RN', 'Fortaleza - CE', '2023-10-07 05:30:00', NULL, 520.00, '999.999.999-99', 'MNO-2020'),
('Juazeiro do Norte - CE', 'Crato - CE', '2023-10-08 08:00:00', '2023-10-08 08:40:00', 15.00, '333.333.333-33', 'GHI-0001'),
('São Luís - MA', 'Teresina - PI', '2023-10-09 04:00:00', '2023-10-09 14:00:00', 450.00, '101.101.101-10', 'PQR-3030'),
('Brasília - DF', 'Goiânia - GO', '2023-10-10 09:00:00', NULL, 210.00, '111.111.111-11', 'ABC-1234'),
('Salvador - BA', 'Aracaju - SE', '2023-10-11 06:00:00', '2023-10-11 10:00:00', 350.00, '222.222.222-22', 'DEF-5678'),
('Campinas - SP', 'São Paulo - SP', '2023-10-12 07:30:00', '2023-10-12 09:00:00', 100.00, '888.888.888-88', 'MNO-2020'),
('Belo Horizonte - MG', 'Vitória - ES', '2023-10-13 05:00:00', NULL, 520.00, '555.555.555-55', 'PQR-3030');

-- INSERÇÕES MANUTENCOES
INSERT INTO manutencao (data_manutencao, tipo_manutencao, descricao_manutencao, custo, placa) VALUES
('2023-09-15', 'Preventiva', 'Troca de óleo e filtros', 350.00, 'ABC-1234'),
('2023-10-01', 'Corretiva', 'Reparo no sistema de freios', 2500.00, 'JKL-1000'),
('2023-09-20', 'Preventiva', 'Revisão de 10k km', 150.00, 'GHI-0001'),
('2023-08-10', 'Corretiva', 'Troca de bateria', 600.00, 'DEF-5678'),
('2023-10-05', 'Preventiva', 'Alinhamento e balanceamento', 200.00, 'MNO-2020'),
('2023-10-06', 'Corretiva', 'Troca de embreagem', 3200.00, 'DEF-5678'),
('2023-10-07', 'Preventiva', 'Troca de pneus', 4500.00, 'PQR-3030'),
('2023-10-08', 'Corretiva', 'Reparo na suspensão', 1800.00, 'ABC-1234'),
('2023-10-09', 'Preventiva', 'Revisão elétrica', 600.00, 'JKL-1000');

-- INSERÇÕES ABASTECIMENTOS
INSERT INTO abastecimento (data_abastecimento, tipo_combustivel, litros, valor, placa) VALUES
('2023-10-01', 'Gasolina', 40.00, 220.00, 'ABC-1234'),
('2023-10-02', 'Diesel', 300.00, 1800.00, 'DEF-5678'),
('2023-10-03', 'Gasolina', 10.00, 55.00, 'GHI-0001'),
('2023-10-04', 'Diesel', 400.00, 2400.00, 'JKL-1000'),
('2023-10-05', 'Gasolina', 45.00, 247.50, 'MNO-2020'),
('2023-10-06', 'Diesel', 350.00, 2100.00, 'PQR-3030'),
('2023-10-07', 'Gasolina', 12.00, 66.00, 'GHI-0001'),
('2023-10-08', 'Diesel', 280.00, 1680.00, 'DEF-5678'),
('2023-10-09', 'Gasolina', 38.00, 209.00, 'ABC-1234'),
('2023-10-10', 'Diesel', 420.00, 2520.00, 'JKL-1000'),
('2023-10-11', 'Gasolina', 50.00, 275.00, 'MNO-2020');