--CREATE TRIGGER trgAfterInsert ON [dbo].[mt_Itens] FOR INSERT AS 
ALTER TRIGGER [dbo].[trgAfterInsert] ON [mt_Itens] FOR INSERT AS

declare @id int;
declare @date datetime;
declare @quantity float;
declare @person varchar(50);
declare @microterminal varchar(50);
declare @dscrpt varchar(29);
declare @details nvarchar(225);
declare @productId int;
declare @itemNumber int;
declare @sector int;
declare @tableId int;
declare @unit smallint;

select
  @id = i.idComanda,
  @date = i.dtData,
  @quantity = i.nrQuantidade,
  @person = i.stOperador,
  @microterminal = i.idMicroterminal,
  @productId = i.idProduto,
  @details = i.stIncremento,
  @itemNumber = i.nrItem
from
  inserted i;

select @dscrpt = (SELECT stProduto FROM [NATI2].[dbo].[prd_Produtos] where idProduto = @productId)
select @sector = (SELECT idPrint FROM [NATI2].[dbo].[mt_ProdutosPrint] where idProduto = @productId and idMicroterminal = @microterminal);
select @tableId = (SELECT idMesa FROM [NATI2].[dbo].[mt_Atendimentos] where idComanda = @id);
select @unit = (SELECT idMedida FROM [NATI2].[dbo].[prd_Produtos] where idProduto = @productId);

IF @sector IS NOT NULL
BEGIN

-- If unit is 1, it's a unitary product
IF @unit = 1
BEGIN

DECLARE @cnt int = 0;

WHILE @cnt < @quantity
BEGIN

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
    @id,
    @date,
    1,
    @person,
    @microterminal,
    @dscrpt,
    @details,
    @productId,
    @itemNumber,
    @sector,
    @tableId
  )
SET
  @cnt = @cnt + 1;

END -- End While

END -- End IF @unit = 1

ELSE -- Else if @unit != 1
BEGIN
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
    @id,
    @date,
    @quantity,
    @person,
    @microterminal,
    @dscrpt,
    @details,
    @productId,
    @itemNumber,
    @sector,
    @tableId
  )
END -- End Else if @unit != '1'

END -- END IF @sector IS NOT NULL
GO