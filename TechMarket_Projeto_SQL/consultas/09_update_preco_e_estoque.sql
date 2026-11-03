-- SCRIPT 09 | UPDATE (DML)
-- Objetivo: atualizar o preco e reabastecer o produto de codigo 7.
-- Valores fixos permitem reexecutar o script sem duplicar estoque.
USE techmarket_projeto_a2;
SELECT id_produto, nome, preco, estoque FROM produto WHERE id_produto = 7;

UPDATE produto
SET preco = 189.90,
    estoque = 65
WHERE id_produto = 7
  AND ativo = 1;

-- Confira no resultado que o preco e o estoque foram alterados.
SELECT id_produto, nome, preco, estoque FROM produto WHERE id_produto = 7;
