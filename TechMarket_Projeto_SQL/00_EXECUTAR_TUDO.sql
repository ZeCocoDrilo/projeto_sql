-- TECHMARKET: ENTREGA COMPLETA EM UM ARQUIVO
-- ATENCAO: recria o banco techmarket_projeto_a2, excluindo o anterior de mesmo nome.



-- ========= 01_criar_banco_e_tabelas.sql =========

-- TECHMARKET | 01 - CRIACAO DO BANCO E DAS 8 TABELAS
-- COMPATIVEL COM MYSQL 8.0.16+ (InnoDB)
-- ATENCAO: este script recria apenas o banco techmarket_projeto_a2.
-- Caso ja exista um banco com esse nome, os dados anteriores serao apagados.
DROP DATABASE IF EXISTS techmarket_projeto_a2;
CREATE DATABASE techmarket_projeto_a2
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE techmarket_projeto_a2;

-- 1) Clientes cadastrados no marketplace
CREATE TABLE cliente (
  id_cliente INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  cpf CHAR(11) NOT NULL,
  email VARCHAR(120) NOT NULL,
  telefone VARCHAR(20) NULL,
  data_nascimento DATE NULL,
  data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
  CONSTRAINT uq_cliente_cpf UNIQUE (cpf),
  CONSTRAINT uq_cliente_email UNIQUE (email),
  CONSTRAINT ck_cliente_ativo CHECK (ativo IN (0, 1))
) ENGINE=InnoDB;

-- 2) Um cliente pode cadastrar varios enderecos de entrega.
CREATE TABLE endereco_entrega (
  id_endereco INT NOT NULL AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  logradouro VARCHAR(120) NOT NULL,
  numero VARCHAR(10) NOT NULL,
  complemento VARCHAR(60) NULL,
  bairro VARCHAR(60) NOT NULL,
  cidade VARCHAR(60) NOT NULL,
  uf CHAR(2) NOT NULL,
  cep CHAR(8) NOT NULL,
  principal TINYINT(1) NOT NULL DEFAULT 0,
  CONSTRAINT pk_endereco_entrega PRIMARY KEY (id_endereco),
  CONSTRAINT uq_endereco_cliente UNIQUE (id_endereco, id_cliente),
  CONSTRAINT fk_endereco_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_endereco_principal CHECK (principal IN (0, 1)),
  CONSTRAINT ck_endereco_cep CHECK (CHAR_LENGTH(cep) = 8),
  CONSTRAINT ck_endereco_uf CHECK (CHAR_LENGTH(uf) = 2)
) ENGINE=InnoDB;

-- 3) Categorias para organizar o catalogo
CREATE TABLE categoria (
  id_categoria INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(60) NOT NULL,
  descricao VARCHAR(200) NULL,
  CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
  CONSTRAINT uq_categoria_nome UNIQUE (nome)
) ENGINE=InnoDB;

-- 4) Produtos do catalogo
CREATE TABLE produto (
  id_produto INT NOT NULL AUTO_INCREMENT,
  id_categoria INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  descricao VARCHAR(255) NULL,
  preco DECIMAL(10,2) NOT NULL,
  estoque INT NOT NULL DEFAULT 0,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_produto PRIMARY KEY (id_produto),
  CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria)
    REFERENCES categoria(id_categoria) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_produto_preco CHECK (preco >= 0),
  CONSTRAINT ck_produto_estoque CHECK (estoque >= 0),
  CONSTRAINT ck_produto_ativo CHECK (ativo IN (0, 1)),
  INDEX idx_produto_nome (nome)
) ENGINE=InnoDB;

