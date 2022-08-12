CREATE TRIGGER trgAfterInsert ON [ dbo ].[ mt_Itens ] FOR INSERT AS declare @ id int;

declare @ date datetime;

declare @ quantity float;

declare @ person varchar(50);

declare @ microterminal varchar(50);

declare @ dscrpt varchar(29);

declare @ details nvarchar(225);

declare @ productId int;

declare @ itemNumber int;

declare @ sector int;

declare @ tableId int;

declare @ unit varchar(2);

select
  @ id = i.idComanda,
  @ date = i.dtData,
  @ quantity = i.nrQuantidade,
  @ person = i.stOperador,
  @ microterminal = i.idMicroterminal,
  @ productId = i.idProduto,
  @ details = i.stIncremento,
  @ itemNumber = i.nrItem,
  @ unit = i.medida,
from
  inserted i;

select
  @ dscrpt = (
    SELECT
      stProduto
    FROM
      [ NATI2 ].[ dbo ].[ prd_Produtos ]
    where
      idProduto = @ productId
  )
select
  @ sector = (
    SELECT
      idPrint
    FROM
      [ NATI2 ].[ dbo ].[ mt_ProdutosPrint ]
    where
      idProduto = @ productId
      and idMicroterminal = @ microterminal
  );

select
  @ tableId = (
    SELECT
      idMesa
    FROM
      [ NATI2 ].[ dbo ].[ mt_Atendimentos ]
    where
      idComanda = @ id
  );

IF @ sector IS NOT NULL BEGIN IF @ unit = 'UN' BEGIN DECLARE @ cnt INT = 0;

WHILE @ cnt < @ quantity BEGIN
insert into
  OrdersApp.dbo.itensComandas (
    id,
    date,
    quantity,
    person,
    microterminal,
    dscrpt,
    details,
    productId,
    itemNumber,
    sector,
    tableId
  )
values
  (
    @ id,
    @ date,
    1,
    @ person,
    @ microterminal,
    @ dscrpt,
    @ details,
    @ productId,
    @ itemNumber,
    @ sector,
    @ tableId
  )
SET
  @ cnt = @ cnt + 1;

END
ELSE BEGIN
insert into
  OrdersApp.dbo.itensComandas (
    id,
    date,
    quantity,
    person,
    microterminal,
    dscrpt,
    details,
    productId,
    itemNumber,
    sector,
    tableId
  )
values
  (
    @ id,
    @ date,
    @ quantity,
    @ person,
    @ microterminal,
    @ dscrpt,
    @ details,
    @ productId,
    @ itemNumber,
    @ sector,
    @ tableId
  )
END
END
END GO