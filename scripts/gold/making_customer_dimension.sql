SELECT                -- joining tables
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid

select cst_id, count(*) from    --checking for duplicates/nulls,if any introduced by join logic
(SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid)t
group by cst_id
having count(*) > 1

select cst_gndr, gen from    --checking for gender columns data quality as two gender columns are there
(SELECT
ci.cst_id,
ci.cst_key,
ci.cst_firstname,
ci.cst_lastname,
ci.cst_marital_status,
ci.cst_gndr,
ci.cst_create_date,
ca.bdate,
ca.gen,
la.cntry
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid)t
where t.cst_gndr != t.gen


select distinct   --checking different pairs of gender combinations seen after the join. 
ci.cst_gndr,
ca.gen
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid
order by 1,2


select distinct   
ci.cst_gndr,
ca.gen,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr -- master data is crm so entries there get precendence over erp system data.
else coalesce(ca.gen,'n/a')
end as new_gen
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid
order by 1,2;


SELECT                -- joining tables
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr 
end as gender,
ca.bdate as birthdate,
ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid

SELECT 
ROW_NUMBER() over (order by cst_id) as customer_key,    --generating surrogate key. can be used to create and link in data model
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr 
end as gender,
ca.bdate as birthdate,
ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid


-- creating a object (since virtual hence a view)

create view gold.dim_customers as
SELECT 
ROW_NUMBER() over (order by cst_id) as customer_key,    
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr 
end as gender,
ca.bdate as birthdate,
ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ci.cst_key = ca.cid
left join silver.erp_loc_a101 la
on ci.cst_key = la.cid


select * from gold.dim_customers
