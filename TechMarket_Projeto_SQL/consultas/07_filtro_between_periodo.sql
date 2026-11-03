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
