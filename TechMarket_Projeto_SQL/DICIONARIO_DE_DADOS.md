# Dicionario de Dados — TechMarket

**SGBD:** MySQL 8.0.16+ · **Modelo:** 8 tabelas e 51 colunas · **Banco:** `techmarket_projeto_a2`.

**Legenda:** PK = chave primaria; FK = chave estrangeira; UQ = unico; CHECK = validacao; NAO = NOT NULL; SIM = NULL.

## cliente

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_cliente` | `INT` | NAO | PK | Identificador automatico do cliente. |
| `nome` | `VARCHAR(100)` | NAO | - | Nome completo do cliente. |
| `cpf` | `CHAR(11)` | NAO | UQ | Onze digitos, sem pontuacao; unico por cliente. |
| `email` | `VARCHAR(120)` | NAO | UQ | E-mail unico do cliente. |
| `telefone` | `VARCHAR(20)` | SIM | - | Contato opcional. |
| `data_nascimento` | `DATE` | SIM | - | Data de nascimento opcional. |
| `data_cadastro` | `DATETIME` | NAO | DEFAULT CURRENT_TIMESTAMP | Data/hora do cadastro. |
| `ativo` | `TINYINT(1)` | NAO | CHECK + DEFAULT 1 | 1 = ativo; 0 = inativo. |

## endereco_entrega

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_endereco` | `INT` | NAO | PK / UQ composta | Identificador automatico; parte da unicidade (id_endereco, id_cliente). |
| `id_cliente` | `INT` | NAO | FK cliente / UQ composta | Proprietario do endereco; necessario para validar pedido. |
| `logradouro` | `VARCHAR(120)` | NAO | - | Rua/avenida do endereco. |
| `numero` | `VARCHAR(10)` | NAO | - | Numero do endereco (pode incluir letras). |
| `complemento` | `VARCHAR(60)` | SIM | - | Apartamento, bloco etc. |
| `bairro` | `VARCHAR(60)` | NAO | - | Bairro do endereco. |
| `cidade` | `VARCHAR(60)` | NAO | - | Municipio de entrega. |
| `uf` | `CHAR(2)` | NAO | CHECK | Sigla da unidade federativa (2 caracteres). |
| `cep` | `CHAR(8)` | NAO | CHECK | CEP com 8 digitos, sem hifen. |
| `principal` | `TINYINT(1)` | NAO | CHECK + DEFAULT 0 | 1 = endereco preferencial; 0 = secundario. |

## categoria

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_categoria` | `INT` | NAO | PK | Identificador automatico da categoria. |
| `nome` | `VARCHAR(60)` | NAO | UQ | Nome unico da categoria. |
| `descricao` | `VARCHAR(200)` | SIM | - | Resumo opcional sobre a categoria. |

## produto

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_produto` | `INT` | NAO | PK | Identificador automatico do produto. |
| `id_categoria` | `INT` | NAO | FK categoria | Cada produto pertence a uma categoria. |
| `nome` | `VARCHAR(100)` | NAO | INDEX | Nome pesquisavel do produto. |
| `descricao` | `VARCHAR(255)` | SIM | - | Detalhes opcionais do produto. |
| `preco` | `DECIMAL(10,2)` | NAO | CHECK | Preco atual; deve ser maior ou igual a zero. |
| `estoque` | `INT` | NAO | CHECK + DEFAULT 0 | Saldo nao negativo do estoque. |
| `ativo` | `TINYINT(1)` | NAO | CHECK + DEFAULT 1 | 1 = disponivel; 0 = descontinuado/inativo. |
| `data_cadastro` | `DATETIME` | NAO | DEFAULT CURRENT_TIMESTAMP | Momento de inclusao no catalogo. |

