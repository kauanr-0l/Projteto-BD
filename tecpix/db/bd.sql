PRAGMA foreign_keys = ON;




CREATE TABLE cargo (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_cargo TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    status     INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1))
) STRICT;


CREATE TABLE funcionario (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_funcionario TEXT    NOT NULL COLLATE NOCASE,
    id_cargo         INTEGER NOT NULL,
    data_cadastro    TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status           INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_cargo) REFERENCES cargo (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE (id, id_cargo)
) STRICT;

CREATE TABLE categoria (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_categoria       TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE cliente (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_cliente         TEXT    NOT NULL COLLATE NOCASE,
    email                TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    telefone             TEXT    NOT NULL UNIQUE,
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo IN (1, 2)),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE marca (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_marca           TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo IN (1, 2)),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE modelo (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_modelo          TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo IN (1, 2)),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE tipo (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_tipo            TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo IN (1, 2)),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE equipamento (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    id_marca             INTEGER NOT NULL,
    id_modelo            INTEGER NOT NULL,
    id_tipo              INTEGER NOT NULL,
    id_cliente           INTEGER NOT NULL,
    numero_serie         TEXT COLLATE NOCASE UNIQUE,
    imei                 TEXT UNIQUE
                         CHECK (imei IS NULL OR (LENGTH(imei) = 15 AND imei NOT GLOB '*[^0-9]*')),
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo IN (1, 2)),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    CHECK (numero_serie IS NOT NULL OR imei IS NOT NULL),   -- precisa de série OU IMEI
    FOREIGN KEY (id_marca)   REFERENCES marca (id),
    FOREIGN KEY (id_modelo)  REFERENCES modelo (id),
    FOREIGN KEY (id_tipo)    REFERENCES tipo (id),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE TABLE peca (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_peca            TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_categoria         INTEGER NOT NULL,
    preco_venda          INTEGER NOT NULL CHECK (preco_venda > 0),
    estoque_atual        INTEGER NOT NULL DEFAULT 0 CHECK (estoque_atual >= 0),
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_categoria) REFERENCES categoria (id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE entrada_peca (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca              INTEGER NOT NULL,
    quantidade           INTEGER NOT NULL CHECK (quantidade > 0),
    preco_custo          INTEGER NOT NULL CHECK (preco_custo >= 0),
    preco_venda_sugerido INTEGER NOT NULL CHECK (preco_venda_sugerido > 0),
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    data_entrada         TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime'))
                         CHECK (data_entrada = DATETIME(data_entrada)),
    FOREIGN KEY (id_peca) REFERENCES peca (id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE situacao (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_situacao TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    status        INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1))
) STRICT;

CREATE TABLE forma_pagamento (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_forma_pagamento TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE servico (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_servico         TEXT    NOT NULL COLLATE NOCASE UNIQUE,
    id_categoria         INTEGER NOT NULL,
    preco                INTEGER NOT NULL CHECK (preco > 0),
    horas_trabalho       REAL    NOT NULL CHECK (horas_trabalho > 0),
    id_funcionario       INTEGER NOT NULL,
    id_funcionario_cargo INTEGER NOT NULL CHECK (id_funcionario_cargo = 1),
    data_cadastro        TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime')),
    status               INTEGER NOT NULL DEFAULT 1 CHECK (status IN (0, 1)),
    FOREIGN KEY (id_categoria) REFERENCES categoria (id),
    FOREIGN KEY (id_funcionario, id_funcionario_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE ordem (
    id                            INTEGER PRIMARY KEY AUTOINCREMENT,
    id_equipamento                INTEGER NOT NULL,
    defeito_relatado              TEXT    NOT NULL COLLATE NOCASE,
    defeito_constatado            TEXT    COLLATE NOCASE,
    data_abertura                 TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime'))
                                  CHECK (data_abertura = DATETIME(data_abertura)),
    data_fechamento               TEXT
                                  CHECK (data_fechamento IS NULL OR
                                        (data_fechamento = DATETIME(data_fechamento)
                                         AND data_fechamento >= data_abertura)),
    valor_total                   INTEGER NOT NULL DEFAULT 0 CHECK (valor_total >= 0),
    id_forma_pagamento            INTEGER,
    id_funcionario_abertura       INTEGER NOT NULL,
    id_funcionario_cargo_abertura INTEGER NOT NULL CHECK (id_funcionario_cargo_abertura IN (1, 2)),
    id_tecnico                    INTEGER NOT NULL,                       -- RF06: um único técnico por OS
    id_tecnico_cargo              INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
    id_situacao_atual             INTEGER NOT NULL DEFAULT 1,             -- RF07: status atual
    CHECK (id_forma_pagamento IS NULL OR data_fechamento IS NOT NULL),
    FOREIGN KEY (id_equipamento)      REFERENCES equipamento (id),
    FOREIGN KEY (id_forma_pagamento)  REFERENCES forma_pagamento (id),
    FOREIGN KEY (id_situacao_atual)   REFERENCES situacao (id),
    FOREIGN KEY (id_funcionario_abertura, id_funcionario_cargo_abertura) REFERENCES funcionario (id, id_cargo),
    FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE ordem_situacao (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem         INTEGER NOT NULL,
    id_nova_situacao INTEGER NOT NULL,
    id_tecnico       INTEGER NOT NULL,
    id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
    data_situacao    TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime'))
                     CHECK (data_situacao = DATETIME(data_situacao)),
    FOREIGN KEY (id_ordem)         REFERENCES ordem (id),
    FOREIGN KEY (id_nova_situacao) REFERENCES situacao (id),
    FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;


CREATE TABLE ordem_servico (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem        INTEGER NOT NULL,
    id_servico      INTEGER NOT NULL,
    preco_praticado INTEGER NOT NULL CHECK (preco_praticado >= 0),
    quantidade      INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    data_execucao   TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime'))
                    CHECK (data_execucao = DATETIME(data_execucao)),
    FOREIGN KEY (id_ordem)   REFERENCES ordem (id),
    FOREIGN KEY (id_servico) REFERENCES servico (id)
) STRICT;


CREATE TABLE ordem_peca (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    id_ordem        INTEGER NOT NULL,
    id_peca         INTEGER NOT NULL,
    preco_praticado INTEGER NOT NULL CHECK (preco_praticado >= 0),
    quantidade      INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    data_saida      TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime'))
                    CHECK (data_saida = DATETIME(data_saida)),
    FOREIGN KEY (id_ordem) REFERENCES ordem (id),
    FOREIGN KEY (id_peca)  REFERENCES peca (id)
) STRICT;


CREATE TABLE saida_peca (
    id               INTEGER PRIMARY KEY AUTOINCREMENT,
    id_peca          INTEGER NOT NULL,
    quantidade       INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario   INTEGER NOT NULL CHECK (preco_unitario >= 0),
    motivo           TEXT    NOT NULL CHECK (motivo IN ('USO_REPARO', 'DESCARTE')),
    id_ordem_peca    INTEGER UNIQUE,
    id_tecnico       INTEGER NOT NULL,
    id_tecnico_cargo INTEGER NOT NULL CHECK (id_tecnico_cargo = 3),
    data_saida       TEXT    NOT NULL DEFAULT (DATETIME('now', 'localtime'))
                     CHECK (data_saida = DATETIME(data_saida)),
    CHECK ((motivo = 'USO_REPARO' AND id_ordem_peca IS NOT NULL)
        OR (motivo = 'DESCARTE'   AND id_ordem_peca IS NULL)),
    FOREIGN KEY (id_peca)       REFERENCES peca (id),
    FOREIGN KEY (id_ordem_peca) REFERENCES ordem_peca (id),
    FOREIGN KEY (id_tecnico, id_tecnico_cargo) REFERENCES funcionario (id, id_cargo)
) STRICT;

CREATE INDEX idx_ordem_equipamento      ON ordem (id_equipamento);
CREATE INDEX idx_ordem_situacao_ordem   ON ordem_situacao (id_ordem);
CREATE INDEX idx_ordem_servico_ordem    ON ordem_servico (id_ordem);
CREATE INDEX idx_ordem_peca_ordem       ON ordem_peca (id_ordem);
CREATE INDEX idx_entrada_peca_peca      ON entrada_peca (id_peca);
CREATE INDEX idx_saida_peca_peca        ON saida_peca (id_peca);


CREATE TRIGGER trg_ai_entrada_peca_incrementar_estoque
AFTER INSERT ON entrada_peca
FOR EACH ROW
BEGIN
    UPDATE peca SET estoque_atual = estoque_atual + NEW.quantidade
    WHERE id = NEW.id_peca;
END;

CREATE TRIGGER trg_bi_saida_peca_validar_estoque
BEFORE INSERT ON saida_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'RN03: estoque insuficiente para a saída da peça.')
    WHERE (SELECT estoque_atual FROM peca WHERE id = NEW.id_peca) < NEW.quantidade;
END;

CREATE TRIGGER trg_ai_saida_peca_decrementar_estoque
AFTER INSERT ON saida_peca
FOR EACH ROW
BEGIN
    UPDATE peca SET estoque_atual = estoque_atual - NEW.quantidade
    WHERE id = NEW.id_peca;
END;


CREATE TRIGGER trg_bi_ordem_peca_validar_situacao_ordem
BEFORE INSERT ON ordem_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'RN01: peça só pode ser baixada com a OS em "Orçamento Aprovado" ou "Em Reparo".')
    WHERE (SELECT s.nome_situacao
             FROM ordem o JOIN situacao s ON s.id = o.id_situacao_atual
            WHERE o.id = NEW.id_ordem)
          NOT IN ('Orçamento Aprovado', 'Em Reparo');
END;


CREATE TRIGGER trg_ai_ordem_peca_registrar_saida_peca
AFTER INSERT ON ordem_peca
FOR EACH ROW
BEGIN
    INSERT INTO saida_peca (id_peca, quantidade, preco_unitario, motivo,
                            id_ordem_peca, id_tecnico, id_tecnico_cargo, data_saida)
    SELECT NEW.id_peca, NEW.quantidade, NEW.preco_praticado, 'USO_REPARO',
           NEW.id, o.id_tecnico, o.id_tecnico_cargo, NEW.data_saida
      FROM ordem o
     WHERE o.id = NEW.id_ordem;
END;

CREATE TRIGGER trg_ai_ordem_peca_atualizar_valor_total_ordem
AFTER INSERT ON ordem_peca
FOR EACH ROW
BEGIN
    UPDATE ordem
       SET valor_total = valor_total + (NEW.preco_praticado * NEW.quantidade)
     WHERE id = NEW.id_ordem;
END;


CREATE TRIGGER trg_bi_ordem_servico_validar_ordem_aberta
BEFORE INSERT ON ordem_servico
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'OS encerrada: não é possível lançar serviços.')
    WHERE (SELECT o.data_fechamento IS NOT NULL
                  OR s.nome_situacao IN ('Entregue', 'Cancelado')
             FROM ordem o JOIN situacao s ON s.id = o.id_situacao_atual
            WHERE o.id = NEW.id_ordem);
END;


CREATE TRIGGER trg_ai_ordem_servico_atualizar_valor_total_ordem
AFTER INSERT ON ordem_servico
FOR EACH ROW
BEGIN
    UPDATE ordem
       SET valor_total = valor_total + (NEW.preco_praticado * NEW.quantidade)
     WHERE id = NEW.id_ordem;
END;


CREATE TRIGGER trg_bu_ordem_servico_bloquear_alteracao_historico
BEFORE UPDATE OF id_ordem, id_servico, preco_praticado, data_execucao ON ordem_servico
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'RN02: histórico financeiro imutável (apenas a quantidade pode ser corrigida).');
END;

CREATE TRIGGER trg_bu_ordem_servico_validar_ordem_aberta
BEFORE UPDATE OF quantidade ON ordem_servico
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'OS encerrada: não é possível alterar serviços.')
    WHERE (SELECT o.data_fechamento IS NOT NULL
                  OR s.nome_situacao IN ('Entregue', 'Cancelado')
             FROM ordem o JOIN situacao s ON s.id = o.id_situacao_atual
            WHERE o.id = NEW.id_ordem);
END;


CREATE TRIGGER trg_au_ordem_servico_atualizar_valor_total_ordem
AFTER UPDATE OF quantidade ON ordem_servico
FOR EACH ROW
BEGIN
    UPDATE ordem
       SET valor_total = valor_total
                         - (OLD.preco_praticado * OLD.quantidade)
                         + (NEW.preco_praticado * NEW.quantidade)
     WHERE id = NEW.id_ordem;
END;

CREATE TRIGGER trg_bd_ordem_servico_validar_ordem_aberta
BEFORE DELETE ON ordem_servico
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'OS encerrada: não é possível remover serviços.')
    WHERE (SELECT o.data_fechamento IS NOT NULL
                  OR s.nome_situacao IN ('Entregue', 'Cancelado')
             FROM ordem o JOIN situacao s ON s.id = o.id_situacao_atual
            WHERE o.id = OLD.id_ordem);
END;


CREATE TRIGGER trg_ad_ordem_servico_atualizar_valor_total_ordem
AFTER DELETE ON ordem_servico
FOR EACH ROW
BEGIN
    UPDATE ordem
       SET valor_total = valor_total - (OLD.preco_praticado * OLD.quantidade)
     WHERE id = OLD.id_ordem;
END;


CREATE TRIGGER trg_bi_ordem_validar_abertura
BEFORE INSERT ON ordem
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'A OS deve ser aberta com a situação "Aberto".')
    WHERE NEW.id_situacao_atual IS NOT (SELECT id FROM situacao WHERE nome_situacao = 'Aberto');
    SELECT RAISE(ABORT, 'RN04: valor_total é calculado automaticamente e deve iniciar em zero.')
    WHERE NEW.valor_total <> 0;
    SELECT RAISE(ABORT, 'Uma OS não pode ser aberta já encerrada.')
    WHERE NEW.data_fechamento IS NOT NULL OR NEW.id_forma_pagamento IS NOT NULL;