-- 5) Pedidos vinculados ao cliente e a um endereco DESSE cliente.
-- A chave estrangeira composta impede vincular endereco de outra pessoa.
CREATE TABLE pedido (
  id_pedido INT NOT NULL AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  id_endereco INT NOT NULL,
  data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('PENDENTE', 'PAGO', 'SEPARACAO', 'ENVIADO', 'ENTREGUE', 'CANCELADO')
    NOT NULL DEFAULT 'PENDENTE',
  valor_frete DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  valor_total DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_pedido PRIMARY KEY (id_pedido),
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pedido_endereco_cliente FOREIGN KEY (id_endereco, id_cliente)
    REFERENCES endereco_entrega(id_endereco, id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_pedido_frete CHECK (valor_frete >= 0),
  CONSTRAINT ck_pedido_total CHECK (valor_total >= valor_frete),
  INDEX idx_pedido_data (data_pedido),
  INDEX idx_pedido_cliente_data (id_cliente, data_pedido)
) ENGINE=InnoDB;

-- 6) Itens de cada pedido. O preco unitario e o historico da compra,
-- mesmo que o preco de catalogo venha a mudar.
CREATE TABLE item_pedido (
  id_item INT NOT NULL AUTO_INCREMENT,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT pk_item_pedido PRIMARY KEY (id_item),
  CONSTRAINT uq_item_pedido_produto UNIQUE (id_pedido, id_produto),
  CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_item_pedido_produto FOREIGN KEY (id_produto)
    REFERENCES produto(id_produto) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_item_quantidade CHECK (quantidade > 0),
  CONSTRAINT ck_item_preco CHECK (preco_unitario >= 0),
  INDEX idx_item_produto (id_produto)
) ENGINE=InnoDB;

-- 7) Modalidades de pagamento
CREATE TABLE forma_pagamento (
  id_forma_pagamento INT NOT NULL AUTO_INCREMENT,
  descricao VARCHAR(40) NOT NULL,
  permite_parcelamento TINYINT(1) NOT NULL DEFAULT 0,
  CONSTRAINT pk_forma_pagamento PRIMARY KEY (id_forma_pagamento),
  CONSTRAINT uq_forma_pagamento_descricao UNIQUE (descricao),
  CONSTRAINT ck_forma_parcelas CHECK (permite_parcelamento IN (0, 1))
) ENGINE=InnoDB;

-- 8) Pagamentos dos pedidos
CREATE TABLE pagamento (
  id_pagamento INT NOT NULL AUTO_INCREMENT,
  id_pedido INT NOT NULL,
  id_forma_pagamento INT NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  parcelas INT NOT NULL DEFAULT 1,
  data_pagamento DATETIME NULL,
  status ENUM('PENDENTE', 'APROVADO', 'RECUSADO', 'CANCELADO', 'ESTORNADO')
    NOT NULL DEFAULT 'PENDENTE',
  CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),
  CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido)
    REFERENCES pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pagamento_forma FOREIGN KEY (id_forma_pagamento)
    REFERENCES forma_pagamento(id_forma_pagamento)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_pagamento_valor CHECK (valor >= 0),
  CONSTRAINT ck_pagamento_parcelas CHECK (parcelas >= 1),
  CONSTRAINT ck_pagamento_data_aprovado
    CHECK (status <> 'APROVADO' OR data_pagamento IS NOT NULL),
  INDEX idx_pagamento_pedido (id_pedido)
) ENGINE=InnoDB;

-- Conferencia visual de criacao das tabelas:
SHOW TABLES;



-- ========= 02_inserir_dados_exemplo.sql =========

-- TECHMARKET | 02 - DADOS FICTICIOS PARA OS EXEMPLOS
-- Execute somente depois de 01_criar_banco_e_tabelas.sql
USE techmarket_projeto_a2;

-- Todos os nomes e e-mails abaixo sao exemplos ficticios.

