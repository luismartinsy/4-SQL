
-- Ejercicio 2

select f.title, f.rating  
from film f 
where f.rating = 'R'
order by 1 asc;


-- Ejercicio 3

select a.actor_id, concat(a.first_name , ' ' ,a.last_name ), a.last_name 
from actor as a 
where a.actor_id between 30 and 40
order by a.last_name;

-- Ejercicio 4

	-- La tabla film no tiene informacion en la columna "original_language_id". Es decir, no hay informacion como para comparar.

select f.language_id , f.original_language_id 
from film f
group by f.language_id , f.original_language_id;

select count(f.original_language_id )
from film f;

select *
from film f;


-- Ejercicio 5

select f.film_id , f.title, f.length 
from film f
order by f.length asc;

-- Ejercicio 6

select a.first_name , a.last_name 
from actor as a 
where a.last_name = 'ALLEN'
order by 1;

-- Ejercicio 7

select f.category_id as categoria, c.name, count(f.film_id) as total_films
from film_category  as f 
left join category as c
on f.category_id = c.category_id 
group by f.category_id, c."name";

-- Ejercicio 8

select  f.title, f.rating, f.length as duracion_minutos
from film as f
where f.rating = 'PG-13' or f.length >= (60 * 3)
order by 2 desc;

-- Ejercicio 9.A

select round(AVG(f.replacement_cost), 2) as variabilidad_promedio
from film as f;

-- Ejercicio 9.B, para clasificar por categoria

select f.category_id as categoria, c.name, count(f.film_id) as total_films, round(AVG(film.replacement_cost), 2) as variabilidad_promedio
from film_category  as f 
left join category as c
on f.category_id = c.category_id 
left join film as film
on f.film_id = film.film_id 
group by f.category_id, c."name"
order by 4 asc;

-- Ejercicio 10

(select f.title, f.length, 'mayor_duracion' 
from film as f
order by f.length desc
limit 1)

union all

(select film.title, film.length, 'menor_duracion' 
from film as film
order by film.length asc
limit 1);

-- Ejercicio 11

-- Muchos alquileres con la misma fecha/hora
select r.rental_id, to_char(r.rental_date, 'DD-MM-YY') as dia_mes, r.last_update,  sum(p.amount) as total_amount
from rental as r
left join payment as p
on r.customer_id = p.rental_id
group by r.rental_id, r.rental_date, r.last_update
order by to_char(r.rental_date, 'DD-MM') desc;


-- Ejercicio 12

select f.title, f.rating 
from film as f
where f.rating not in ('NC-17','G')
order by f.rating, f.title;


-- Ejercicio 13

select f.rating, count(f.title) as total_pelis, round(avg(f.length),0) as duracion_minutos
from film as f
group by f.rating
order by 3;

-- Ejercicio 14

select f.title, f.rating, round(avg(f.length),0) as duracion_minutos
from film as f
where f.length >=180
group by f.title, f.rating
order by round(avg(f.length),0);

-- Ejercicio 15

select round(sum(p.amount),0) as payment
from payment p;


-- Ejercicio 16

select c.first_name, c.last_name, c.customer_id 
from customer c
order by c.customer_id desc
limit 10;

-- Ejercicio 17



select F.film_id, f.title, fa.actor_id, a.first_name, a.last_name 
from film as f
inner join film_actor as fa
on f.film_id = fa.film_id
inner join actor as a
on fa.actor_id = a.actor_id 
where f.title = 'EGG IGBY'

-- Ejercicio 18
-- "Selecciona todos los nombres de las películas únicos" <-- No entiendo el enunciado
select count (distinct f.title), count (f.title)
from film as f;

-- Ejercicio 19

select f.film_id, f.title, f.length, fc.category_id, c.name 
from film as f
inner join film_category as fc 
on f.film_id = fc.film_id
inner join category as c
on fc.category_id = c.category_id
where c.name = 'Comedy'
and f.length >= 180
order by f.title;

-- Ejercicio 20

select *
from 
	(select fc.category_id, c.name, round(avg(f.length),0) as duracion_promedio
	from film as f
	inner join film_category as fc 
	on f.film_id = fc.film_id
	inner join category as c
	on fc.category_id = c.category_id
	group by fc.category_id, c.name) as promedio_duracion
where promedio_duracion.duracion_promedio >= 110
order by 3;

-- Ejercicio 21

select avg(((r.return_date) - (r.rental_date))) as total_dias_renta
from rental r;

