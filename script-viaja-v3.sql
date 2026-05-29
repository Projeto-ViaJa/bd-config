DROP DATABASE viaja_dev;
CREATE DATABASE IF NOT EXISTS viaja_dev;
USE viaja_dev;

CREATE TABLE IF NOT EXISTS empresa (
    id_empresa int primary key auto_increment,
    nome_fantasia varchar(100) not null,
    cnpj char(14) not null unique,
    email_empresa varchar(100) not null unique,
    token varchar(45) not null unique
);

SELECT * FROM empresa;

-- CRIANDO TABELA USUARIO --
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario int primary key auto_increment,
    nome varchar(200),
    email_usuario varchar(200) not null,
    senha varchar(10) not null,
    is_admin tinyint,
    fk_empresa int not null,
    ativo tinyint default 1,
    nivel int default 1,
    constraint fkEmpresaUsuario
        foreign key (fk_empresa) references empresa(id_empresa)
);

SELECT * FROM  usuario;


-- CRIANDO TABELA CALENDÁRIO --
CREATE TABLE IF NOT EXISTS eventosRegistrados(
    idEventosRegistrados INT PRIMARY KEY AUTO_INCREMENT,
    dataInicial DATE,
    horarioInicial TIME,
    dataFinal DATE,
    horarioFinal TIME,
    titulo VARCHAR(200),
    descricao VARCHAR(500),
    nivelImportancia INT DEFAULT 1,
    dataRegistro DATE,
    horarioRegistro TIME,
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(id_empresa)
    );

SELECT * FROM eventosRegistrados;


-- CRIANDO TABELA BASE 10 ANOS --
CREATE TABLE IF NOT EXISTS registro_voo (
id int primary key auto_increment,
ano int,
mes int,
origem_uf varchar(200),
origem_regiao varchar(200),
origem_localidade varchar(200),
destino_uf varchar(200),
destino_regiao varchar(200),
destino_localidade varchar(200),
natureza varchar(200),
grupo_voo varchar(200),
passageiros_pagos int,
passageiros_gratis int,
ask bigint,
rpk bigint,
atk bigint,
rtk bigint,
decolagens int,
assentos int
);


-- CRIANDO TABELA HOSPEDAGENS PARCEIROS --
CREATE TABLE IF NOT EXISTS hospedagemParceiros (
    idhospedagemParceiros INT PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(45),
    nomeFantasia VARCHAR(500),
    tipoHospedagem VARCHAR(100),
    nomeResponsavel VARCHAR(500),
    telContato VARCHAR(45),
    email VARCHAR(200),
    filialOuMatriz VARCHAR(45),
    uf VARCHAR(45),
    municipio VARCHAR(45),
    rua VARCHAR(100),
    bairro VARCHAR(100),
    cep VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS hospedagemFavoritos (
    idhospedagemFavoritos INT PRIMARY KEY AUTO_INCREMENT,
    fkHospedagem INT,
    avaliacao VARCHAR(50),
    comentario VARCHAR(45),
    dtEdicao VARCHAR(45),
    fkUsuario INT,
    fkEmpresa INT,
    FOREIGN KEY (fkHospedagem) REFERENCES hospedagemParceiros(idhospedagemParceiros),
    FOREIGN KEY (fkUsuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (fkEmpresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE IF NOT EXISTS log (
id int primary key auto_increment,
dataEHora datetime default current_timestamp,
tipo ENUM ('INFO', 'WARNING', 'ERROR'),
modulo varchar(50),
mensagem varchar(255),
descricao text
);

INSERT INTO empresa (nome_fantasia, cnpj, email_empresa, token) VALUES
('teste1','12345678901234','teste@email.com','123'),
('teste2','12345678901235','teste2@email.com','456');
INSERT INTO usuario (nome, email_usuario, senha, is_admin, fk_empresa) VALUES
('Gabriel Fontes', 'fontes@email.com', '12345678', 1, 1);
INSERT INTO hospedagemParceiros
 (cnpj, nomeFantasia, tipoHospedagem, nomeResponsavel, telContato, email, filialOuMatriz, uf, municipio, rua, bairro, cep)
     VALUES
     ('12.345.678/0001-90', 'Hotel Sol Nascente', 'Hotel', 'Carlos Silva', '(11) 91234-5678', 'contato@solnascente.com', 'Matriz', 'SP', 'São Paulo', 'Rua das Flores, 123', 'Centro', '01001-000'),

     ('98.765.432/0001-10', 'Pousada Mar Azul', 'Pousada', 'Fernanda Souza', '(21) 99876-5432', 'marazul@email.com', 'Filial', 'RJ', 'Rio de Janeiro', 'Av. Atlântica, 456', 'Copacabana', '22010-000'),

     ('45.678.912/0001-55', 'Hostel Backpackers BR', 'Hostel', 'João Pereira', '(31) 98765-4321', 'backpackers@hostel.com', 'Matriz', 'MG', 'Belo Horizonte', 'Rua da Liberdade, 789', 'Savassi', '30140-000');
     
-- Criando tabela de tipos de log (Parametrização Slack)	
CREATE TABLE IF NOT EXISTS tipoLog (
id INT PRIMARY KEY AUTO_INCREMENT,
tipo VARCHAR(100),
onOff TINYINT
);

INSERT INTO tipoLog (id, tipo, onOff) VALUES 
(1,"ERROR", 1),
(2,"WARNING", 1),
(3,"INFO", 1);

CREATE TABLE IF NOT EXISTS paramsNotificacao (
id INT PRIMARY KEY AUTO_INCREMENT,
tituloNotificacao VARCHAR(100),
descricao VARCHAR(200),
url VARCHAR(300),
canal VARCHAR(200),
isAtivo TINYINT,
fkUsuario INT,
fkEmpresa INT, 
	FOREIGN KEY (fkUsuario) REFERENCES usuario(id_usuario),
	FOREIGN KEY (fkEmpresa) REFERENCES empresa(id_empresa)
);

CREATE TABLE IF NOT EXISTS setandoTipos (
fkParamsNotificacoes INT, 
fkTipoLog INT,
CONSTRAINT fkSetandoParams
	FOREIGN KEY (fkParamsNotificacoes)
		REFERENCES paramsNotificacao(id),
CONSTRAINT fkSetandoTipo
	FOREIGN KEY (fkTipoLog) 
		REFERENCES tipoLog(id),
CONSTRAINT pkComposta
	PRIMARY KEY (fkParamsNotificacoes, fkTipoLog)
);

-- CONFIGURANDO CRUD DE PARAMETRIZACAO 

-- INSERIR NOVA PARAMETRIZAÇÃO 
INSERT INTO paramsNotificacao (id, tituloNotificacao, descricao, url, canal, isAtivo, fkUsuario, fkEmpresa) VALUES
(100, "Notificação Time dev", "Notificação sobre leitura do java", "www.aaa.bbb", "#TimeDev", 1, 1,1);

INSERT INTO setandoTipos (fkParamsNotificacoes, fkTipoLog) VALUES 
(100, 1),
(100, 2);

SELECT 
    p.id,
    p.isAtivo AS ativo,
    p.tituloNotificacao,
    p.descricao,
    p.url,
    p.canal,
    GROUP_CONCAT(t.tipo SEPARATOR ', ') AS tipos
FROM paramsNotificacao p
INNER JOIN setandoTipos s
    ON s.fkParamsNotificacoes = p.id
INNER JOIN tipoLog t
    ON t.id = s.fkTipoLog
GROUP BY
    p.id,
    p.isAtivo,
    p.tituloNotificacao,
    p.descricao,
    p.url,
    p.canal;
    
