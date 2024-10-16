/*Listar todos Clientes que não tenham realizado uma compra;*/
/*Tabelas: customers; orders*/
WITH orders_cnt AS (
	SELECT
  		COUNT(order_id),
  		customer_id
  	FROM orders
  	GROUP BY customer_id
)

SELECT
	c.*
FROM customers c
LEFT JOIN orders_cnt o ON c.customer_id = o.customer_id
WHERE o.order_id IS NOT NULL
/*Se não me engano, o LEFT JOIN popularia o que não tem valores correspondentes na outra tabela com NULL*/

/*Listar os Produtos que não tenham sido comprados*/
/*Tabelas: order_items, products*/
WITH orders_cnt AS (
	SELECT
  		COUNT(order_id),
  		product_id
  	FROM order_items
  	GROUP BY product_id
)

SELECT
	p.*
FROM products p
LEFT JOIN orders_cnt o ON p.product_id = o.product_id
WHERE o.order_id IS NOT NULL
/*Se não me engano, o LEFT JOIN popularia o que não tem valores correspondentes na outra tabela com NULL*/

/*Listar os Produtos sem Estoque;*/
/*Tabelas: products, stocks*/
SELECT
	p.*
FROM products p
INNER JOIN stocks s ON p.product_id = s.product_id
WHERE s.quantity = 0

/*Agrupar a quantidade de vendas que uma determinada Marca por Loja.*/
/*Tabelas: products, brands, order_items, orders, stores*/
WITH branded_products AS (
	SELECT
  		p.*,
  		b.brand_name
  	FROM products p
  	INNER JOIN brands b ON p.brand_id = b.brand_id
  	WHERE b.brand_name = 'DETERMINADA MARCA' /*insira aqui a marca desejada*/
),

ordered_items_brands AS (
	SELECT	
  		o.*,
  		bp.brand_name
  	FROM order_items o
  	INNER JOIN branded_products bp ON o.product_id = bp.product_id
),

brand_cnt AS (
	SELECT
  		order_id,
  		brand_name,
  		SUM(quantity)
 	FROM ordered_items_brands
  	GROUP BY order_id, brand_name
),

brand_orders AS (
	SELECT
		o.store_id,
  		bc.brand_name,
    	bc.quantity,
	FROM orders o
	INNER JOIN brand_cnt bc ON o.order_id = bc.order_id
)

SELECT
	store_id,
    brand_name,
    SUM(quantity)
FROM brand_orders
GROUP BY store_id, brand_name

/*Listar os Funcionarios que não estejam relacionados a um Pedido.*/
/*Tabelas: staffs, orders*/
WITH orders_cnt AS (
	SELECT
  		COUNT(order_id),
  		staff_id
  	FROM orders
  	GROUP BY staff_id
)

SELECT
	s.*
FROM staffs s
LEFT JOIN orders_cnt o ON s.staff_id = o.staff_id
WHERE o.order_id IS NULL
/*Se não me engano, o LEFT JOIN popularia o que não tem valores correspondentes na outra tabela com NULL*/
