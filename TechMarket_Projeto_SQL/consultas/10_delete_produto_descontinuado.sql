-- SCRIPT 10 | DELETE (DML)
-- Objetivo: excluir um produto descontinuado sem historico de vendas.
-- A verificacao NOT EXISTS evita excluir produtos presentes em pedidos.
USE techmarket_projeto_a2;
SELECT id_produto, nome, ativo FROM produto WHERE id_produto = 12;

DELETE FROM produto
WHERE id_produto = 12
  AND ativo = 0
  AND NOT EXISTS (
      SELECT 1
      FROM item_pedido AS ip
      WHERE ip.id_produto = produto.id_produto
  );

SELECT ROW_COUNT() AS registros_excluidos;
SELECT COUNT(*) AS produtos_legado_restantes
FROM produto
WHERE id_produto = 12;