INSERT INTO cliente (id_cliente, nome, cpf, email, telefone, data_nascimento, data_cadastro, ativo) VALUES
  (1, 'Ana Paula Silva', '11122233344', 'ana.silva@exemplo.com', '11988880001', '1998-03-15', '2026-09-01 09:00:00', 1),
  (2, 'Bruno Almeida', '22233344455', 'bruno.almeida@exemplo.com', '11988880002', '1995-11-20', '2026-09-02 10:00:00', 1),
  (3, 'Carla Ribeiro', '33344455566', 'carla.ribeiro@exemplo.com', '11988880003', '2000-01-12', '2026-09-04 08:00:00', 1),
  (4, 'Diego Martins', '44455566677', 'diego.martins@exemplo.com', '11988880004', '1992-07-28', '2026-09-05 11:00:00', 1),
  (5, 'Elisa Rocha', '55566677788', 'elisa.rocha@exemplo.com', '11988880005', '2001-05-02', '2026-09-06 15:30:00', 1),
  (6, 'Felipe Costa', '66677788899', 'felipe.costa@exemplo.com', '11988880006', '1999-08-09', '2026-09-09 08:15:00', 1),
  (7, 'Gabriela Nunes', '77788899900', 'gabriela.nunes@exemplo.com', '11988880007', '2002-02-17', '2026-09-11 09:40:00', 1),
  (8, 'Henrique Souza', '88899900011', 'henrique.souza@exemplo.com', '11988880008', '1994-12-11', '2026-09-12 13:30:00', 1),
  (9, 'Isabela Freitas', '99900011122', 'isabela.freitas@exemplo.com', '11988880009', '1997-06-25', '2026-09-14 15:00:00', 1),
  (10, 'Joao Pedro Santos', '10020030040', 'joao.santos@exemplo.com', '11988880010', '2003-09-16', '2026-09-20 10:00:00', 1);

INSERT INTO endereco_entrega (id_endereco, id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep, principal) VALUES
  (1, 1, 'Rua das Flores', '125', 'Apto 14', 'Centro', 'Sao Paulo', 'SP', '01001000', 1),
  (2, 2, 'Avenida Brasil', '880', NULL, 'Jardim Paulista', 'Sao Paulo', 'SP', '01430000', 1),
  (3, 3, 'Rua do Comercio', '71', 'Casa 2', 'Centro', 'Mogi das Cruzes', 'SP', '08710000', 1),
  (4, 4, 'Rua dos Pinheiros', '1020', NULL, 'Pinheiros', 'Sao Paulo', 'SP', '05422000', 1),
  (5, 5, 'Avenida das Nacoes', '55', 'Bloco B', 'Vila Olimpia', 'Sao Paulo', 'SP', '04578000', 1),
  (6, 6, 'Rua Nove de Julho', '390', NULL, 'Centro', 'Santo Andre', 'SP', '09010000', 1),
  (7, 7, 'Avenida Central', '250', 'Apto 32', 'Centro', 'Campinas', 'SP', '13010000', 1),
  (8, 8, 'Rua da Praia', '18', NULL, 'Gonzaga', 'Santos', 'SP', '11060000', 1),
  (9, 9, 'Rua das Acacias', '665', 'Fundos', 'Centro', 'Guarulhos', 'SP', '07010000', 1),
  (10, 10, 'Rua Bela Vista', '101', NULL, 'Vila Mariana', 'Sao Paulo', 'SP', '04101000', 1),
  (11, 1, 'Rua da Paz', '250', 'Casa', 'Tatuape', 'Sao Paulo', 'SP', '03310000', 0),
  (12, 3, 'Avenida Republica', '490', NULL, 'Bras Cubas', 'Mogi das Cruzes', 'SP', '08740000', 0);

INSERT INTO categoria (id_categoria, nome, descricao) VALUES
  (1, 'Smartphones', 'Celulares e smartphones'),
  (2, 'Notebooks', 'Computadores portateis'),
  (3, 'Perifericos', 'Acessorios de computador'),
  (4, 'Acessorios', 'Cabos, carregadores e adaptadores'),
  (5, 'Monitores', 'Monitores e telas'),
  (6, 'Audio', 'Fones e equipamentos de audio');