-- Ejercicio 22

select concat(a.first_name, ' ', a.last_name) as actor_name
from actor as a ;

-- Ejercicio 23

select to_char(r.rental_date, 'DD-MM-YYYY') as day_rent, count(r.rental_id) as total_rents
from rental as r
group by to_char(r.rental_date, 'DD-MM-YYYY')
order by 2 desc;

-- Ejercicio 24

create temporary table promedio_global as
select round(avg(promedio_global.length),0)
from film as promedio_global;

select * 
from promedio_global;

select peli.film_id, peli.title, peli.length
from film as peli, promedio_global
where peli.length > promedio_global.round
group by peli.film_id, peli.title;


-- Ejercicio 25

select to_char(r.rental_date, 'MM-YYYY') as month_rent, count(r.rental_id) as cant_rents
from rental r
group by to_char(r.rental_date, 'MM-YYYY')
order by 1;


-- Ejercicio 26

select round(avg(p.amount),2) as promedio, round(stddev(p.amount),2) as dev_stnd, round(var_samp(p.amount),2) as varianza
from payment p;


-- Ejercicio 27
-- un rental = una peli

create temporary table promedio_amount_global as
select round(avg(p.amount),2) as promedio_amount_global
from payment p;

select *
from (
	select f.film_id, f.title, round(avg(p.amount ),2) as precio_promedio
	from film as f
	left join inventory as inv
	on f.film_id = inv.film_id
	left join rental r 
	on inv.inventory_id = r.inventory_id 
	left join payment p 
	on r.rental_id = p.rental_id 
	group by f.film_id, f.title
	order by 1) as detalle_film,
	
	promedio_amount_global
	
where detalle_film.precio_promedio > promedio_amount_global.promedio_amount_global
order by 3;


-- Ejercicio 28

select * 
from (
		select fa.actor_id, count(fa.film_id) as tot_pelis
		from film_actor as fa 
		group by fa.actor_id) as actor_count
where actor_count.tot_pelis > 40;

-- Ejercicio 29

select f.film_id, f.title, tot_inventario.tot_inventario 
from film as f
left join (
	select i.film_id, count(i.film_id) as tot_inventario
	from inventory as i
	group by i.film_id) as tot_inventario
on f.film_id = tot_inventario.film_id;


-- Ejercicio 30

select fa.actor_id, concat(a.first_name, ' ' , a.last_name) as actor_name, count(fa.actor_id) as total_pelis
from film_actor as fa
left join actor as a
on fa.actor_id = a.actor_id
group by fa.actor_id, concat(a.first_name, ' ' , a.last_name)
order by 1;


-- Ejercicio 31

select fa.film_id, fa.actor_id 
from film_actor as fa
order by 1;

select f.film_id, f.title, fa.actor_id, concat(a.first_name, ' ', a.last_name) as actor_name
from film f
left join film_actor fa 
on f.film_id = fa.film_id
left join actor a 
on fa.actor_id =a.actor_id 
order by 1;


-- Ejercicio 32

select a.actor_id , concat(a.first_name, ' ', a.last_name) as actor_name, f.title 
from actor a
left join film_actor fa 
on a.actor_id = fa.actor_id
left join film f
on fa.film_id = f.film_id 


-- Ejercicio 33

select r.rental_id, inventario.film_id, inventario.title 
from rental as r
FULL join (
	select f.film_id, f.title, i.inventory_id
	from film as f
	left join inventory as i
	on f.film_id = i.film_id) as inventario
on r.inventory_id = inventario.inventory_id 
order by 1;


-- Ejercicio 34

select p.customer_id, concat(c.first_name, ' ', c.last_name) as nombre_cliente,sum(p.amount) as total
from payment as p
inner join rental as r
on p.rental_id = r.rental_id 
inner join customer as c
on r.customer_id = c.customer_id
group by p.customer_id, concat(c.first_name, ' ', c.last_name)
order by 3 desc
limit 5;


-- Ejercicio 35

select *
from actor as a
where a.first_name = 'JOHNNY';


-- Ejercicio 36

select a.actor_id, a.first_name as Nombre, a.last_name as Apellido
from actor as a;


-- Ejercicio 37

(select a.actor_id, a.first_name, a.last_name 
from actor as a 
order by a asc
limit 1)

union all

(select a.actor_id, a.first_name, a.last_name 
from actor as a 
order by a desc
limit 1);


-- Ejercicio 38

