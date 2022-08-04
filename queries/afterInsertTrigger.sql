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

declare @sector int;

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
select @sector = (SELECT idPrint FROM [NATI2].[dbo].[mt_ProdutosPrint] where idProduto = @productId and idMicroterminal = @microterminal);

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
        sector
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
        @sector
    )
GO