## pedido

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_pedido` | `INT` | NAO | PK | Identificador automatico do pedido. |
| `id_cliente` | `INT` | NAO | FK cliente / FK composta endereco | Cliente do pedido e dono do endereco escolhido. |
| `id_endereco` | `INT` | NAO | FK composta endereco | Endereco deve pertencer ao cliente do pedido. |
| `data_pedido` | `DATETIME` | NAO | DEFAULT CURRENT_TIMESTAMP | Momento do pedido. |
| `status` | `ENUM('PENDENTE','PAGO','SEPARACAO','ENVIADO','ENTREGUE','CANCELADO')` | NAO | DEFAULT PENDENTE | Estado logístico/comercial do pedido. |
| `valor_frete` | `DECIMAL(10,2)` | NAO | CHECK + DEFAULT 0 | Frete nao negativo. |
| `valor_total` | `DECIMAL(10,2)` | NAO | CHECK | Soma dos itens + frete (mantida na aplicacao). |

## item_pedido

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_item` | `INT` | NAO | PK | Identificador automatico do item. |
| `id_pedido` | `INT` | NAO | FK pedido / UQ composta | Pedido que contem o item. |
| `id_produto` | `INT` | NAO | FK produto / UQ composta | Produto; um mesmo produto aparece uma vez por pedido. |
| `quantidade` | `INT` | NAO | CHECK | Quantidade inteira positiva. |
| `preco_unitario` | `DECIMAL(10,2)` | NAO | CHECK | Preco congelado no momento da venda; nao negativo. |

## forma_pagamento

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_forma_pagamento` | `INT` | NAO | PK | Identificador automatico da forma. |
| `descricao` | `VARCHAR(40)` | NAO | UQ | Nome unico do meio de pagamento. |
| `permite_parcelamento` | `TINYINT(1)` | NAO | CHECK + DEFAULT 0 | 1 = aceita parcelas; 0 = a vista. |

## pagamento

| Coluna | Tipo MySQL | Aceita NULL? | Chave/regra | Descricao |
|---|---|---|---|---|
| `id_pagamento` | `INT` | NAO | PK | Identificador automatico do registro de pagamento. |
| `id_pedido` | `INT` | NAO | FK pedido | Pedido a que o pagamento se refere. |
| `id_forma_pagamento` | `INT` | NAO | FK forma_pagamento | Modalidade usada. |
| `valor` | `DECIMAL(10,2)` | NAO | CHECK | Valor do pagamento, nao negativo. |
| `parcelas` | `INT` | NAO | CHECK + DEFAULT 1 | Quantidade de parcelas maior ou igual a 1. |
| `data_pagamento` | `DATETIME` | SIM | CHECK condicional | Data obrigatoria se status = APROVADO; senao opcional. |
| `status` | `ENUM('PENDENTE','APROVADO','RECUSADO','CANCELADO','ESTORNADO')` | NAO | DEFAULT PENDENTE | Situacao do pagamento. |

## Regras adicionais do negocio

1. `cpf` e `email` nao se repetem entre clientes; a categoria e a forma de pagamento tambem tem nomes unicos.
2. Um endereco pertence a um unico cliente, e o pedido so pode apontar para endereco desse mesmo cliente (FK composta).
3. Um pedido pode ter varios itens; um produto aparece no maximo uma vez em cada pedido (`UNIQUE` composto).
4. Quantidades precisam ser positivas e valores monetarios/estoque nao podem ser negativos.
5. `preco_unitario` em `item_pedido` guarda o preco praticado na compra: mudar o catalogo nao altera vendas passadas.
6. `valor_total` deve equivaler a `valor_frete + SUM(item_pedido.quantidade * preco_unitario)`. Como abrange varias linhas, essa igualdade e validada pelo script `04_verificar_integridade.sql` e deve ser preservada pela aplicacao.
7. Uma forma com `permite_parcelamento = 0` deve receber `parcelas = 1`. Trata-se de regra de negocio entre tabelas, que deve ser garantida pela aplicacao ou por trigger.
8. Um pagamento aprovado exige `data_pagamento` preenchida (CHECK).
9. As FKs de historico usam `ON DELETE RESTRICT` para evitar excluir registros de pedidos ou produtos ja vendidos.
10. A exclusao fisica do script 10 afeta somente um produto descontinuado sem itens vinculados.
11. O campo `principal` marca o endereco preferencial. O modelo permite varios marcados como principal; se for necessario limitar a um por cliente, essa regra deve ser validada na aplicacao.
