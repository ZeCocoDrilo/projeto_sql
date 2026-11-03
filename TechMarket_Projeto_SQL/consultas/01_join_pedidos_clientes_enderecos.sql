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
