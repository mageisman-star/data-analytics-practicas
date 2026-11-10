USE TechStore_Clase5;

--Consulta 1 — Vista base del proyecto (INNER JOIN)

-- Propósito: Obtener una vista consolidada de las ventas combinando información de clientes, productos y categorías

SELECT v.id_venta,
       v.fecha_venta,
       c.nombre            AS cliente,
       c.ciudad,
       p.nombre_producto   AS producto,
       cat.nombre_categoria AS categoria,
       v.cantidad,
       v.precio_unitario,
       v.cantidad * v.precio_unitario AS total
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.id_venta;

-- Hallazgos: Se registran 26 ventas con cliente identificado donde la categoria Computación concentra la mayor facturación.

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)

--Proposito: Identificar los clientes registrados que aún no han realizado ninguna compra para posibles acciones comerciales.

SELECT c.nombre, c.email, c.fecha_registro
FROM clientes c
left JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--Hallazgo: Se identificó 1 cliente sin compras registradas (Ana Duarte). CRM debería pensar estrategias para que Ana Duarte se convierta en cliente activo.

--Consulta 3 — Productos sin ventas (LEFT JOIN)
 
--Proposito : Identificar productos sin venta registrada y tomar acciones respecto a ofertas / precios / stock disponibles entre otras.

SELECT p.nombre_producto, p.precio, cat.nombre_categoria
FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;

-- Hallazgo: Se identificó 1 producto sin ventas registradas (Disco SSD 1TB). El área de producto debería analizar su precio, promoción o necesidad de mantenerlo en catálogo.

-- Consulta 4 — Consolidado por canal (UNION ALL)

--Proposito: identificar las ventas por los diferentes canales con cliente identificado y cliente sin identificar.

WITH por_canal AS (
  SELECT   
        fecha_venta, 
        cantidad * precio_unitario AS total,
        'Cliente identificado' AS canal
  FROM ventas WHERE id_cliente IS NOT NULL
  UNION ALL
  SELECT fecha_venta, cantidad * precio_unitario,
         'Cliente sin identificar'
  FROM ventas WHERE id_cliente IS NULL
)
SELECT 
    canal, 
    COUNT(*) AS ventas, 
    SUM(total) AS facturado
FROM por_canal
GROUP BY canal;

--Hallazgo: Tenemos 26 ventas de clientes identificados y 2 de clientes que no identificamos. Podríamos definir estrategias para evitar clientes sin identificar y / o hacer foco en los identificados para estimular nuevas ventas.


