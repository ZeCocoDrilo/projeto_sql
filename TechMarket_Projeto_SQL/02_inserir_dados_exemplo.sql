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
