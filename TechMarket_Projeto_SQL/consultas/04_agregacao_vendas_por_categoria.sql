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
