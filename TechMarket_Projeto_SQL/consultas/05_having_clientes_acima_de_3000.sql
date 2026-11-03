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
