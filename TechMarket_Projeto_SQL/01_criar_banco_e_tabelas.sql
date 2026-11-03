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