END;

CREATE TRIGGER trg_ai_ordem_registrar_situacao_inicial
AFTER INSERT ON ordem
FOR EACH ROW
BEGIN
    INSERT INTO ordem_situacao (id_ordem, id_nova_situacao, id_tecnico, id_tecnico_cargo, data_situacao)
    VALUES (NEW.id, NEW.id_situacao_atual, NEW.id_tecnico, NEW.id_tecnico_cargo, NEW.data_abertura);
END;


CREATE TRIGGER trg_bu_ordem_validar_situacao_atual
BEFORE UPDATE OF id_situacao_atual ON ordem
FOR EACH ROW
WHEN NEW.id_situacao_atual <> OLD.id_situacao_atual
BEGIN
    SELECT RAISE(ABORT, 'A situação da OS só muda registrando uma linha em ordem_situacao.')
    WHERE NEW.id_situacao_atual IS NOT
          (SELECT id_nova_situacao FROM ordem_situacao
            WHERE id_ordem = NEW.id ORDER BY id DESC LIMIT 1);
END;


CREATE TRIGGER trg_bu_ordem_validar_fechamento
BEFORE UPDATE OF data_fechamento, id_forma_pagamento ON ordem
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'OS já encerrada: fechamento e pagamento não podem ser alterados.')
    WHERE OLD.data_fechamento IS NOT NULL;
    SELECT RAISE(ABORT, 'Só é possível encerrar a OS nas situações "Entregue" ou "Cancelado".')
    WHERE NEW.data_fechamento IS NOT NULL
      AND (SELECT nome_situacao FROM situacao WHERE id = NEW.id_situacao_atual)
          NOT IN ('Entregue', 'Cancelado');
    SELECT RAISE(ABORT, 'RN04: informe a forma de pagamento no encerramento da OS.')
    WHERE NEW.data_fechamento IS NOT NULL
      AND NEW.id_forma_pagamento IS NULL
      AND (SELECT nome_situacao FROM situacao WHERE id = NEW.id_situacao_atual) <> 'Cancelado';
