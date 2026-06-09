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

		Select * from registro_voo;

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
		(100, "Notificação Time dev", "Notificação sobre leitura do java", "https://hooks.slack.com/services/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", "#production-logs", 1, 1,1);

		INSERT INTO setandoTipos (fkParamsNotificacoes, fkTipoLog) VALUES 
		(100, 1),
		(100, 2),
		(100, 3);
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
			
			
		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA **MODELO**
		-- CREATE VIEW vw_ AS; 
		-- SELECT QUE SERÁ REALIZADO NA MODEL **

		-- --------------------------------------------------------------------------------------------------------------------->



		-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
		-- DASHBOARD GERAL
		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA KPI DO DESTINO N #1 (MES CORRENTE)
		CREATE VIEW vw_destino_n1_ultimo_mes AS 
		SELECT
			destino_uf,
			destino_localidade,
			SUM(COALESCE(passageiros_pagos, 0)) AS total_passageiros_mes
		FROM registro_voo
		WHERE (ano, mes) = (
			SELECT ano, mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		)
		GROUP BY destino_uf, destino_localidade
		ORDER BY total_passageiros_mes DESC
		LIMIT 1;



		-- SELECT QUE SERÁ REALIZADO NA MODEL *destino #1*
		SELECT * FROM vw_destino_n1_ultimo_mes;
		-- --------------------------------------------------------------------------------------------------------------------->


		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA KPI DA QUANTIDADE DE TURISTAS MENSAL (MES CORRENTE)
		CREATE VIEW vw_volume_turista_mensal AS 
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		)
		SELECT
			SUM(COALESCE(passageiros_pagos, 0)) AS total_viagens
		FROM registro_voo
		WHERE (ano, mes) = (
			SELECT ano, mes
			FROM ultimo_periodo
		);

		-- SELECT QUE SERÁ REALIZADO NA MODEL *volume de turista mensal*
		SELECT * FROM vw_volume_turista_mensal;
		-- --------------------------------------------------------------------------------------------------------------------->     


		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA KPI DE INDICE DE SAZONALIDADE
		CREATE VIEW vw_sazonalidade_comparando_mes_com_historico AS 
		WITH ultimo_mes AS (
			SELECT ano, mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		),
		mes_atual AS (
			SELECT
				SUM(COALESCE(passageiros_pagos,0)) AS total
			FROM registro_voo
			WHERE (ano, mes) = (
				SELECT ano, mes
				FROM ultimo_mes
			)
		),
		media_historica AS (
			SELECT
				AVG(total_mes) AS media_mes
			FROM (
				SELECT
					ano,
					SUM(COALESCE(passageiros_pagos,0)) AS total_mes
				FROM registro_voo
				WHERE mes = (
					SELECT mes
					FROM ultimo_mes
				)
				AND ano < (
					SELECT ano
					FROM ultimo_mes
				)
				GROUP BY ano
			) x
		)
		SELECT
			ROUND(ma.total / mh.media_mes, 2) AS indice_x
		FROM mes_atual ma
		CROSS JOIN media_historica mh;
			

		-- SELECT QUE SERÁ REALIZADO NA MODEL *indice sazonalidade*
		SELECT * FROM vw_sazonalidade_comparando_mes_com_historico;
		-- --------------------------------------------------------------------------------------------------------------------->     


		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA DESTINO N1 EM CRESCIMENTO
		CREATE VIEW vw_destino_n1_crescimento AS
		WITH ultimo_mes AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		),
		movimento_atual AS (
			SELECT
				destino_uf,
				destino_localidade,
				SUM(
					COALESCE(passageiros_pagos, 0) +
					COALESCE(passageiros_gratis, 0)
				) AS total_passageiros
			FROM registro_voo
			WHERE (ano, mes) = (
				SELECT ano, mes
				FROM ultimo_mes
			)
			GROUP BY destino_uf, destino_localidade
		),
		movimento_anterior AS (
			SELECT
				destino_uf,
				destino_localidade,
				SUM(
					COALESCE(passageiros_pagos, 0) +
					COALESCE(passageiros_gratis, 0)
				) AS total_passageiros
			FROM registro_voo
			WHERE ano = (
				SELECT ano - 1
				FROM ultimo_mes
			)
			AND mes = (
				SELECT mes
				FROM ultimo_mes
			)
			GROUP BY destino_uf, destino_localidade
		)
		SELECT
			a.destino_uf,
			a.destino_localidade,
			ROUND(
				(
					a.total_passageiros - b.total_passageiros
				) * 100.0 /
				NULLIF(b.total_passageiros, 0),
				2
			) AS crescimento_percentual
		FROM movimento_atual a
		INNER JOIN movimento_anterior b
			ON a.destino_localidade = b.destino_localidade
		WHERE b.total_passageiros >= 10000
		ORDER BY crescimento_percentual DESC
		LIMIT 1;

		-- SELECT QUE SERÁ REALIZADO NA MODEL *destino n1 em crescimento*
		SELECT * FROM vw_destino_n1_crescimento;
		-- --------------------------------------------------------------------------------------------------------------------->    

		SELECT * FROM vw_volume_de_turistas_mensal_local_especifico
				WHERE destino_localidade like "%rio de%";

		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA GRAFICO DE TOP 5 CRESCIMENTOS PERCENTUAIS DOS ESTADOS EM RELACAO AO ANO ANTERIOR
		drop view vw_crescimento_estado_em_relacao_ao_mesmo_no_ano_anterior;
		CREATE VIEW vw_crescimento_estado_em_relacao_ao_mesmo_no_ano_anterior AS 
		WITH ultimo_ano AS (
			SELECT MAX(ano) AS ano
			FROM registro_voo
		),

		movimento_atual AS (
			SELECT
				ano,
				mes,
				destino_uf,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_atual
			FROM registro_voo
			WHERE ano = (
				SELECT ano
				FROM ultimo_ano
			)
			GROUP BY
				ano,
				mes,
				destino_uf
		),

		movimento_anterior AS (
			SELECT
				ano,
				mes,
				destino_uf,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_anterior
			FROM registro_voo
			WHERE ano = (
				SELECT ano - 1
				FROM ultimo_ano
			)
			GROUP BY
				ano,
				mes,
				destino_uf
		)

		SELECT
			a.ano,
			a.mes,
			a.destino_uf,

			CASE
				WHEN b.passageiros_anterior >= 10000 THEN
					ROUND(
						(
							a.passageiros_atual -
							b.passageiros_anterior
						) * 100.0 /
						b.passageiros_anterior,
						2
					)
				ELSE NULL
			END AS crescimento_percentual

		FROM movimento_atual a

		LEFT JOIN movimento_anterior b
			ON a.destino_uf = b.destino_uf
		   AND a.mes = b.mes

		ORDER BY
			a.mes,
			crescimento_percentual DESC;

		-- SELECT QUE SERÁ REALIZADO NA MODEL *TURISTAS PAGANTES X MES*
		SELECT * FROM vw_crescimento_estado_em_relacao_ao_mesmo_no_ano_anterior;
		-- --------------------------------------------------------------------------------------------------------------------->


		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA SESSAO DE PESQUISA DE LOCALIDADES
		CREATE VIEW vw_pesquisar_localidades AS 
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		),
		movimento_atual AS (
			SELECT
				destino_localidade,
				destino_uf,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_pagos
			FROM registro_voo
			WHERE (ano, mes) = (
				SELECT ano, mes
				FROM ultimo_periodo
			)
			GROUP BY
				destino_localidade,
				destino_uf
		),
		movimento_anterior AS (
			SELECT
				destino_localidade,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_pagos
			FROM registro_voo
			WHERE ano = (
				SELECT ano - 1
				FROM ultimo_periodo
			)
			AND mes = (
				SELECT mes
				FROM ultimo_periodo
			)
			GROUP BY destino_localidade
		),
		total_periodo AS (
			SELECT
				SUM(COALESCE(passageiros_pagos, 0)) AS total_passageiros
			FROM registro_voo
			WHERE (ano, mes) = (
				SELECT ano, mes
				FROM ultimo_periodo
			)
		)
		SELECT
			a.destino_localidade,
			a.destino_uf,
			a.passageiros_pagos AS passageiros_pagos_ultimo_periodo,
			CASE
				WHEN b.passageiros_pagos >= 0 THEN
					ROUND(
						a.passageiros_pagos /
						NULLIF(b.passageiros_pagos, 0),
						2
					)
				ELSE NULL
			END AS indice_sazonalidade,
			CASE
				WHEN b.passageiros_pagos >= 0 THEN
					ROUND(
						(
							a.passageiros_pagos -
							b.passageiros_pagos
						) * 100.0 /
						b.passageiros_pagos,
						2
					)
				ELSE NULL
			END AS indice_crescimento,
			ROUND(
				a.passageiros_pagos * 100.0 /
				t.total_passageiros,
				2
			) AS percentual_participacao
		FROM movimento_atual a
		LEFT JOIN movimento_anterior b
			ON a.destino_localidade = b.destino_localidade
		CROSS JOIN total_periodo t
		ORDER BY passageiros_pagos_ultimo_periodo DESC;

		-- SELECT QUE SERÁ REALIZADO NA MODEL *PESQUISA DE LOCALIDADES*
		SELECT * FROM vw_pesquisar_localidades;


		-- --------------------------------------------------------------------------------------------------------------------->
		-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->












		-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------->
		-- DASHBOARD ESPECIFICA
		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA KPI VOLUME DE TURISTAS MENSAL 
		-- CREATE VIEW vw_volume_de_turistas_mensal_local_especifico AS 
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		)
		SELECT
			destino_localidade,
			destino_uf,
			SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_pagos
		FROM registro_voo
		WHERE (ano, mes) = (
			SELECT ano, mes
			FROM ultimo_periodo
		)
		GROUP BY
			destino_localidade,
			destino_uf
		ORDER BY passageiros_pagos DESC;

		-- SELECT QUE SERÁ REALIZADO NA MODEL **
		SELECT * FROM vw_volume_de_turistas_mensal_local_especifico
		WHERE destino_localidade = "CONFINS";
		-- --------------------------------------------------------------------------------------------------------------------->



		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA GRAFICO  indice sazonalidade local especifico
		CREATE VIEW vw_indice_sazonalidade_local_especifico AS 
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		),
		movimento_atual AS (
			SELECT
				destino_localidade,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_pagos
			FROM registro_voo
			WHERE (ano, mes) = (
				SELECT ano, mes
				FROM ultimo_periodo
			)
			GROUP BY destino_localidade
		),
		movimento_anterior AS (
			SELECT
				destino_localidade,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_pagos
			FROM registro_voo
			WHERE ano = (
				SELECT ano - 1
				FROM ultimo_periodo
			)
			AND mes = (
				SELECT mes
				FROM ultimo_periodo
			)
			GROUP BY destino_localidade
		)
		SELECT
			a.destino_localidade,
			CASE
				WHEN b.passageiros_pagos >= 5000 THEN
					ROUND(
						a.passageiros_pagos /
						NULLIF(b.passageiros_pagos, 0),
						2
					)
				ELSE NULL
			END AS indice_x
		FROM movimento_atual a
		INNER JOIN movimento_anterior b
			ON a.destino_localidade = b.destino_localidade
		ORDER BY indice_x DESC;

		-- SELECT QUE SERÁ REALIZADO NA MODEL **
		SELECT * FROM vw_indice_sazonalidade_local_especifico WHERE destino_localidade = "GUARULHOS";
		-- --------------------------------------------------------------------------------------------------------------------->








		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA GRAFICO de quantos passageiros pagos ao longo dos meses de um destino especifico
		CREATE VIEW vw_passageiros_pagos_localidade_ultimos_meses_ano AS 
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		)
		SELECT
			rv.ano,
			rv.mes,
			rv.destino_localidade,
			SUM(COALESCE(rv.passageiros_pagos, 0)) AS passageiros_pagos
		FROM registro_voo rv
		WHERE rv.ano = (
			SELECT ano
			FROM ultimo_periodo
		)
		GROUP BY
			rv.ano,
			rv.mes,
			rv.destino_localidade
		ORDER BY
			rv.destino_localidade,
			rv.mes;

		-- SELECT QUE SERÁ REALIZADO NA MODEL **
		SELECT * FROM vw_passageiros_pagos_localidade_ultimos_meses_ano WHERE destino_localidade = "GUARULHOS";
		-- --------------------------------------------------------------------------------------------------------------------->



		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA GRAFICO fluxos rota / mes
		CREATE VIEW vw_fluxo_rota_mes AS 
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		)
		SELECT
			rv.ano,
			rv.mes,
			rv.origem_localidade,
			rv.destino_localidade,
			CONCAT(
				rv.origem_localidade,
				' → ',
				rv.destino_localidade
			) AS rota,
			SUM(
				COALESCE(rv.passageiros_pagos, 0)
			) AS fluxo
		FROM registro_voo rv
		WHERE rv.ano = (
			SELECT ano
			FROM ultimo_periodo
		)
		GROUP BY
			rv.ano,
			rv.mes,
			rv.origem_localidade,
			rv.destino_localidade
		HAVING SUM(
			COALESCE(rv.passageiros_pagos, 0)
		) >= 1000
		ORDER BY
			rv.mes,
			fluxo DESC;

		-- SELECT QUE SERÁ REALIZADO NA MODEL **
		SELECT * FROM vw_fluxo_rota_mes WHERE destino_localidade = "SÃO PAULO" and origem_localidade = "RIO DE JANEIRO";
		-- --------------------------------------------------------------------------------------------------------------------->

		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA A KPI DE POSICAO NO RANKING GERAL DAS LOCALIDADES 
		CREATE VIEW vw_posicao_no_ranking_localidade AS
		WITH passageiros_por_destino AS (
			SELECT
				destino_localidade,
				SUM(COALESCE(passageiros_pagos, 0)) AS total_passageiros
			FROM registro_voo
			GROUP BY destino_localidade
		),
		ranking AS (
			SELECT
				destino_localidade,
				total_passageiros,
				DENSE_RANK() OVER (
					ORDER BY total_passageiros DESC
				) AS posicao
			FROM passageiros_por_destino
			WHERE total_passageiros >= 5000
		)
		SELECT
			p.destino_localidade,
			CASE
				WHEN p.total_passageiros >= 5000
				THEN CAST(r.posicao AS CHAR)
				ELSE 'N/A'
			END AS ranking_geral
		FROM passageiros_por_destino p
		LEFT JOIN ranking r
			ON p.destino_localidade = r.destino_localidade
		ORDER BY
			p.total_passageiros DESC;
			
		-- SELECT QUE SERÁ REALIZADO NA MODEL *ranking de localidades*
		SELECT * FROM vw_posicao_no_ranking_localidade WHERE destino_localidade = "RIO DE JANEIRO";
		-- --------------------------------------------------------------------------------------------------------------------->

		-- --------------------------------------------------------------------------------------------------------------------->
		-- VIEW PARA VIEW DE RANKING DE LOCALIDADES EM CRESCIMENTO
		CREATE VIEW vw_posicao_no_ranking_crescimento_localidade AS
		WITH ultimo_periodo AS (
			SELECT
				ano,
				mes
			FROM registro_voo
			ORDER BY ano DESC, mes DESC
			LIMIT 1
		),
		movimento_atual AS (
			SELECT
				destino_localidade,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_atual
			FROM registro_voo
			WHERE (ano, mes) = (
				SELECT ano, mes
				FROM ultimo_periodo
			)
			GROUP BY destino_localidade
		),
		movimento_anterior AS (
			SELECT
				destino_localidade,
				SUM(COALESCE(passageiros_pagos, 0)) AS passageiros_anterior
			FROM registro_voo
			WHERE ano = (
				SELECT ano - 1
				FROM ultimo_periodo
			)
			AND mes = (
				SELECT mes
				FROM ultimo_periodo
			)
			GROUP BY destino_localidade
		),
		crescimento AS (
			SELECT
				a.destino_localidade,
				ROUND(
					(
						a.passageiros_atual -
						b.passageiros_anterior
					) * 100.0 /
					b.passageiros_anterior,
					2
				) AS crescimento_percentual
			FROM movimento_atual a
			INNER JOIN movimento_anterior b
				ON a.destino_localidade = b.destino_localidade
			WHERE b.passageiros_anterior >= 1000
		),
		ranking AS (
			SELECT
				destino_localidade,
				DENSE_RANK() OVER (
					ORDER BY crescimento_percentual DESC
				) AS posicao
			FROM crescimento
		)
		SELECT
			destinos.destino_localidade,
			CASE
				WHEN r.posicao IS NOT NULL
				THEN CAST(r.posicao AS CHAR)
				ELSE 'N/A'
			END AS ranking_crescimento
		FROM (
			SELECT DISTINCT destino_localidade
			FROM registro_voo
		) destinos
		LEFT JOIN ranking r
			ON destinos.destino_localidade = r.destino_localidade
		ORDER BY
			CASE
				WHEN r.posicao IS NULL THEN 999999
				ELSE r.posicao
			END,
			destinos.destino_localidade;
			
		-- SELECT QUE SERÁ REALIZADO NA MODEL *ranking de crescimento*
		SELECT * FROM vw_posicao_no_ranking_crescimento_localidade WHERE destino_localidade = "JUAZEIRO DO NORTE";
		-- --------------------------------------------------------------------------------------------------------------------->