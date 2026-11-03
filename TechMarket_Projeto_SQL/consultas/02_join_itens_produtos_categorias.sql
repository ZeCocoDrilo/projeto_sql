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
