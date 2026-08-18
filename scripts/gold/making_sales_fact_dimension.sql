select 
sd.sls_ord_num,
sd.sls_prd_key,
sd.sls_cust_id,
sd.sls_order_dt,
sd.sls_ship_dt,
sd.sls_due_dt,
sd.sls_sales,
sd.sls_quantity,
sd.sls_price
from silver.crm_sales_details sd                         --- we can see transactions hence it acts as a fact table

-- instead of sls_prd_key AND sls_cust_id, we can use surrogate keys generated for dimensions before

select 
sd.sls_ord_num as order_number,
--sd.sls_prd_key,
--sd.sls_cust_id,
pr.product_key,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd    
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu 
on sd.sls_cust_id = cu.customer_id


-- sort the columns into logical groups to improve readability
-- example [Dimension keys][Dates][Measures]

create view gold.fact_sales as
select 
sd.sls_ord_num as order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
from silver.crm_sales_details sd    
left join gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join gold.dim_customers cu 
on sd.sls_cust_id = cu.customer_id

select * from gold.fact_sales