END;


CREATE TRIGGER trg_bi_ordem_situacao_validar_registro
BEFORE INSERT ON ordem_situacao
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Somente o técnico responsável pela OS registra mudanças de situação.')
    WHERE NEW.id_tecnico IS NOT (SELECT id_tecnico FROM ordem WHERE id = NEW.id_ordem);
    SELECT RAISE(ABORT, 'OS Entregue/Cancelada não pode mudar de situação.')
    WHERE (SELECT s.nome_situacao
             FROM ordem o JOIN situacao s ON s.id = o.id_situacao_atual
            WHERE o.id = NEW.id_ordem) IN ('Entregue', 'Cancelado');
END;


CREATE TRIGGER trg_ai_ordem_situacao_atualizar_situacao_atual_ordem
AFTER INSERT ON ordem_situacao
FOR EACH ROW
BEGIN
    UPDATE ordem SET id_situacao_atual = NEW.id_nova_situacao
    WHERE id = NEW.id_ordem;
END;



CREATE TRIGGER trg_bu_entrada_peca_bloquear_alteracao
BEFORE UPDATE ON entrada_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Entrada de peça é um registro imutável (auditoria): não pode ser alterado.');
END;

CREATE TRIGGER trg_bd_entrada_peca_bloquear_exclusao
BEFORE DELETE ON entrada_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Entrada de peça é um registro imutável (auditoria): não pode ser excluído.');
END;