INSERT INTO produto (id_produto, id_categoria, nome, descricao, preco, estoque, ativo, data_cadastro) VALUES
  (1, 1, 'Smartphone Orion X 256GB', 'Celular com tela OLED', 2799.90, 25, 1, '2026-09-01 10:00:00'),
  (2, 1, 'Smartphone Nova Lite 128GB', 'Celular de entrada', 1599.00, 35, 1, '2026-09-01 10:00:00'),
  (3, 2, 'Notebook Atlas i5 16GB', 'Notebook para estudo e trabalho', 4299.00, 12, 1, '2026-09-01 10:00:00'),
  (4, 2, 'Notebook Atlas Pro i7', 'Notebook para alta performance', 6599.00, 8, 1, '2026-09-01 10:00:00'),
  (5, 3, 'Mouse Gamer Pulse', 'Mouse optico com seis botoes', 149.90, 80, 1, '2026-09-01 10:00:00'),
  (6, 3, 'Teclado Mecanico MK80', 'Teclado com iluminacao RGB', 329.90, 45, 1, '2026-09-01 10:00:00'),
  (7, 4, 'Hub USB-C 6 em 1', 'Adaptador multip portas', 199.90, 50, 1, '2026-09-01 10:00:00'),
  (8, 4, 'Carregador Turbo 65W', 'Carregador USB-C universal', 129.90, 100, 1, '2026-09-01 10:00:00'),
  (9, 5, 'Monitor 24 IPS', 'Monitor Full HD', 899.90, 24, 1, '2026-09-01 10:00:00'),
  (10, 5, 'Monitor 27 QHD', 'Monitor de alta resolucao', 1799.90, 10, 1, '2026-09-01 10:00:00'),
  (11, 6, 'Fone Bluetooth Wave', 'Fone sem fio', 249.90, 60, 1, '2026-09-01 10:00:00'),
  (12, 4, 'Cabo VGA Legado', 'Produto descontinuado sem pedidos', 39.90, 4, 0, '2026-09-01 10:00:00');

INSERT INTO forma_pagamento (id_forma_pagamento, descricao, permite_parcelamento) VALUES
  (1, 'Pix', 0),
  (2, 'Cartao de Credito', 1),
  (3, 'Cartao de Debito', 0),
  (4, 'Boleto', 0);

INSERT INTO pedido (id_pedido, id_cliente, id_endereco, data_pedido, status, valor_frete, valor_total) VALUES
  (1, 1, 1, '2026-09-12 10:15:00', 'ENTREGUE', 19.90, 2949.70),
  (2, 2, 2, '2026-09-15 11:00:00', 'ENTREGUE', 24.90, 4473.80),
  (3, 3, 3, '2026-09-18 16:30:00', 'ENTREGUE', 15.00, 744.70),
  (4, 4, 4, '2026-09-21 12:20:00', 'ENVIADO', 29.90, 6628.90),
  (5, 5, 5, '2026-09-25 13:25:00', 'PAGO', 0.00, 1149.80),
  (6, 1, 11, '2026-10-02 08:30:00', 'ENTREGUE', 19.90, 2118.70),
  (7, 6, 6, '2026-10-04 17:00:00', 'ENTREGUE', 14.90, 444.60),
  (8, 7, 7, '2026-10-08 19:12:00', 'SEPARACAO', 39.90, 2039.70),
  (9, 8, 8, '2026-10-12 14:35:00', 'ENTREGUE', 22.50, 3152.30),
  (10, 9, 9, '2026-10-16 09:42:00', 'PAGO', 17.90, 1967.60),
  (11, 3, 12, '2026-10-20 11:50:00', 'PENDENTE', 12.90, 142.80),
  (12, 2, 2, '2026-10-24 17:20:00', 'CANCELADO', 12.90, 262.80);

INSERT INTO item_pedido (id_item, id_pedido, id_produto, quantidade, preco_unitario) VALUES
  (1, 1, 1, 1, 2799.90),
  (2, 1, 8, 1, 129.90),
  (3, 2, 3, 1, 4299.00),
  (4, 2, 5, 1, 149.90),
  (5, 3, 6, 1, 329.90),
  (6, 3, 7, 2, 199.90),
  (7, 4, 4, 1, 6599.00),
  (8, 5, 9, 1, 899.90),
  (9, 5, 11, 1, 249.90),
  (10, 6, 2, 1, 1599.00),
  (11, 6, 11, 2, 249.90),
  (12, 7, 5, 2, 149.90),
  (13, 7, 8, 1, 129.90),
  (14, 8, 10, 1, 1799.90),
  (15, 8, 7, 1, 199.90),
  (16, 9, 1, 1, 2799.90),
  (17, 9, 6, 1, 329.90),
  (18, 10, 9, 2, 899.90),
  (19, 10, 5, 1, 149.90),
  (20, 11, 8, 1, 129.90),
  (21, 12, 11, 1, 249.90);

