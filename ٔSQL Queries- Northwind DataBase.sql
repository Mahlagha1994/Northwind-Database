-- Database Project
-- Mahlagha Sadoughi

-- Q1: چند سفارش در مجموع ثبت شده است؟
select count(*) as totalorders from orders;


-- Q2: درآمد حاصل از این سفارش‌ها چقدر بوده است؟
select sum(od.quantity * p.price) as TotalRevenue
from orderdetails as od
join products as p 
on od.productID = p.productID;


-- Q3: ۵ مشتری برتر را براساس مقداری که خرج کرده‌اند پیدا کنید (ID، نام و مقدار خرج شده هر یک را گزارش کنید).
select c.customerId, c.customerName, sum(od.quantity * p.price) as TotalExpense
from customers as c
join orders as o on c.customerId = o.customerId
join orderdetails as od on o.orderId = od.orderId
join products as p on od.productID= p.productID
group by c.customerId, c.customerName
order by TotalExpense desc
limit 5;


-- Q4: میانگین هزینه‌ی سفارشات هر مشتری را به همراه ID و نام او گزارش کنید. (به ترتیب نزولی نشان دهید)
select c.CustomerID,c.CustomerName ,AVG(od.Quantity*p.Price) as MeanExpense 
from orders o 
join orderdetails od on o.OrderID =od.OrderID 
join products p on od.ProductID =p.ProductID 
join customers c on c.CustomerID =o.CustomerID 
group by c.CustomerID ,c.CustomerName 
order by 3 desc;  # 3 means the third column = Meanexpense


-- Q5: مشتریان را براساس مقدار کل هزینه‌ی سفارشات رتبه‌بندی کنید، اما فقط مشتریانی را در نظر بگیرید که بیشتر از 5 سفارش داده‌اند.
select c.customerId, c.customerName, sum(od.quantity * p.price) as TotalExpense, 
dense_rank() over (order by sum(od.quantity * p.price) desc) as Expense_rank
from customers as c
join orders as o on c.customerId = o.customerId
join orderdetails as od on o.orderId = od.orderId
join products as p on od.productID= p.productID
group by c.customerId, c.customerName
having count(c.customerId) > 5
order by Expense_rank; 

-- Q6: کدام محصول در کل سفارشات ثبت شده بیشترین درآمد را ایجاد کرده است؟ (به همراه ID و نام گزارش کنید).
select p.productID, p.productName, sum(od.quantity * p.price) as SumRevenue
from orderdetails as od
join products as p 
on od.productID = p.productID
group by p.productID, p.productName
order by SumRevenue desc
limit 1;

-- Q7: هر دسته (category) چند محصول دارد؟ (به ترتیب نزولی نشان دهید)
select categoryId, count(categoryId) as pro_cnt_each_category
from products
group by categoryId
order by pro_cnt_each_category desc;

-- Q8: محصول پرفروش در هر دسته بر اساس درآمد را تعیین کنید.
with t1 as
(
select p.productId, p.categoryID, p.productName,
sum(od.quantity * p.price) as TotalRevenue,
dense_rank() over (partition by p.categoryId order by sum(od.quantity * p.price) desc) as sale_rank
from products as p
join orderdetails as od on p.productID = od.productID
group by p.productId, p.categoryID, p.productName
)
select ca.categoryID, ca.categoryname, t1.productName, t1.TotalRevenue, t1.sale_rank
from t1
join categories as ca on t1.categoryID = ca.categoryID
where sale_rank=1
group by ca.categoryID, ca.categoryname, t1.productName, t1.TotalRevenue, t1.sale_rank
order by ca.categoryID;


-- Q9: 5  کارمند برتر که بالاترین درآمد را ایجاد کردند به همراه ID و نام + ‘ ‘ + نام خانوادگی گزارش کنید.
select e.employeeID, concat(e.firstname,"  ", e.lastname) as FullName, sum(od.quantity * p.price) as TotalIncome
from employees as e
	join orders as o on e.employeeID = o.employeeID
    join orderdetails as od on o.orderID = od.orderID
    join products as p on od.productID = p.productID
group by e.employeeID, Fullname
order by TotalIncome desc
limit 5;


-- Q10: میانگین درآمد هر کارمند به ازای هر سفارش چقدر بوده است؟ (به ترتیب نزولی نشان دهید)