CREATE TRIGGER trg_bu_saida_peca_bloquear_alteracao
BEFORE UPDATE ON saida_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Saída de peça é um registro imutável (auditoria): não pode ser alterado.');
END;

CREATE TRIGGER trg_bd_saida_peca_bloquear_exclusao
BEFORE DELETE ON saida_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Saída de peça é um registro imutável (auditoria): não pode ser excluído.');
END;

CREATE TRIGGER trg_bu_ordem_situacao_bloquear_alteracao
BEFORE UPDATE ON ordem_situacao
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Histórico de situação é um registro imutável (auditoria): não pode ser alterado.');
END;

CREATE TRIGGER trg_bd_ordem_situacao_bloquear_exclusao
BEFORE DELETE ON ordem_situacao
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Histórico de situação é um registro imutável (auditoria): não pode ser excluído.');
END;

CREATE TRIGGER trg_bu_ordem_peca_bloquear_alteracao
BEFORE UPDATE ON ordem_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Peça vinculada à OS é um registro imutável (auditoria): não pode ser alterado.');
END;

CREATE TRIGGER trg_bd_ordem_peca_bloquear_exclusao
BEFORE DELETE ON ordem_peca
FOR EACH ROW
BEGIN
    SELECT RAISE(ABORT, 'Peça vinculada à OS é um registro imutável (auditoria): não pode ser excluído.');
END;




CREATE VIEW vw_peca_preco_venda_maior_100 AS
SELECT id, nome_peca, preco_venda / 100.0 AS preco_reais, estoque_atual
  FROM peca
 WHERE preco_venda >= 10000;


CREATE VIEW vw_estoque_baixo AS
SELECT id, nome_peca, estoque_atual
  FROM peca
 WHERE estoque_atual <= 20
 ORDER BY estoque_atual ASC;

CREATE VIEW vw_estoque_por_categoria AS
SELECT c.nome_categoria                              AS categoria,
       COUNT(*)                                      AS qtd_pecas,
       SUM(p.estoque_atual)                          AS itens_em_estoque,
       ROUND(AVG(p.preco_venda) / 100.0, 2)          AS preco_medio_reais,
       ROUND(SUM(p.preco_venda * p.estoque_atual) / 100.0, 2) AS valor_em_estoque_reais
  FROM peca p
  JOIN categoria c ON c.id = p.id_categoria
 WHERE p.status = 1
 GROUP BY c.nome_categoria;


CREATE VIEW vw_peca_margem AS
SELECT p.id,
       p.nome_peca,
       p.preco_venda / 100.0                                        AS venda_reais,
       e.preco_custo / 100.0                                        AS custo_reais,
       (p.preco_venda - e.preco_custo) / 100.0                      AS lucro_unitario_reais,
       ROUND((p.preco_venda - e.preco_custo) * 100.0 / e.preco_custo, 1) AS margem_percentual
  FROM peca p
  JOIN entrada_peca e
    ON e.id = (SELECT MAX(id) FROM entrada_peca WHERE id_peca = p.id);


CREATE VIEW vw_ordem_atual AS
SELECT o.id                         AS ordem,
       cl.nome_cliente              AS cliente,
       t.nome_tipo || ' ' || ma.nome_marca || ' ' || mo.nome_modelo AS equipamento,
       s.nome_situacao              AS situacao,
       ft.nome_funcionario          AS tecnico,
       fa.nome_funcionario          AS aberta_por,
       o.data_abertura,
       o.data_fechamento,
       fp.nome_forma_pagamento      AS forma_pagamento,
       o.valor_total / 100.0        AS valor_total_reais
  FROM ordem o
  JOIN equipamento e   ON e.id  = o.id_equipamento
  JOIN cliente cl      ON cl.id = e.id_cliente
  JOIN tipo t          ON t.id  = e.id_tipo
  JOIN marca ma        ON ma.id = e.id_marca
  JOIN modelo mo       ON mo.id = e.id_modelo
  JOIN situacao s      ON s.id  = o.id_situacao_atual
  JOIN funcionario ft  ON ft.id = o.id_tecnico
  JOIN funcionario fa  ON fa.id = o.id_funcionario_abertura
  LEFT JOIN forma_pagamento fp ON fp.id = o.id_forma_pagamento;


CREATE VIEW vw_historico_ordem AS
SELECT h.id_ordem  AS ordem,
       s.nome_situacao AS nova_situacao,
       f.nome_funcionario AS tecnico_responsavel,
       h.data_situacao
  FROM ordem_situacao h
  JOIN situacao s    ON s.id = h.id_nova_situacao
  JOIN funcionario f ON f.id = h.id_tecnico
 ORDER BY h.id_ordem, h.id;

