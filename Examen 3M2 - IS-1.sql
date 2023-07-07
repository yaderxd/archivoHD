
--   Realizar una vista de datos que muestre un resumen de recaudaciones de datos para las dos empresas.
--   (ServiPlus y Seguros_Sa) Dicho resumen ser� para las ventas del mes anterior vs el mes actual.
--   Estructura:
--Nombre Empresa /  Recaudaci�n / TipoServicio
--   TipoServicio: 
--   Monto X Servicios de Matenimiento
--   Monto X Repuestos
--   Monto X P�lizas
--   Monto X Gastos de Hospitalizaci�n
--   Monto X Consultas

use Serviplus

create view Recaudaciones_Empresas
as
select
  'Serviplus' as [Nombre Empresa],
  (select sum(dm.Precio) from Serviplus.dbo.Detalle_Mantenimiento dm
  inner join Serviplus.dbo.Mantenimiento m on m.IdMantenimiento = dm.IdMantenimiento
  where MONTH(m.FechaIngreso) = MONTH(DATEADD(Month, -1, GETDATE()))) as Recaudacion,
  'Monto X Servicios' as TipoServicio
UNION
select
  'Serviplus' as [Nombre Empresa],
  (select sum(dr.Precio*dr.Cantidad) from Serviplus.dbo.Detalle_Repuesto dr
  inner join Serviplus.dbo.Detalle_Mantenimiento dm on dm.IdDetalleMantenimiento = dr.IdDetalleMantenimiento
  inner join Serviplus.dbo.Mantenimiento m on m.IdMantenimiento = dm.IdMantenimiento
  where MONTH(m.FechaIngreso) = MONTH(DATEADD(Month, -1, GETDATE()))) as Recaudacion,
  'Monto X Repuestos' as TipoServicio
UNION
select
  'Seguros SA' as [Nombre Empresa],
  (select sum(p.Costo) from Seguros_SA.dbo.Poliza p
  where MONTH(p.FechaEmision) = MONTH(DATEADD(Month, -1, GETDATE()))) as Recaudacion,
  'Monto X Polizas' as TipoServicio
UNION
select
  'Seguros SA' as [Nombre Empresa],
  (select sum(dh.Costo) from Seguros_SA.dbo.DetalleHospitalizacion dh
  where MONTH(dh.Fecha) = MONTH(DATEADD(Month, -1, GETDATE()))) as Recaudacion,
  'Monto X Gastos de Hospitalizacion' as TipoServicio
 UNION
select
  'Seguros SA' as [Nombre Empresa],
  (select sum(c.GastoFijo + c.GastoFijo) from Seguros_SA.dbo.Consulta c
  where MONTH(c.Fecha) = MONTH(DATEADD(Month, -1, GETDATE()))) as Recaudacion,
  'Monto X Consultas' as TipoServicio
  

select * from Serviplus.dbo.Recaudaciones_Empresas


 -- 3. 5pts. Cargar un Inicio de Sesi�n SQL para visualizar �nicamente la informaci�n del inciso 2.

 create login Visualizador with password = '123456'

 use Serviplus

 exec sp_adduser Visualizador, Visualizador

 grant select on Recaudaciones_Empresas to Visualizador

 -- 4. 5 pts. Realizar una vista en Power BI y muestre la informaci�n del inciso 2.
 
 --5. 5 pts. En mongoDB cargar el archivo Personas.csv.
 --          Crear la BD Empresa
	--	   use Empresa

	--       Crear la colecci�n Personas

	--	   db.createCollection("Personas")
	--       Cargar el archivo Personas.cvs en la colecci�n.
	--	   Mostrar:
	--	   Cantidad de Personas

	--	   db.Personas.countDocuments()

	--	   Cantidad de Personas que tienen un peso entre 80 y 100

	--	   db.Personas.find({peso : {$gte: 80,$lte: 100}}).count()

	--	   Mostrar los 5 trabajadores con el mayor ingreso.

	--	   db.Personas.find().sort({ingreso: -1}).limit(5)