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