CREATE VIEW vw_ordem_conferencia_total AS
SELECT o.id AS ordem,
       o.valor_total AS valor_total_gravado,
       COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_servico WHERE id_ordem = o.id), 0)
     + COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_peca    WHERE id_ordem = o.id), 0)
         AS valor_total_recalculado,
       o.valor_total
     - ( COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_servico WHERE id_ordem = o.id), 0)
       + COALESCE((SELECT SUM(preco_praticado * quantidade) FROM ordem_peca    WHERE id_ordem = o.id), 0) )
         AS diferenca
  FROM ordem o;

CREATE VIEW vw_faturamento_por_tecnico AS
SELECT f.nome_funcionario                  AS tecnico,
       COUNT(*)                            AS os_encerradas,
       ROUND(SUM(o.valor_total) / 100.0, 2) AS faturamento_reais,
       ROUND(AVG(o.valor_total) / 100.0, 2) AS ticket_medio_reais
  FROM ordem o
  JOIN funcionario f ON f.id = o.id_tecnico
 WHERE o.id_forma_pagamento IS NOT NULL
 GROUP BY f.nome_funcionario;


INSERT INTO cargo (nome_cargo) VALUES ('Gerente'), ('Atendente'), ('Técnico');

INSERT INTO funcionario (nome_funcionario, id_cargo) VALUES
    ('Carlos Eduardo Silva', 1),
    ('Ana Beatriz Rocha', 2), ('Lucas Fernando Santos', 2), ('Mariana Costa Lima', 2),
    ('Gabriel Alves Pereira', 3), ('Juliana Rodrigues Mendes', 3);

INSERT INTO situacao (nome_situacao) VALUES
    ('Aberto'), ('Em Diagnóstico'), ('Orçamento Aprovado'), ('Em Reparo'),
    ('Pronto'), ('Entregue'), ('Cancelado');

INSERT INTO forma_pagamento (nome_forma_pagamento, id_funcionario, id_funcionario_cargo) VALUES
    ('Dinheiro',1,1), ('PIX',1,1), ('Cartão de Débito',1,1),
    ('Cartão de Crédito - À Vista',1,1), ('Cartão de Crédito - Parcelado',1,1), ('Boleto Bancário',1,1);

INSERT INTO categoria (nome_categoria, id_funcionario, id_funcionario_cargo) VALUES
    ('acessórios',1,1),
    ('áudio',1,1),
    ('baterias',1,1),
    ('carcaças',1,1),
    ('celulares',1,1),
    ('componentes',1,1),
    ('computadores',1,1),
    ('eletrônica avançada',1,1),
    ('informática',1,1),
    ('insumos',1,1),
    ('recuperação de dados',1,1),
    ('redes',1,1),
    ('smart tvs',1,1),
    ('telas',1,1),
    ('tvs',1,1),
    ('videogames',1,1);