INSERT INTO pagamento (id_pagamento, id_pedido, id_forma_pagamento, valor, parcelas, data_pagamento, status) VALUES
  (1, 1, 1, 2949.70, 1, '2026-09-12 10:20:00', 'APROVADO'),
  (2, 2, 2, 4473.80, 6, '2026-09-15 11:05:00', 'APROVADO'),
  (3, 3, 3, 744.70, 1, '2026-09-18 16:33:00', 'APROVADO'),
  (4, 4, 2, 6628.90, 10, '2026-09-21 12:30:00', 'APROVADO'),
  (5, 5, 1, 1149.80, 1, '2026-09-25 13:30:00', 'APROVADO'),
  (6, 6, 2, 2118.70, 3, '2026-10-02 08:35:00', 'APROVADO'),
  (7, 7, 1, 444.60, 1, '2026-10-04 17:05:00', 'APROVADO'),
  (8, 8, 2, 2039.70, 4, '2026-10-08 19:20:00', 'APROVADO'),
  (9, 9, 3, 3152.30, 1, '2026-10-12 14:40:00', 'APROVADO'),
  (10, 10, 2, 1967.60, 5, '2026-10-16 09:50:00', 'APROVADO'),
  (11, 11, 4, 142.80, 1, NULL, 'PENDENTE'),
  (12, 12, 1, 262.80, 1, NULL, 'CANCELADO');

-- Resumo do volume dos dados cadastrados.
SELECT 'cliente' AS tabela, COUNT(*) AS registros FROM cliente
UNION ALL SELECT 'endereco_entrega', COUNT(*) FROM endereco_entrega
UNION ALL SELECT 'categoria', COUNT(*) FROM categoria
UNION ALL SELECT 'produto', COUNT(*) FROM produto
UNION ALL SELECT 'pedido', COUNT(*) FROM pedido
UNION ALL SELECT 'item_pedido', COUNT(*) FROM item_pedido
UNION ALL SELECT 'forma_pagamento', COUNT(*) FROM forma_pagamento
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento;



-- ========= 03_criar_e_consultar_view.sql =========