select count(a.actor_id) as total_actores
from actor as a; 


-- Ejercicio 39

select *
from actor as a
order by 3 asc;


-- Ejercicio 40

select *
from film as f
limit 5;

-- Ejercicio 41
-- Respuesta: Kenneth, Penelope y Julia
select a.first_name, count(a.first_name) as cantidad
from actor as a 
group by a.first_name
order by 2 desc;


-- Ejercicio 42

select r.rental_id, concat(c.first_name, ' ', c.last_name) as nombre_cliente
from rental as r 
left join customer as c
on r.customer_id = c.customer_id
order by 2;


-- Ejercicio 43

select r.rental_id, concat(c.first_name, ' ', c.last_name) as nombre_cliente
from customer as c 
left join rental as r
on r.customer_id = c.customer_id
order by 2;


-- Ejercicio 44
/* Esta consulta no aporta valor ya que, por un lado, no te dice la clasificación real de la película y, por otra, la 
 información que sí puedes determinar (la cantidad de posibilidades de combinación),
es un dato irrelevante */
select f.title, c.name
from film f 
cross join category c;


-- Ejercicio 45

select a.actor_id, a.first_name, a.last_name 
from actor as a 
left join film_actor as fa
on a.actor_id = fa.actor_id 
left join film as f 
on fa.film_id = f.film_id
left join film_category as fc 
on f.film_id = fc.film_id 
left join category as c
on fc.category_id = c.category_id 
where c."name" = 'Action'
group by a.actor_id, a.first_name, a.last_name 
order by 1;


-- Ejercicio 46
-- Todos los actores han participado por los menos en 1 película

select *
from actor as a
where a.actor_id not in (
	select fa.actor_id 
	from film_actor fa);


-- Ejercicio 47

select concat(a.first_name , ' ', a.last_name ) as nombre_actor, total_peliculas.total_pelis 
from actor as a
left join (
	select fa.actor_id, count(fa.actor_id) as total_pelis
	from film_actor as fa
	group by fa.actor_id
	) as total_peliculas
on a.actor_id = total_peliculas.actor_id
order by 2;



-- Ejercicio 48


create view actor_num_peliculas as

select concat(a.first_name , ' ', a.last_name ) as nombre_actor, total_peliculas.total_pelis 
from actor as a
left join (
	select fa.actor_id, count(fa.actor_id) as total_pelis
	from film_actor as fa
	group by fa.actor_id
	) as total_peliculas
on a.actor_id = total_peliculas.actor_id
order by 2;

select *
from actor_num_peliculas;


-- Ejercicio 49


select c.first_name, c.last_name, count(r.rental_id) as total_alquileres 
from rental as r
left join customer as c
on r.customer_id = c.customer_id 
group by c.first_name, c.last_name
order by 3 desc;


-- Ejercicio 50

/* 50. Calcula la duración total de las películas en la categoría 'Action'
 No entiendo la pregunta. El enunciado me dice que sume las duraciones de todas las películos de acción?? no me hacen sentido 
 
 Por si acaso haré la suma pero también calcularé el promedio*/

create temporary table duracion_y_promedio as

select f.film_id, f.title, f.length, c.category_id, c."name" 
from film as f
left join film_category as fc
on f.film_id = fc.film_id 
left join category as c
on fc.category_id = c.category_id 
where c."name" = 'Action';

select round(sum(dp.length),2) as total_duracion, round(avg(dp.length),0) as promedio_duracion
from duracion_y_promedio as dp;


-- Ejercicio 51

create temporary table cliente_rentas_temporal as

select c.first_name, c.last_name, count(r.rental_id) as total_alquileres 
from rental as r
left join customer as c
on r.customer_id = c.customer_id 
group by c.first_name, c.last_name
order by 3 desc;


select *
from cliente_rentas_temporal;


-- Ejercicio 52

create temporary table peliculas_alquiladas as

select f.film_id, f.title, total_alquileres.total_alquileres
from film as f 
left join (

	select f.film_id, f.title, count(r.inventory_id) as total_alquileres
	from film as f
	left join inventory as i
	on f.film_id = i.film_id 
	left join rental as r
	on i.inventory_id = r.inventory_id
	group by f.film_id, f.title
	order by 3 desc
	
	) as total_alquileres
on f.film_id = total_alquileres.film_id 
where total_alquileres.total_alquileres >= 10;

select *
from peliculas_alquiladas;


-- Ejercicio 53

/* Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película. */