INSERT INTO servico (nome_servico, id_categoria, preco, horas_trabalho, id_funcionario, id_funcionario_cargo) VALUES
    ('Formatação e Instalação de Sistema Operacional', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 12000, 2.0, 1, 1),
    ('Limpeza Interna e Troca de Pasta Térmica', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 15000, 1.5, 1, 1),
    ('Upgrade de Hardware (RAM/SSD)', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 8000, 1.0, 1, 1),
    ('Remoção de Vírus e Malwares', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 10000, 1.5, 1, 1),
    ('Troca de Tela de Notebook', (SELECT id FROM categoria WHERE nome_categoria = 'telas'), 18000, 1.5, 1, 1),
    ('Troca de Display/Frontal de Celular', (SELECT id FROM categoria WHERE nome_categoria = 'telas'), 15000, 1.0, 1, 1),
    ('Troca de Bateria de Smartphone', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 9000, 0.5, 1, 1),
    ('Desoxidação após Contato com Líquido', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 20000, 3.0, 1, 1),
    ('Reparo em Conector de Carga (Micro USB / Type-C)', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 11000, 1.5, 1, 1),
    ('Troca de Barra de LED de Smart TV', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 35000, 3.0, 1, 1),
    ('Reparo na Placa Principal de Smart TV', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 28000, 2.5, 1, 1),
    ('Conserto de Fonte de Alimentação Interna (TV)', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 22000, 2.0, 1, 1),
    ('Configuração de Rede e Roteador Wi-Fi', (SELECT id FROM categoria WHERE nome_categoria = 'redes'), 9000, 1.0, 1, 1),
    ('Higienização e Troca de Metal Líquido / Pasta Térmica (Console)', (SELECT id FROM categoria WHERE nome_categoria = 'videogames'), 22000, 2.0, 1, 1),
    ('Reparo de Drift em Analógico de Controle (Joy-Con / DualSense / Xbox)', (SELECT id FROM categoria WHERE nome_categoria = 'videogames'), 8000, 1.0, 1, 1),
    ('Substituição de HDMI / Conector de Vídeo (Console)', (SELECT id FROM categoria WHERE nome_categoria = 'videogames'), 25000, 2.5, 1, 1),
    ('Troca de Bateria de Caixa de Som Portátil (Bluetooth)', (SELECT id FROM categoria WHERE nome_categoria = 'áudio'), 12000, 1.5, 1, 1),
    ('Troca de Almofadas / Reparo de Cabo de Headset Gamer', (SELECT id FROM categoria WHERE nome_categoria = 'áudio'), 7000, 1.0, 1, 1),
    ('Recuperação de Dados de HD / SSD / Pendrive Danificado', (SELECT id FROM categoria WHERE nome_categoria = 'recuperação de dados'), 30000, 4.0, 1, 1),
    ('Rebaling / Reparo de BGA em Placa Mãe ou Placa de Vídeo', (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'), 45000, 5.0, 1, 1),
    ('Gravação e Reprogramação de BIOS Eprom (Notebook / Desktop)', (SELECT id FROM categoria WHERE nome_categoria = 'eletrônica avançada'), 16000, 2.0, 1, 1),
    ('Troca de Vidro Traseiro de Smartphone a Laser / Manual', (SELECT id FROM categoria WHERE nome_categoria = 'celulares'), 18000, 2.5, 1, 1),
    ('Reparo e Solda de Conector Jack P2/P10 de Mesa de Som ou Amplificador', (SELECT id FROM categoria WHERE nome_categoria = 'áudio'), 9500, 1.0, 1, 1);


INSERT INTO peca (nome_peca, id_categoria, preco_venda, id_funcionario, id_funcionario_cargo) VALUES
    ('SSD NVMe 512GB M.2', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 26000, 1, 1),
    ('SSD SATA III 480GB 2.5"', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 21000, 1, 1),
    ('Memória RAM DDR4 8GB 2666MHz (Notebook)', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 17000, 1, 1),
    ('Memória RAM DDR4 16GB 3200MHz (Desktop)', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 32000, 1, 1),
    ('Pasta Térmica de Alta Performance (Bisnaga 4g)', (SELECT id FROM categoria WHERE nome_categoria = 'insumos'), 6000, 1, 1),
    ('Fonte ATX 500W 80 Plus Bronze', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 34000, 1, 1),
    ('Bateria Célula Moeda CR2032 (Cartela c/ 5)', (SELECT id FROM categoria WHERE nome_categoria = 'insumos'), 2500, 1, 1),
    ('Cooler para Processador Socket Universal', (SELECT id FROM categoria WHERE nome_categoria = 'informática'), 9500, 1, 1),
    ('Cabo SATA III 6Gbps 50cm', (SELECT id FROM categoria WHERE nome_categoria = 'acessórios'), 1500, 1, 1),
    ('Tela LED 15.6" Slim 30 Pinos Full HD', (SELECT id FROM categoria WHERE nome_categoria = 'telas'), 48000, 1, 1),
    ('Display Frontal Completo iPhone 11', (SELECT id FROM categoria WHERE nome_categoria = 'telas'), 35000, 1, 1),
    ('Display Frontal Completo Samsung Galaxy A54', (SELECT id FROM categoria WHERE nome_categoria = 'telas'), 31000, 1, 1),
    ('Display Frontal Completo Motorola Moto G84', (SELECT id FROM categoria WHERE nome_categoria = 'telas'), 28000, 1, 1),
    ('Bateria Compatível iPhone 11 (3110mAh)', (SELECT id FROM categoria WHERE nome_categoria = 'baterias'), 16000, 1, 1),
    ('Bateria Compatível Samsung Galaxy A32', (SELECT id FROM categoria WHERE nome_categoria = 'baterias'), 13000, 1, 1),
    ('Bateria Compatível Moto G30', (SELECT id FROM categoria WHERE nome_categoria = 'baterias'), 12000, 1, 1),
    ('Conector de Carga Type-C Universal (Unidade)', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 2000, 1, 1),
    ('Conector de Carga Micro USB V8', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 1500, 1, 1),
    ('Flex de Carga e Microfone Moto G9 Play', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 5500, 1, 1),
    ('Tampa Traseira de Vidro iPhone 12', (SELECT id FROM categoria WHERE nome_categoria = 'carcaças'), 11000, 1, 1),
    ('Câmera Traseira Principal Redmi Note 11', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 14000, 1, 1),
    ('Alto-Falante Auricular Universal', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 2500, 1, 1),
    ('Barra de LED TV Samsung 50" (Kit com 3 barras)', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 23000, 1, 1),
    ('Barra de LED TV LG 43" (Kit com 3 barras)', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 19500, 1, 1),
    ('Placa Fonte TV Samsung UN50TU8000', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 31000, 1, 1),
    ('Placa Principal TV LG 43UP7500', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 42000, 1, 1),
    ('Cabo Flat T-Con para Display TV 55"', (SELECT id FROM categoria WHERE nome_categoria = 'smart tvs'), 6500, 1, 1),
    ('Receptor Infravermelho para Controle Remoto TV', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 2000, 1, 1),
    ('Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)', (SELECT id FROM categoria WHERE nome_categoria = 'insumos'), 15000, 1, 1),
    ('Álcool Isopropílico 99.8% 1 Litro', (SELECT id FROM categoria WHERE nome_categoria = 'insumos'), 4500, 1, 1),
    ('Fita Kapton Térmica 10mm x 33m', (SELECT id FROM categoria WHERE nome_categoria = 'insumos'), 3000, 1, 1),
    ('Fita Dupla Face Fixação de Telas (3mm x 50m)', (SELECT id FROM categoria WHERE nome_categoria = 'insumos'), 3500, 1, 1),
    ('Fusível de Louça 5A 250V (Pacote c/ 10)', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 1800, 1, 1),
    ('Capacitor Eletrolítico 1000uF x 25V', (SELECT id FROM categoria WHERE nome_categoria = 'componentes'), 500, 1, 1);

INSERT INTO entrada_peca (id_peca, quantidade, preco_custo, preco_venda_sugerido, id_funcionario, id_funcionario_cargo, data_entrada) VALUES
    ((SELECT id FROM peca WHERE nome_peca = 'SSD NVMe 512GB M.2'), 15, 18000, 26000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'SSD SATA III 480GB 2.5"'), 20, 13020, 21000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Memória RAM DDR4 8GB 2666MHz (Notebook)'), 12, 11000, 17000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Memória RAM DDR4 16GB 3200MHz (Desktop)'), 8, 19840, 32000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Pasta Térmica de Alta Performance (Bisnaga 4g)'), 25, 3720, 6000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Fonte ATX 500W 80 Plus Bronze'), 6, 21080, 34000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Bateria Célula Moeda CR2032 (Cartela c/ 5)'), 30, 1550, 2500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Cooler para Processador Socket Universal'), 10, 5890, 9500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Cabo SATA III 6Gbps 50cm'), 50, 930, 1500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Tela LED 15.6" Slim 30 Pinos Full HD'), 5, 29760, 48000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Display Frontal Completo iPhone 11'), 4, 22000, 35000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Display Frontal Completo Samsung Galaxy A54'), 6, 19220, 31000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Display Frontal Completo Motorola Moto G84'), 5, 17360, 28000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Bateria Compatível iPhone 11 (3110mAh)'), 8, 9000, 16000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Bateria Compatível Samsung Galaxy A32'), 7, 8060, 13000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Bateria Compatível Moto G30'), 6, 7440, 12000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Conector de Carga Type-C Universal (Unidade)'), 100, 1240, 2000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Conector de Carga Micro USB V8'), 100, 930, 1500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Flex de Carga e Microfone Moto G9 Play'), 10, 3410, 5500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Tampa Traseira de Vidro iPhone 12'), 4, 6820, 11000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Câmera Traseira Principal Redmi Note 11'), 3, 8680, 14000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Alto-Falante Auricular Universal'), 40, 1550, 2500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Barra de LED TV Samsung 50" (Kit com 3 barras)'), 4, 14000, 23000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Barra de LED TV LG 43" (Kit com 3 barras)'), 5, 12090, 19500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Placa Fonte TV Samsung UN50TU8000'), 2, 19220, 31000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Placa Principal TV LG 43UP7500'), 2, 26040, 42000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Cabo Flat T-Con para Display TV 55"'), 8, 4030, 6500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Receptor Infravermelho para Controle Remoto TV'), 15, 1240, 2000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Solda em Fio Sn60/Pb40 0.8mm (Carretel 500g)'), 3, 9300, 15000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Álcool Isopropílico 99.8% 1 Litro'), 12, 2790, 4500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Fita Kapton Térmica 10mm x 33m'), 15, 1860, 3000, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Fita Dupla Face Fixação de Telas (3mm x 50m)'), 10, 2170, 3500, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Fusível de Louça 5A 250V (Pacote c/ 10)'), 20, 1116, 1800, 1, 1, '2026-08-20 09:00:00'),
    ((SELECT id FROM peca WHERE nome_peca = 'Capacitor Eletrolítico 1000uF x 25V'), 150, 310, 500, 1, 1, '2026-08-20 09:00:00');



