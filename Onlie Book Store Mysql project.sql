# Creating Online bookstore database
Create database online_Bookstore;

use online_bookstore;

select * from books;
select * from customers;
select * from orders;

# converting ids into primary key 
alter table orders modify column order_ID int not null;
alter table orders add primary key(order_ID);

alter table books modify column Book_id int not null;
alter table books add primary key(Book_id);

alter table customers modify column customer_id int not null;
alter table customers add primary key(customer_id);

-- 1) Retrive all books of "Fiction" Genre
select * from books 
Where genre="Fiction";

-- 2) Find books published after year 1950
Select * from books 
where published_year>1950;

-- 3) List all the customers from Canada 
Select * from Customers
Where country= "Canada";

-- 4) Show orders placed in 2023  
select * from orders
Where order_date between "2023-11-01" and "2023-11-31";

-- 5) Retrive the total stock of the books available
select sum(stock) as "total books" from books;

-- 6) Find the details of the most expensive book
select * from books 
where price=(select max(price) from books);

-- OR

select * from books
order by price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
select * from orders 
where quantity>1;

-- 8) Retrive all orders where the total amount exceeds $20
select * from orders
where Total_amount>20;

-- 9) List all the genars available in the book table
select distinct genre from books;

-- 10) Find the book with the lowest stock

select * from books 
order by stock 
limit 1;

-- 11) Calculate the total revenue generated from all oreders
select sum(total_amount) as "Total Revenue" from orders;

-- Advanced Query 
-- 1) Retrive the total number of books sold for each genre
select genre, sum(quantity) from books 
join orders on books.book_id=orders.book_id
group by genre; -- for each genre

-- 2) Find the average price of books in the "Fantasy" Genre
select genre, avg(price) as 
"Average Price" from books
where genre="Fantasy";

-- 3) List Customers who have placed at least 2 orders
select customers.customer_id, customers.name, count(order_id) from orders
join customers on customers.customer_id=orders.customer_id
group by customer_id
having count(order_id)>=2;


-- 4) Find the most frequently ordered book
select books.title, books. book_id, count(order_id) from orders
join books on orders.book_id=books.book_id
group by orders.book_id, books.title
order by count(order_id) desc
limit 1;

-- 5) show the top 3 most expensive books of the "Fantasy" Genre
select * from books 
where genre="Fantasy"
order by price desc
limit 3;

-- 6) Retrive the total quantity of books sold by each author
select books.author, sum(quantity) as "Books sold by each author" 
from orders
join books on orders.book_id=books.book_id
group by books.author;

-- 7) List the cities where customers who spent over $30 are located
select distinct city, orders.total_amount from customers 
join orders on customers.customer_id=orders.customer_id
where orders.total_amount>30;

-- 8) Find the customer who spent the most on orders
select customers.name, sum(total_amount) from orders
join customers on customers.customer_id=orders.customer_id
group by customers.name
order by sum(total_amount) desc 
limit 1;

-- 9) calcualte the stock remaining after fulfilling all orders


select books.book_id, books.title, books.stock, 
coalesce(sum(orders.quantity),0) as order_quantity, 
books.stock - coalesce(sum(orders.quantity),0)  from books
join orders on books.book_id=orders.book_id
group by books.book_id;













