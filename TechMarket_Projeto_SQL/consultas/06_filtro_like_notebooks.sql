-- SCRIPT 06 | WHERE + LIKE + ORDER BY
-- Objetivo: pesquisar notebooks ativos, do mais caro ao mais barato.
USE techmarket_projeto_a2;
SELECT
    id_produto,
    nome,
    preco,
    estoque
FROM produto
WHERE nome LIKE '%Notebook%'
  AND ativo = 1
ORDER BY preco DESC, nome ASC;