INSERT INTO cliente (nome_cliente, email, telefone, id_funcionario, id_funcionario_cargo) VALUES
    ('Marcos Vinicius Souza',   'marcos.souza@email.com',     '(11) 91234-0001', 2, 2),
    ('Fernanda Maria Oliveira', 'fernanda.oliveira@email.com','(11) 91234-0002', 2, 2),
    ('Roberto Carlos Andrade',  'roberto.andrade@email.com',  '(11) 91234-0003', 3, 2),
    ('Camila de Cassia Martins','camila.martins@email.com',   '(11) 91234-0004', 3, 2),
    ('Patricia Ferreira Lima',  'patricia.lima@email.com',    '(11) 91234-0005', 4, 2),
    ('Lucas Gabriel Barbosa',   'lucas.barbosa@email.com',    '(11) 91234-0006', 1, 1);


INSERT INTO marca (nome_marca, id_funcionario, id_funcionario_cargo) VALUES
    ('Apple',1,1), ('Samsung',1,1), ('Motorola',2,2), ('Xiaomi',2,2),
    ('Dell',3,2), ('Lenovo',3,2), ('LG',1,1), ('Sony',4,2);

INSERT INTO modelo (nome_modelo, id_funcionario, id_funcionario_cargo) VALUES
    ('iPhone 11',2,2), ('iPhone 12',2,2), ('Galaxy A54',2,2), ('Galaxy A32',3,2),
    ('Moto G84',3,2), ('Moto G30',3,2), ('Redmi Note 11',4,2), ('Inspiron 15 3000',1,1),
    ('IdeaPad 3',2,2), ('Smart TV 50 UN50TU8000',3,2), ('Smart TV 43 43UP7500',4,2), ('PlayStation 5',1,1);

INSERT INTO tipo (nome_tipo, id_funcionario, id_funcionario_cargo) VALUES
    ('Smartphone',1,1), ('Notebook',1,1), ('Desktop',2,2), ('Smart TV',2,2),
    ('Console de Videogame',3,2), ('Caixa de Som Bluetooth',4,2);

INSERT INTO equipamento (id_marca, id_modelo, id_tipo, id_cliente, id_funcionario, id_funcionario_cargo, numero_serie, imei) VALUES
    (1, 1, 1, 1, 2, 2, NULL,                   '356789012345671'),  -- 1 iPhone 11
    (2, 3, 1, 2, 2, 2, NULL,                   '356789012345672'),  -- 2 Galaxy A54
    (5, 8, 2, 3, 3, 2, 'DELL-INSP-2023-998',   NULL),               -- 3 Notebook Dell
    (7, 11, 4, 4, 3, 2, 'LG-TV43-77612',       NULL),               -- 4 Smart TV LG 43
    (8, 12, 5, 5, 4, 2, 'PS5-SONY-009182',     NULL),               -- 5 PlayStation 5
    (3, 5, 1, 6, 1, 1, NULL,                   '356789012345673');  -- 6 Moto G84

