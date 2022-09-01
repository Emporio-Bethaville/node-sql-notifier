CREATE TRIGGER trgAfterDelete ON [dbo].[mt_Itens] FOR DELETE AS 
-- ALTER TRIGGER trgAfterDelete ON [dbo].[mt_Itens] FOR DELETE AS 

declare @id int;
declare @productId int;
declare @itemNumber int;

select
  @id = i.idComanda,
  @productId = i.idProduto,
  @itemNumber = i.nrItem
from
  deleted i;

insert into
  OrdersApp.dbo.itensComandas (
    id,
    productId,
    itemNumber,
    details
  )
values
  (
    @id,
    @productId,
    @itemNumber,
    'Delete Item'
  )

GO