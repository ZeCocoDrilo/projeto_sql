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
