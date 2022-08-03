CREATE TRIGGER trgAfterInsert ON [dbo].[mt_Itens] FOR
INSERT
    AS declare @id int;

declare @date datetime;

declare @quantity float;

declare @person varchar(50);

declare @microterminal varchar(50);

declare @dscrpt varchar(29);

declare @details nvarchar(225);

declare @productId int;

declare @itemNumber int;
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

select @dscrpt = (SELECT stProduto FROM [NATI2].[dbo].[prd_Produtos] where idProduto=@productId)

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
		itemNumber
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
		@itemNumber
    )
GO