INSERT INTO ordem (id_equipamento, defeito_relatado, data_abertura,
                   id_funcionario_abertura, id_funcionario_cargo_abertura, id_tecnico, id_tecnico_cargo) VALUES
    (1, 'Tela quebrada após queda.',               '2026-09-01 09:30:00', 2, 2, 5, 3),  -- OS 1
    (3, 'Notebook muito lento para ligar.',        '2026-09-10 10:15:00', 3, 2, 6, 3),  -- OS 2
    (4, 'TV com som, mas imagem não aparece.',     '2026-09-15 11:00:00', 2, 2, 5, 3),  -- OS 3
    (5, 'Desligando por aquecimento.',             '2026-09-20 14:20:00', 4, 2, 6, 3),  -- OS 4
    (2, 'Celular não carrega.',                    '2026-09-22 08:50:00', 2, 2, 5, 3);  -- OS 5


INSERT INTO ordem_situacao (id_ordem, id_nova_situacao, id_tecnico, id_tecnico_cargo, data_situacao) VALUES

    (1, 2, 5, 3, '2026-09-01 10:00:00'),
    (1, 3, 5, 3, '2026-09-01 11:30:00'),
    (1, 4, 5, 3, '2026-09-01 14:00:00'),
    -- OS 2: Aberto > Orçamento Aprovado > Em Reparo
    (2, 3, 6, 3, '2026-09-10 10:45:00'),
    (2, 4, 6, 3, '2026-09-10 11:00:00'),
    -- OS 3: Aberto > Em Diagnóstico
    (3, 2, 5, 3, '2026-09-15 15:00:00'),
    -- OS 4: Aberto > Orçamento Aprovado > Em Reparo
    (4, 3, 6, 3, '2026-09-20 15:00:00'),
    (4, 4, 6, 3, '2026-09-20 16:00:00'),
    -- OS 5: Aberto > Em Diagnóstico
    (5, 2, 5, 3, '2026-09-22 09:30:00');

UPDATE ordem SET defeito_constatado = 'Display frontal danificado, toque não responde.' WHERE id = 1;
UPDATE ordem SET defeito_constatado = 'Lentidão provocada por HD mecânico antigo.'       WHERE id = 2;
UPDATE ordem SET defeito_constatado = 'Barra de LED queimada.'                           WHERE id = 3;
UPDATE ordem SET defeito_constatado = 'Acúmulo de poeira; troca de pasta térmica necessária.' WHERE id = 4;
UPDATE ordem SET defeito_constatado = 'Conector de carga com mau contato (usuário optou por não reparar).' WHERE id = 5;

INSERT INTO ordem_servico (id_ordem, id_servico, preco_praticado, quantidade, data_execucao) VALUES
    (1, 6,  (SELECT preco FROM servico WHERE id = 6),  1, '2026-09-01 15:00:00'),  -- Troca de display
    (2, 3,  (SELECT preco FROM servico WHERE id = 3),  1, '2026-09-10 12:00:00'),  -- Upgrade SSD
    (2, 1,  (SELECT preco FROM servico WHERE id = 1),  1, '2026-09-10 13:00:00'),  -- Formatação
    (3, 10, (SELECT preco FROM servico WHERE id = 10), 1, '2026-09-15 16:00:00'),  -- Barra de LED
    (4, 14, (SELECT preco FROM servico WHERE id = 14), 1, '2026-09-20 16:30:00');  -- Higienização PS5


INSERT INTO ordem_peca (id_ordem, id_peca, preco_praticado, quantidade, data_saida) VALUES
    (1, (SELECT id FROM peca WHERE nome_peca = 'Display Frontal Completo iPhone 11'),
        (SELECT preco_venda FROM peca WHERE nome_peca = 'Display Frontal Completo iPhone 11'), 1, '2026-09-01 14:30:00'),
    (2, (SELECT id FROM peca WHERE nome_peca = 'SSD NVMe 512GB M.2'),
        (SELECT preco_venda FROM peca WHERE nome_peca = 'SSD NVMe 512GB M.2'), 1, '2026-09-10 11:30:00'),
    (4, (SELECT id FROM peca WHERE nome_peca = 'Pasta Térmica de Alta Performance (Bisnaga 4g)'),
        (SELECT preco_venda FROM peca WHERE nome_peca = 'Pasta Térmica de Alta Performance (Bisnaga 4g)'), 1, '2026-09-20 16:10:00');

INSERT INTO saida_peca (id_peca, quantidade, preco_unitario, motivo, id_tecnico, id_tecnico_cargo, data_saida) VALUES
    ((SELECT id FROM peca WHERE nome_peca = 'Pasta Térmica de Alta Performance (Bisnaga 4g)'),
     1, 6000, 'DESCARTE', 5, 3, '2026-09-21 10:00:00');


INSERT INTO ordem_situacao (id_ordem, id_nova_situacao, id_tecnico, id_tecnico_cargo, data_situacao) VALUES
    (1, 5, 5, 3, '2026-09-02 15:30:00'),
    (1, 6, 5, 3, '2026-09-02 16:00:00');
UPDATE ordem SET data_fechamento = '2026-09-02 16:00:00', id_forma_pagamento = 2 WHERE id = 1;


INSERT INTO ordem_situacao (id_ordem, id_nova_situacao, id_tecnico, id_tecnico_cargo, data_situacao) VALUES
    (2, 5, 6, 3, '2026-09-11 14:30:00');


INSERT INTO ordem_situacao (id_ordem, id_nova_situacao, id_tecnico, id_tecnico_cargo, data_situacao) VALUES
    (5, 7, 5, 3, '2026-09-22 11:00:00');
UPDATE ordem SET data_fechamento = '2026-09-22 11:00:00' WHERE id = 5;