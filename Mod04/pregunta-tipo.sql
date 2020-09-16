select o.empid,c.custid,contactname,max(orderdate) as DateOfOrder,
e.firstname+ ' '+e.lastname as salesperson
from Sales.Customers  c
inner join sales.Orders o on c.custid=o.custid
inner join HR.Employees e on o.empid=e.empid
group by c.custid,contactname,firstname,lastname
having o.empid=4
order by DateOfOrder desc