-- No entiendo dónde está la información para determinar si alguna película no se ha devuelto

select c.first_name, c.last_name, c.active 
from customer as c
where c.first_name = 'TAMMY' and c.last_name = 'SANDERS';


select c.active, count(c.customer_id) 
from customer as c
group by c.active; 

select *
from rental as r;


-- Ejercicio 54

select a.first_name, a.last_name 
from actor as a 
left join film_actor as fa
on a.actor_id = fa.actor_id 
left join film as f
on fa.film_id = f.film_id 
left join film_category as fc
on f.film_id = fc.film_id
left join category as c
on fc.category_id = c.category_id 
where c."name" = 'Sci-Fi'


-- Ejercicio 55


create temporary table date_spartacus as

select r.inventory_id, r.rental_date 
from rental r 
inner join (
	select f.film_id, f.title, i.inventory_id  
	from film as f 
	left join inventory as i
	on f.film_id = i.film_id 
	where f.title = 'SPARTACUS CHEAPER'
	) as film_spartacus
on r.inventory_id = film_spartacus.inventory_id
order by r.rental_date asc
limit 1;


select *
from date_spartacus d;


select a.first_name , a.last_name 
from actor as a
	left join film_actor as fa
	on a.actor_id = fa.actor_id 
		left join film as f
		on fa.film_id =f.film_id 
			left join inventory as i
			on f.film_id = i.film_id 
				left join rental as r
				on i.inventory_id  = r.inventory_id 
					inner join date_spartacus
					on r.rental_date > date_spartacus.rental_date
group by a.first_name , a.last_name
order by a.last_name asc;


-- Ejercicio 56

select a.first_name, a.last_name 
from actor as a
left join film_actor as fa
on a.actor_id = fa.actor_id 
inner join (
	select f.film_id, f.title, c."name" 
	from film as f
	left join film_category as fc
	on f.film_id = fc.film_id 
	left join category as c
	on fc.category_id = c.category_id 
	where c."name" <> 'Music'
	) as menos_music
	on fa.film_id = menos_music.film_id
group by a.first_name, a.last_name
order by 2 asc;


-- Ejercicio 57

create temporary table diferencia as

select r.rental_id, (r.return_date - r.rental_date) as total_dias
from rental as r
order by 2 asc;

select * from diferencia as d;


select r.rental_id, f.title, d.total_dias
from film as f
left join inventory as i
on f.film_id = i.film_id 
left join rental as r
on i.inventory_id = r.inventory_id
left join diferencia as d
on r.rental_id = d.rental_id
where d.total_dias > interval '8 days';


-- Ejercicio 58

select f.title, c."name" 
from film as f
left join film_category as fc
on f.film_id = fc.film_id 
left join category as c
on fc.category_id = c.category_id 
where c.name='Animation'
order by 1 asc;


-- Ejercicio 59


select f.title, f.length 
from film as f
inner join (
	select *
	from film as f
	where f.title = 'DANCING FEVER'
	) as peli_ref
on f.length = peli_ref.length
order by 1 asc;


-- Ejercicio 60

-- Ningún cliente ha alquilado una peli más de una vez


select c.first_name, c.last_name, rent_unico.alquiler_unico 
from customer as c
left join (
	select r.customer_id,  count(distinct r.inventory_id) as alquiler_unico  
	from rental as r
	group by r.customer_id 
	) as rent_unico
on c.customer_id = rent_unico.customer_id 
where rent_unico.alquiler_unico >= 7
order by 2 asc;


-- Ejercicio 61

select c."name", count(r.rental_id) as tot_renta
from rental as r
left join inventory as i
on r.inventory_id = i.inventory_id 
left join film as f
on i.film_id = f.film_id 
left join film_category as fc
on f.film_id = fc.film_id
left join category as c
on fc.category_id = c.category_id 
group by c."name" 
order by count(r.rental_id) desc;


-- Ejercicio 62

select c."name", count(f.title) as total_2006
from film f
left join film_category as fc
on f.film_id = fc.film_id
left join category as c
on fc.category_id = c.category_id 
where f.release_year = 2006
group by c."name" 
order by count(f.title) desc;



-- Ejercicio 63


select s.staff_id, st.store_id 
from staff as s
cross join store as st
order by 1;


-- Ejercicio 64


select c.customer_id, c.first_name, c.last_name, count(r.rental_id) as total_rent
from customer as c 
left join rental as r
on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name
order by 1 asc;