-- TECHMARKET | VIEW ESTRATEGICA (RELATORIO EXECUTIVO MENSAL)
-- Considera apenas pedidos ativos no funil de venda (nao pendentes ou cancelados).
USE techmarket_projeto_a2;
CREATE OR REPLACE VIEW vw_relatorio_executivo_mensal AS
SELECT
    YEAR(p.data_pedido) AS ano,
    MONTH(p.data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    COUNT(DISTINCT p.id_cliente) AS clientes_unicos,
    ROUND(SUM(p.valor_total), 2) AS faturamento_total,
    ROUND(SUM(p.valor_frete), 2) AS total_frete,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM pedido AS p
WHERE p.status IN ('PAGO', 'SEPARACAO', 'ENVIADO', 'ENTREGUE')
GROUP BY YEAR(p.data_pedido), MONTH(p.data_pedido);

-- SELECT obrigatorio sobre a VIEW:
SELECT *
FROM vw_relatorio_executivo_mensal
ORDER BY ano DESC, mes DESC;



-- ========= CONSULTA 01_join_pedidos_clientes_enderecos.sql =========

-- SCRIPT 01 | JOIN entre 3 tabelas
-- Objetivo: mostrar cliente e endereco de entrega de cada pedido.
USE techmarket_projeto_a2;
SELECT
    p.id_pedido,
    c.nome AS cliente,
    e.cidade,
    e.uf,
    p.data_pedido,
    p.status,
    p.valor_total
FROM pedido AS p
INNER JOIN cliente AS c ON c.id_cliente = p.id_cliente
INNER JOIN endereco_entrega AS e ON e.id_endereco = p.id_endereco
ORDER BY p.data_pedido ASC;



-- ========= CONSULTA 02_join_itens_produtos_categorias.sql =========

-- SCRIPT 02 | JOIN entre 4 tabelas
-- Objetivo: detalhar produtos e subtotal dos itens de cada pedido.
USE techmarket_projeto_a2;
SELECT
    p.id_pedido,
    pr.nome AS produto,
    c.nome AS categoria,
    ip.quantidade,
    ip.preco_unitario,
    ROUND(ip.quantidade * ip.preco_unitario, 2) AS subtotal
FROM pedido AS p
INNER JOIN item_pedido AS ip ON ip.id_pedido = p.id_pedido
INNER JOIN produto AS pr ON pr.id_produto = ip.id_produto
INNER JOIN categoria AS c ON c.id_categoria = pr.id_categoria
ORDER BY p.id_pedido ASC, pr.nome ASC;



-- ========= CONSULTA 03_left_join_clientes_sem_pedidos.sql =========

-- SCRIPT 03 | LEFT JOIN (2 tabelas) + COUNT + GROUP BY
-- Objetivo: encontrar clientes que ainda nao compraram, sem perde-los no resultado.
USE techmarket_projeto_a2;
SELECT
    c.id_cliente,
    c.nome,
    COUNT(p.id_pedido) AS quantidade_pedidos
FROM cliente AS c
LEFT JOIN pedido AS p ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY quantidade_pedidos ASC, c.nome ASC;



-- ========= CONSULTA 04_agregacao_vendas_por_categoria.sql =========

-- SCRIPT 04 | COUNT, SUM, AVG e GROUP BY
-- Objetivo: medir faturamento, volume e preco medio por categoria.
-- O faturamento dos produtos exclui frete e pedidos pendentes/cancelados.
USE techmarket_projeto_a2;
SELECT
    c.nome AS categoria,
    COUNT(DISTINCT p.id_pedido) AS pedidos_distintos,
    SUM(ip.quantidade) AS unidades_vendidas,
    ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS faturamento_produtos,
    ROUND(AVG(ip.preco_unitario), 2) AS preco_unitario_medio
FROM categoria AS c
INNER JOIN produto AS pr ON pr.id_categoria = c.id_categoria
INNER JOIN item_pedido AS ip ON ip.id_produto = pr.id_produto
INNER JOIN pedido AS p ON p.id_pedido = ip.id_pedido
WHERE p.status IN ('PAGO', 'SEPARACAO', 'ENVIADO', 'ENTREGUE')
GROUP BY c.id_categoria, c.nome
ORDER BY faturamento_produtos DESC;



-- ========= CONSULTA 05_having_clientes_acima_de_3000.sql =========

-- SCRIPT 05 | WHERE, SUM, COUNT, GROUP BY e HAVING
-- Objetivo: identificar clientes com mais de R$ 3.000 em pedidos validos.
USE techmarket_projeto_a2;
SELECT
    c.nome AS cliente,
    COUNT(p.id_pedido) AS pedidos_validos,
    ROUND(SUM(p.valor_total), 2) AS total_compras
FROM cliente AS c
INNER JOIN pedido AS p ON p.id_cliente = c.id_cliente
WHERE p.status IN ('PAGO', 'SEPARACAO', 'ENVIADO', 'ENTREGUE')
GROUP BY c.id_cliente, c.nome
HAVING SUM(p.valor_total) > 3000.00
ORDER BY total_compras DESC;



-- ========= CONSULTA 06_filtro_like_notebooks.sql =========

-- SCRIPT 06 | WHERE + LIKE + ORDER BY
-- Objetivo: pesquisar notebooks ativos, do mais caro ao mais barato.
USE techmarket_projeto_a2;
SELECT
    id_produto,
    nome,
    preco,
    estoque
FROM produto
WHERE nome LIKE '%Notebook%'
  AND ativo = 1
ORDER BY preco DESC, nome ASC;



-- ========= CONSULTA 07_filtro_between_periodo.sql =========

-- SCRIPT 07 | WHERE + BETWEEN + ORDER BY
-- Objetivo: pedidos entre 01/10/2026 e 20/10/2026, inclusive.
USE techmarket_projeto_a2;
SELECT
    id_pedido,
    id_cliente,
    data_pedido,
    status,
    valor_total
FROM pedido
WHERE data_pedido BETWEEN '2026-10-01 00:00:00'
                      AND '2026-10-20 23:59:59'
ORDER BY data_pedido DESC;



-- ========= CONSULTA 08_join_pagamentos_formas_clientes.sql =========

-- SCRIPT 08 | JOIN entre 4 tabelas + filtro de status
-- Objetivo: analisar os meios e parcelas dos pagamentos aprovados.
USE techmarket_projeto_a2;
SELECT
    p.id_pedido,
    c.nome AS cliente,
    f.descricao AS forma_pagamento,
    pg.parcelas,
    pg.valor AS valor_pago,
    pg.data_pagamento,
    pg.status AS status_pagamento
FROM pagamento AS pg
INNER JOIN pedido AS p ON p.id_pedido = pg.id_pedido
INNER JOIN cliente AS c ON c.id_cliente = p.id_cliente
INNER JOIN forma_pagamento AS f
    ON f.id_forma_pagamento = pg.id_forma_pagamento
WHERE pg.status = 'APROVADO'
ORDER BY pg.data_pagamento DESC;



-- ========= CONSULTA 09_update_preco_e_estoque.sql =========

-- SCRIPT 09 | UPDATE (DML)
-- Objetivo: atualizar o preco e reabastecer o produto de codigo 7.
-- Valores fixos permitem reexecutar o script sem duplicar estoque.
USE techmarket_projeto_a2;
SELECT id_produto, nome, preco, estoque FROM produto WHERE id_produto = 7;

UPDATE produto
SET preco = 189.90,
    estoque = 65
WHERE id_produto = 7
  AND ativo = 1;

-- Confira no resultado que o preco e o estoque foram alterados.
SELECT id_produto, nome, preco, estoque FROM produto WHERE id_produto = 7;



-- ========= CONSULTA 10_delete_produto_descontinuado.sql =========

-- SCRIPT 10 | DELETE (DML)
-- Objetivo: excluir um produto descontinuado sem historico de vendas.
-- A verificacao NOT EXISTS evita excluir produtos presentes em pedidos.
USE techmarket_projeto_a2;
SELECT id_produto, nome, ativo FROM produto WHERE id_produto = 12;

DELETE FROM produto
WHERE id_produto = 12
  AND ativo = 0
  AND NOT EXISTS (
      SELECT 1
      FROM item_pedido AS ip
      WHERE ip.id_produto = produto.id_produto
  );

SELECT ROW_COUNT() AS registros_excluidos;
SELECT COUNT(*) AS produtos_legado_restantes
FROM produto
WHERE id_produto = 12;



-- ========= VALIDACAO FINAL =========

-- VERIFICACAO DE INTEGRIDADE DOS DADOS | RODAR DEPOIS DAS CONSULTAS
USE techmarket_projeto_a2;

-- Deve retornar ZERO linhas: todo pedido tem total igual a itens + frete.
SELECT
    p.id_pedido,
    p.valor_total AS total_gravado,
    ROUND(p.valor_frete + COALESCE(SUM(ip.quantidade * ip.preco_unitario),0),2)
      AS total_recalculado
FROM pedido AS p
LEFT JOIN item_pedido AS ip ON ip.id_pedido = p.id_pedido
GROUP BY p.id_pedido, p.valor_total, p.valor_frete
HAVING ABS(p.valor_total - (p.valor_frete + COALESCE(SUM(ip.quantidade * ip.preco_unitario),0))) > 0.001;

-- Deve retornar ZERO linhas: um pedido nunca usa endereco de outro cliente.
SELECT p.id_pedido
FROM pedido AS p
JOIN endereco_entrega AS e ON e.id_endereco = p.id_endereco
WHERE e.id_cliente <> p.id_cliente;

-- Deve retornar ZERO linhas: todo pagamento aprovado tem data.
SELECT id_pagamento
FROM pagamento
WHERE status = 'APROVADO' AND data_pagamento IS NULL;

-- Mostra contagem atual por tabela (apos script 10: produto tera 11 registros).
SELECT 'cliente' AS tabela, COUNT(*) AS registros FROM cliente
UNION ALL SELECT 'endereco_entrega', COUNT(*) FROM endereco_entrega
UNION ALL SELECT 'categoria', COUNT(*) FROM categoria
UNION ALL SELECT 'produto', COUNT(*) FROM produto
UNION ALL SELECT 'pedido', COUNT(*) FROM pedido
UNION ALL SELECT 'item_pedido', COUNT(*) FROM item_pedido
UNION ALL SELECT 'forma_pagamento', COUNT(*) FROM forma_pagamento
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento;
