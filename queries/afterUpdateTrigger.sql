CREATE TRIGGER trgAfterUpdate ON [dbo].[mt_Itens] FOR UPDATE AS
-- UPDATE TRIGGER [dbo].[trgAfterUpdate] on [mt_Itens]

declare @id int;
declare @date datetime;
declare @person varchar(50);
declare @details nvarchar(225);
declare @productId int;
declare @itemNumber int;
declare @tableId int;

select
    @id = i.idComanda,
    @date = i.dtData,
    @person = i.stOperador,
	@productId = i.idProduto,
    @details = i.stIncremento,
	@itemNumber = i.nrItem   
from
    inserted i;

select @tableId = (SELECT idMesa FROM [NATI2].[dbo].[mt_Atendimentos] where idComanda = @id);

insert into
    OrdersApp.dbo.itensComandas (
        id,
        date,
        person,
        microterminal,
        details,
        productId,
		itemNumber,
        tableId
    )
values
    (
        @id,
        @date,
        @person,
        NULL,
        @details,
        @productId,
		@itemNumber,
        @tableId
    )
GO