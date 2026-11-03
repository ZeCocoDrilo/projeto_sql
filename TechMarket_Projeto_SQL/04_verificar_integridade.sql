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
