-- TECHMARKET | VIEW ESTRATEGICA (RELATORIO EXECUTIVO MENSAL)
-- Considera apenas pedidos ativos no funil de venda (nao pendentes ou cancelados).
USE techmarket_projeto_a2;
CREATE OR REPLACE VIEW vw_relatorio_executivo_mensal AS
SELECT
    YEAR(p.data_pedido) AS ano,
    MONTH(p.data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    COUNT(DISTINCT p.id_cliente) AS clientes_unicos,
    ROUND(SUM(p.valor_total), 2) AS faturamento_total,
    ROUND(SUM(p.valor_frete), 2) AS total_frete,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM pedido AS p
WHERE p.status IN ('PAGO', 'SEPARACAO', 'ENVIADO', 'ENTREGUE')
GROUP BY YEAR(p.data_pedido), MONTH(p.data_pedido);

-- SELECT obrigatorio sobre a VIEW:
SELECT *
FROM vw_relatorio_executivo_mensal
ORDER BY ano DESC, mes DESC;
