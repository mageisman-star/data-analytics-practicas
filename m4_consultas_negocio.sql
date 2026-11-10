use Ventas_Tech_DB

SELECT * FROM VENTAS;

-- Consulta 1 — Resumen ejecutivo --
SELECT  YEAR(fecha_venta) as año,
        MONTH(fecha_venta) as mes,
        SUM(cantidad * precio_unitario) AS total_facturado,
        COUNT(id_venta) AS cantidad_pedidos,
        CAST(AVG(cantidad * precio_unitario) AS DECIMAL(10,2)) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY año, mes;

-- Consulta 2 — Ranking de productos  --
SELECT  TOP 5 id_producto,
        SUM(cantidad) AS unidades_vendidas,
        SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3 — Clientes recurrentes -- 
SELECT id_cliente,
        COUNT(id_venta) AS cantidad_pedidos,
        SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1 
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- Consulta 4 — Productos por encima/por debajo del promedio COMO EN CLASE -- 
WITH ventas_mensuales AS (
  SELECT YEAR(fecha_venta) AS año, MONTH(fecha_venta) AS mes,
         SUM(cantidad * precio_unitario) AS facturacion
  FROM ventas
  GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
SELECT año, mes, facturacion,
  CASE WHEN facturacion >= (SELECT AVG(facturacion) FROM ventas_mensuales)
       THEN 'Por encima' ELSE 'Por debajo'
  END AS evaluacion_promedio
FROM ventas_mensuales
ORDER BY año, mes;

-- Consulta 4 — Productos por encima/por debajo del promedio pero tomando facturación por producto -- 
WITH facturacion_por_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado >= (
            SELECT AVG(total_facturado)
            FROM facturacion_por_producto
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS evaluacion_promedio
FROM facturacion_por_producto
ORDER BY total_facturado DESC;

/*
- Durante marzo de 2024 se facturaron 10 pedidos con un ticket promedio de 644.40, lo que genera una facturación total de 6444
- El producto que genera una mayor facturación es id_producto 3 con un total de 3600. No obstante no es el producto con más unidades vendidas que se trata de id_producto 2 con 13 unidades.
- 5 clientes realizaron 2 pedidos cada uno pero el que más compró es id_cliente 1 con un total gastado de 2640

Para el punto 4 lo interpreté de 2 maneras:
1) Como lo vimos en clase por la facturación mensual.
Siendo que la tabla ventas solo muestra información de un mes y que para el CASE usamos >= para definir "Por Encima", obtenemos que en marzo 2024 la facturación fue superior al promedio de los meses.
2) Pensandolo como facturación por producto.
Si lo pensamos como producto, encontramos que la facturación de los productos 1 y 3 superó el promedio de la facturación por producto.

*/

