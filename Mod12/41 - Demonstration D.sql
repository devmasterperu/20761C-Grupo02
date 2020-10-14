--01
--Clientes
select * from tb_Cliente

--Ubigeos
select * from tb_Ubigeo

--Contactos
select * from tb_ContactoCliente

--Productos (X)
select * from tb_Producto

--(Y): TOP 2 clientes contactados por producto
select top 2 concat(c.nombreCliente,' ',c.apellidosCliente) as cliente,c.idUbigeo,u.poblacion
from tb_ContactoCliente cc
left join tb_Cliente c on cc.idCliente=c.idCliente
left join tb_Ubigeo u on c.idUbigeo=u.idUbigeo
where idProducto=3
order by u.poblacion desc

--01.A

select p.nombreProducto as Producto,tc.cliente as Cliente,tc.idUbigeo as Ubigeo,tc.poblacion as Poblacion
from tb_Producto p
cross apply --Si el producto no se encuentra dentro de la contactabilidad, el producto no debe ser mostrado
(
select top 2 concat(c.nombreCliente,' ',c.apellidosCliente) as cliente,c.idUbigeo,u.poblacion
from tb_ContactoCliente cc
left join tb_Cliente c on cc.idCliente=c.idCliente
left join tb_Ubigeo u on c.idUbigeo=u.idUbigeo
where cc.idProducto=p.idProducto
order by u.poblacion desc
) tc 

--01.B

create function dbo.fnTopProducto(@idProducto int) --TVF
returns table
return
	select top 2 concat(c.nombreCliente,' ',c.apellidosCliente) as cliente,c.idUbigeo,u.poblacion
	from tb_ContactoCliente cc
	left join tb_Cliente c on cc.idCliente=c.idCliente
	left join tb_Ubigeo u on c.idUbigeo=u.idUbigeo
	where cc.idProducto=@idProducto
	order by u.poblacion desc

select * from dbo.fnTopProducto(3)

select p.nombreProducto as Producto,tc.cliente as Cliente,tc.idUbigeo as Ubigeo,tc.poblacion as Poblacion
from tb_Producto p
cross apply dbo.fnTopProducto(p.idProducto) tc 

--02.b
select * from dbo.fnTopProducto(7)

select p.idProducto,p.nombreProducto as Producto,tc.cliente as Cliente,tc.idUbigeo as Ubigeo,tc.poblacion as Poblacion
from tb_Producto p
outer apply dbo.fnTopProducto(p.idProducto) tc 
