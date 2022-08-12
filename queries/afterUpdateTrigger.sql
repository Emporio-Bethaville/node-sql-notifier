CREATE TRIGGER trgAfterUpdate ON [dbo].[mt_Itens] FOR UPDATE AS

declare @id int;
declare @date datetime;
declare @person varchar(50);
declare @details nvarchar(225);
declare @productId int;
declare @itemNumber int;

select
    @id = i.idComanda,
    @date = i.dtData,
    @person = i.stOperador,
	@productId = i.idProduto,
    @details = i.stIncremento,
	@itemNumber = i.nrItem   
from
    inserted i;

insert into
    OrdersApp.dbo.itensComandas (
        id,
        date,
        person,
        microterminal,
        details,
        productId,
		itemNumber
    )
values
    (
        @id,
        @date,
        @person,
        NULL,
        @details,
        @productId,
		@itemNumber
    )
GO