# Projeto de Banco de Dados — TechMarket

**Tema:** e-commerce e marketplace | **Banco:** `techmarket_projeto_a2` | **SGBD:** MySQL 8.0.16 ou superior.

Projeto baseado no diagrama DER fornecido, com **8 tabelas**, dados ficticios prontos para teste, **10 scripts SQL avulsos** e **uma VIEW estrategica**.

## Como executar no MySQL Workbench

**Mais simples (arquivo unico):**

1. Abra o **MySQL Workbench** e conecte ao servidor local.
2. Abra `00_EXECUTAR_TUDO.sql` em **File > Open SQL Script**.
3. Clique em **Execute (raio)** para executar todo o script.
4. Observe os resultados da criacao, dos JOINs, agregacoes, filtros, UPDATE, DELETE e consulta da VIEW nos painéis de resultados.
5. Confira as 8 tabelas: no painel **Schemas**, atualize a lista e abra `techmarket_projeto_a2 > Tables`.

**Para executar separado (recomendado para os prints da avaliacao):**

1. Execute `01_criar_banco_e_tabelas.sql`.
2. Execute `02_inserir_dados_exemplo.sql`.
3. Execute `03_criar_e_consultar_view.sql`.
4. Execute em ordem os scripts `consultas/01_...sql` ate `consultas/10_...sql`.
5. Execute `04_verificar_integridade.sql` para conferir integridade.

**CUIDADO:** o script `01_criar_banco_e_tabelas.sql` usa `DROP DATABASE IF EXISTS techmarket_projeto_a2`; **apaga e recria somente este banco**. Ao repetir uma apresentacao, execute de novo o arquivo `00_EXECUTAR_TUDO.sql` desde o inicio para restaurar os dados de exemplo.

## Arquivos e requisitos atendidos

| Requisito | Onde esta |
|---|---|
| Minimo de 7 entidades/tabelas | `01_criar_banco_e_tabelas.sql` (8 tabelas) |
| DER em arquivo de imagem | `diagrama/DER_TechMarket_original.jpeg` |
| Dicionario de dados completo | `DICIONARIO_DE_DADOS.md` e `DICIONARIO_DE_DADOS.csv` |
| JOIN de 2, 3 ou mais tabelas | Scripts 01, 02, 03, 04, 05 e 08 |
| COUNT, SUM, AVG, GROUP BY, HAVING | Scripts 03, 04 e 05 |
| WHERE, LIKE, BETWEEN, ORDER BY | Scripts 05, 06 e 07 |
| UPDATE e DELETE (DML) | Scripts 09 e 10 |
| CREATE VIEW + SELECT | `03_criar_e_consultar_view.sql` |
| Validacao dos totais e relacionamentos | `04_verificar_integridade.sql` |
| Tudo pronto em um arquivo | `00_EXECUTAR_TUDO.sql` |

## Dez scripts da bateria de testes

| Nº | Script | Resultado apresentado |
|---|---|---|
| 01 | `01_join_pedidos_clientes_enderecos.sql` | Pedidos com nome do cliente, cidade e UF |
| 02 | `02_join_itens_produtos_categorias.sql` | Itens com produto, categoria e subtotal |
| 03 | `03_left_join_clientes_sem_pedidos.sql` | Clientes e quantidade de pedidos (inclusive zero) |
| 04 | `04_agregacao_vendas_por_categoria.sql` | Receita, unidades e preco medio por categoria |
| 05 | `05_having_clientes_acima_de_3000.sql` | Clientes com compras validas acima de R$ 3 mil |
| 06 | `06_filtro_like_notebooks.sql` | Notebooks ativos em ordem decrescente de preco |
| 07 | `07_filtro_between_periodo.sql` | Pedidos do periodo solicitado |
| 08 | `08_join_pagamentos_formas_clientes.sql` | Pagamentos aprovados com forma e parcelas |
| 09 | `09_update_preco_e_estoque.sql` | Antes e depois da alteracao do produto 7 |
| 10 | `10_delete_produto_descontinuado.sql` | Exclusao segura do produto 12; contagem final = 0 |

**A VIEW** `vw_relatorio_executivo_mensal` resume pedidos validos, clientes unicos, faturamento, frete e ticket medio por mes. Executar `SELECT * FROM vw_relatorio_executivo_mensal;` exibe o relatorio.

## Imagens dos resultados para entrega

No Workbench, tire prints de: (a) arvore **Tables** com as 8 tabelas; (b) `DESCRIBE pedido;` e/ou outras estruturas; (c) resultado de cada um dos 10 scripts (especialmente os resultados antes/depois de UPDATE e DELETE); (d) `CREATE VIEW` no editor e `SELECT * FROM vw_relatorio_executivo_mensal` no grid; (e) dicionario e DER. **Os prints precisam ser obtidos apos executar no seu MySQL**, nao estao incluidos como se ja tivessem sido produzidos.

## Dados e resultados esperados

Os dados de teste criam 10 clientes, 12 enderecos, 6 categorias, 12 produtos, 12 pedidos, 21 itens, 4 formas de pagamento e 12 pagamentos. Apos o script 10, restam 11 produtos.

O pedido 11 esta **PENDENTE** e o 12 **CANCELADO**; ambos sao desconsiderados pela VIEW e pelas agregacoes de vendas validas. O cliente 10 nao fez pedidos, para demonstrar o LEFT JOIN.

Todos os valores sao simulados e nenhum dado pessoal real foi usado.
