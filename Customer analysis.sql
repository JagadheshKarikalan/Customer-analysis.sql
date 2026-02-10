select * from payment
select * from customer
select * from address

----- Section A: Customer–Location–Revenue Basics -----

select customer.customer_id, customer.first_name, customer.last_name, address.address, address.district, sum(payment.amount) as total_amount from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.address, address.district

select customer.customer_id, customer.first_name, customer.last_name, address.address, address.district, sum(payment.amount) as total_amount from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.address, address.district
order by total_amount desc
limit 10;


select customer.customer_id, customer.first_name, customer.last_name, address.district, round(avg(payment.amount),2) as average_amount
from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.district


select customer.customer_id, customer.first_name, customer.last_name, address.district, count(payment.payment_id) as count_of_payment
from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.district
having count(payment.payment_id) > 30

select customer.customer_id, customer.first_name, customer.last_name, address.address, address.district,sum(payment.amount) as total_payment
from customer customer
join payment payment
on customer.customer_id = payment.customer_id
join address address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.address, address.district
having sum(payment.amount) > (select avg(customer_total)
from (select sum(amount) as customer_total from payment
group by customer_id) t)
order by total_payment desc;

----- Section B: Geographic Performance Analysis -----


select address.district, sum(payment.amount) as total_payment from customer 
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.district

select address.district, count(distinct(customer.customer_id)), sum(payment.amount) from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.district


select address.district, sum(payment.amount) as total_amount_per_district from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.district
order by total_amount_per_district desc
limit 5


select address.district, round(avg(payment.amount),2) as average_per_district
from customer 
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.district

select address.district, round(avg(payment.amount),2) as average_per_district from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.district
having avg(payment.amount) > (select round(avg(amount),2) as average_amount from payment)


----- Section C: Address-Level Insights -----


select address.address, sum(payment.amount) as total_by_address from customer 
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.address


select address.address, count(distinct customer.customer_id) as customer_count, sum(payment.amount) as total_revenue
from customer
inner join address
on customer.address_id = address.address_id
inner join payment
on customer.customer_id = payment.customer_id
group by address.address
having count(distinct customer.customer_id) > 1


select address.address, count(payment.payment_id) as number_of_payments from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.address
order by number_of_payments desc
limit 10

select address.address, round(avg(payment.amount),2) as average_payment_address from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.address


select address.address, address.district, sum(payment.amount) as total_payment
from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.address, address.district
having sum(payment.amount) > 
(select avg(district_totals.addr_total)
from (select sum(payment.amount) as addr_total from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
where address.district = address.district
group by address.address) as district_totals)
order by total_payment desc;

----- Section D: Time-Based Payment Analysis -----


select payment.payment_date, address.district, sum(payment.amount) as total payment from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by payment.payment_date, address.district

select customer.customer_id, customer.first_name, customer.last_name, address.address, count(distinct date(payment.payment_date))
from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.address
having count(distinct date(payment.payment_date)) > 5

select address.district, extract(year from payment.payment_date) as payment_year, sum(payment.amount) from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.district, extract(year from payment.payment_date)
having extract(year from payment.payment_date) = 2007


select customer.customer_id, customer.first_name, customer.last_name, address.district,
min(payment.payment_date) as first_payment,
max(payment.payment_date) as last_payment
from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by customer.customer_id, customer.first_name, customer.last_name, address.district


select address.address, count(distinct extract(month from payment.payment_date))
from customer
inner join payment
on customer.customer_id = payment.customer_id
inner join address
on customer.address_id = address.address_id
group by address.address
having count(distinct extract(month from payment.payment_date)) > 6

