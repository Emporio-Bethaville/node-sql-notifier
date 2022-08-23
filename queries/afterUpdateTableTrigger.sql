--CREATE TRIGGER trgAfterUpdateTable ON [dbo].[mt_Atendimentos] FOR UPDATE AS
ALTER TRIGGER [dbo].[trgAfterUpdateTable] on [mt_Atendimentos] FOR UPDATE AS

declare @id int;
declare @tableId int;

select
    @id = i.idComanda,
    @tableId = i.idMesa
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
		itemNumber,
        tableId
    )
values
    (
        @id,
        NULL,
        NULL,
        NULL,
        'Update Table ID',
        NULL,
		NULL,
        @tableId
    )

GO