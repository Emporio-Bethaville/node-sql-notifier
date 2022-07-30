CREATE TRIGGER trgAfterInsert ON [dbo].[mt_Itens] FOR
INSERT
    AS declare @id int;

declare @date datetime;

declare @quantity float;

declare @person varchar(50);

declare @microterminal varchar(50);

declare @dscrpt varchar(50);

declare @details varchar(50);

select
    @id = i.idComanda
from
    inserted i;

select
    @date = i.dtData
from
    inserted i;

select
    @quantity = i.nrQuantidade
from
    inserted i;

select
    @person = i.stOperador
from
    inserted i;

select
    @microterminal = i.idMicroterminal
from
    inserted i;

select
    @dscrpt = i.descricao
from
    inserted i;

select
    @details = i.stIncremento
from
    inserted i;

insert into
    OrdersApp.dbo.itensComandas (
        id,
        date,
        quantity,
        person,
        microterminal,
        dscrpt,
        details
    )
values
    (
        @id,
        @date,
        @quantity,
        @person,
        @microterminal,
        @dscrpt,
        @details
    )
GO