select e.employeeID, concat(e.firstname,"  ", e.lastname) as FullName, 
avg(od.quantity * p.price) as AveIncome
from employees as e
	join orders as o on e.employeeID = o.employeeID
    join orderdetails as od on o.orderID = od.orderID
    join products as p on od.productID = p.productID
group by e.employeeID, Fullname
order by AveIncome desc;


-- Q11: کدام کشور بیشترین تعداد سفارشات را ثبت کرده ‌است؟ (نام کشور را به همراه تعداد سفارشات گزارش کنید)
select c.customername, c.country, count(o.orderId) as Totalorders
from customers as c
join orders as o on c.customerId = o. customerId
group by c.customername, c.country
order by Totalorders desc
limit 1;


-- Q12: مجموع درآمد از سفارشات هر کشور چقدر بوده؟ (به همراه نام کشور و به ترتیب نزولی نشان دهید)
select c.country, sum(od.quantity * p.price) as Totalrevenue
from customers as c
	join orders as o on c.customerId = o. customerId
	join orderdetails as od on o.orderId = od.orderId
    join products as p on od.productId = p.productId
group by c.country
order by Totalrevenue desc;


-- Q13: میانگین قیمت هر دسته چقدر است؟ (به همراه نام دسته و به ترتیب نزولی گزارش کنید)
select ca.categoryId, ca.categoryName, avg(p.price) as AveragePrice
from categories as ca
join products as p on ca.categoryID = p.categoryId
group by ca.categoryId, ca.categoryName
order by AveragePrice desc;


-- Q14: گران‌ترین دسته بندی کدام است؟ (به همراه نام دسته گزارش کنید)
select ca.categoryName, avg(p.price) as AvgPrice
from categories as ca
join products as p on ca.categoryID = p.categoryId
group by ca.categoryName
order by Avgprice desc
limit 1;


-- Q15: طی سال 1996 هر ماه چند سفارش ثبت شده ‌است؟
select month(orderdate) as Months, Monthname(OrderDate) as Months, count(orderId) as TotalOrder
from orders
where 
Year (orderdate) = '1996'
group by month(orderdate), Monthname(OrderDate);


-- Q16: میانگین فاصله‌ی زمانی بین سفارشات هر مشتری چقدر بوده؟ (به همراه نام مشتری و به صورت نزولی نشان دهید)

with t1 as
(
select o.customerId, c.customername, o.orderdate, 
lag(orderdate) over (partition by customerId order By orderdate) as PreviousOrder,
Datediff(orderdate, lag(orderdate) over (partition by customerId order By orderdate)) as OrderInterval
from orders as o
join customers as c on o.customerId = c.customerId
group by o.customerId, c.customername, o.orderdate
)
select t1.customerId, t1.CustomerName, avg(t1.OrderInterval) as AverageInterval
from t1
where t1.PreviousOrder is not null
group by t1.customerId, t1.CustomerName
order by AverageInterval desc;


-- Q17: در هر فصل جمع سفارشات چقدر بوده ‌است؟ (به صورت نزولی نشان دهید)
select 
case
	when month(orderdate) between 3 and 5 then 'spring'
    when month(orderdate) between 6 and 8 then 'summer'
    when month(orderdate) between 9 and 11 then 'fall'
    else 'winter'
end as Season,
count(orderid) as Totalorders
from orders
group by Season
order by Totalorders desc;


-- Q18: کدام تامین کننده بیشترین تعداد کالا را تامین کرده ‌است؟ (به همراه نام و ID گزارش کنید)
-- Solution 1:
SELECT s.supplierId, s.supplierName, COUNT(p.productId) AS TotalProducts
FROM suppliers as s
JOIN products as p ON s.supplierID = p.supplierID
GROUP BY s.supplierId, s.supplierName
ORDER BY TotalProducts DESC
LIMIT 1;

-- Q19: میانگین قیمت کالای تامین شده توسط هر تامین‌کننده چقدر بوده؟ (به همراه نام و ID و به صورت نزولی گزارش کنید)
SELECT s.supplierId, s.supplierName, p.productId, avg(p.price) AS AveragePrice
FROM suppliers as s
JOIN products as p ON s.supplierID = p.supplierID
GROUP BY s.supplierId, s.supplierName, p.productId
ORDER BY AveragePrice DESC;













