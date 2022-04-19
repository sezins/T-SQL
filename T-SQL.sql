--2)Firmam�zda iki �al��an i�e ba�lam��t�r. �al��anlar�n bilgileri a�a��daki gibi olup kay�tlar�n�n 
--yap�lmas� gerekmektedir. 

Insert Into Employees(FirstName,LastName,Title,TitleOfCourtesy,BirthDate,HireDate,City,Country)
Values('Brown','James','Sales Representative','Mr.','1970-01-01','1999-01-01','London','UK'),
('Dark','Annie','Sales Manager','Mrs.','1966-01-27','1999-01-01','Seattle','USA')

--3)Annie bir s�re sonra oturdu�u �ehirden ta��n�p New York�a yerle�ti. Annie Dark 
--�al��an�m�z�n bilgilerini g�ncelleyiniz. 

Update Employees
Set City=('New York')
where EmployeeID=13

select * from Employees

--4)�al��anlar�mdan Nancy, bug�n, Alfreds Futterkiste �irketine Chai ve Chang �r�n�nden 
--be�er adet satm��t�r. Bu �r�nlerin Federal Shipping kargo �irketi ile �� g�n sonra 
--g�nderilmesi gerekmektedir. Bu sipari�in kayd�n� olu�turunuz.

Insert Into Orders(CustomerID,EmployeeID,OrderDate,RequiredDate,ShipVia)
Values('ALFKI',1,GETDATE(),DATEADD(day, 3, GETDATE()),3)

Insert Into [Order Details](OrderID,ProductID,UnitPrice,Quantity)
Values(11084,1,14.40,5),(11084,2,15.20,5)

select * from Orders
select * from [Order Details]


--5)Speedy Express veya United Package ile ta��nan, Steven Buchanan adl� �al��an�n rapor verdi�i 
--�al��anlar�n ilgilendi�i ve Amerika'ya g�nderilen sipari�lerimin �r�nlerinden, tedarik s�resinde
--pazarlama m�d�rleriyle ileti�im kurulanlar�n kategorileri nelerdir?

Select p.ProductName,c.CategoryName,s.CompanyName ShipCompany,e.FirstName+' '+e.LastName as EmployeeFullName,o.ShipCountry Country,sp.ContactTitle SupplierTittle
From Employees e    join Orders o
					on e.EmployeeID=o.EmployeeID
					join Shippers s
					on o.ShipVia=s.ShipperID
					join [Order Details] od
					on o.OrderID=od.OrderID
					join Products p
					on p.ProductID=od.ProductID
					join Suppliers sp
					on sp.SupplierID=p.SupplierID
					join Categories c
					on c.CategoryID=p.CategoryID
where s.CompanyName in('Speedy Express','United Package') 
and e.EmployeeID=(select ReportsTo from Employees where FirstName='Steven' and LastName='Buchanan')
and o.ShipCountry='USA'
and sp.ContactTitle='Marketing Manager'

--6)Do�u b�lgesinden sorumlu �al��anlar taraf�ndan onaylanan sipari�lerdeki �irket ad� �F� ile 
--ba�layan kargo �irketi ile ta��nan �r�nleri, sipari�i veren m��teri ad�yla birlikte kategorilerine g�re 
--s�ralayarak raporlay�n�

Select e.EmployeeID,ProductName,c.CompanyName,CategoryName
From Territories t join EmployeeTerritories et
					on et.TerritoryID=t.TerritoryID
					join Employees e
					on e.EmployeeID=et.EmployeeID
					join Orders o
					on o.EmployeeID=o.EmployeeID
					join Shippers s
					on s.ShipperID=o.ShipVia
					join [Order Details] od
					on od.OrderID=o.OrderID
					join Products p
					on p.ProductID=od.ProductID
					join Customers c
					on c.CustomerID=o.CustomerID
					join Categories ct
					on ct.CategoryID=p.CategoryID
where RegionID=1
and s.CompanyName like 'F%'
order by c.CompanyName,ct.CategoryName


--7)Her bir sipari� kaleminde �r�n�n kategorisi, hangi kargo �irketi ile g�nderildi�i, m��teri bilgisi, 
--tedarik�i bilgisi ve hangi �al��an taraf�ndan onayland���n� tek bir kolonda bir c�mle ile ifade ediniz.
--(10248 id�li sipari� Dairy Products kategorisindedir. Federal Shipping isimli kargo firmas�yla Vins et alcools 
--Chevalier isimli m��teriye g�nderilmi�tir. Cooperativa de Quesos 'Las Cabras' �r�n�n tedarik edildi�i 
--firmad�r.)

select Concat(o.OrderID ,' IDli sipari� ',ct.CategoryName,' Kategorisindedir.',s.CompanyName, ' isimli kargo firmas�yla ', c.CompanyName,' isimli m��teriye g�nderilmi�tir.', sp.CompanyName,', ',p.ProductName , ' �r�n�n tedarik edildi�i firmad�r.')
From Orders o join Shippers s
					on s.ShipperID=o.ShipVia
					join [Order Details] od
					on od.OrderID=o.OrderID
					join Products p
					on p.ProductID=od.ProductID
					join Customers c
					on c.CustomerID=o.CustomerID
					join Categories ct
					on ct.CategoryID=p.CategoryID
					join Suppliers sp
					on sp.SupplierID=p.SupplierID

--8)�al��anlar�m ka� b�lgeden sorumludur? Sorumlu oldu�u b�lge say�s� en �ok olan �al��an�m 
--kimdir? (2 sorgu)

select et.EmployeeID,e.FirstName+' '+e.LastName FullName,Count(TerritoryID)TerritoryCount
from EmployeeTerritories et join Employees e
							on et.EmployeeID=e.EmployeeID
Group by et.EmployeeID,e.FirstName+' '+e.LastName

select top 1 et.EmployeeID,e.FirstName+' '+e.LastName FullName,Count(TerritoryID)TerritoryCount
from EmployeeTerritories et join Employees e
							on et.EmployeeID=e.EmployeeID
Group by et.EmployeeID,e.FirstName+' '+e.LastName
order by TerritoryCount desc

--9)01-01-1996 ile 01.01.1997 tarihleri aras�nda en fazla(adet anlam�nda) hangi �r�n sat�lm��t�r
Select top 1 p.ProductName,sum(Quantity)TotalSales
From Orders o join [Order Details] od
				on o.OrderID=od.OrderID
				join Products p
				on p.ProductID=od.ProductID
where OrderDate between '01-01-1996' and '01-01-1997'
Group by p.ProductName
Order by TotalSales desc

--10)En �ok hangi kargo �irketi ile g�nderilen sipari�lerde gecikme olmu�tur? �irketin ad� ve 
--geciken sipari� say�s�n� listeleyiniz.

Select top 1 s.CompanyName,Count(OrderID)DelayOrderCount
From Orders o join Shippers s
				on o.ShipVia=s.ShipperID
Where DATEDIFF(day,ShippedDate,RequiredDate)<0
Group by s.CompanyName
Order by DelayOrderCount desc


--11)Steven adl� personelim hangi tedarik�imin �r�nlerini sat�yor

select s.CompanyName
from Suppliers s
where s.SupplierID in(select p.SupplierID
					From Products p
					where p.ProductID in(select od.ProductID
										from [Order Details] od
										where od.OrderID in(select o.OrderID
															from Orders o
															where o.EmployeeID =(Select e.EmployeeID
																				From Employees e
																				where e.FirstName='Steven'))))


--12) �al��anlar�m�n ad soyad bilgileri ile ilgilendikleri b�lge adlar�n� listeleyini

Select et.TerritoryID,(Select t.TerritoryDescription
					from Territories t
					where t.TerritoryID=et.TerritoryID)TerritoryName,
					(select e.FirstName+' '+e.LastName FullName
					from Employees e
					where et.EmployeeID=e.EmployeeID)EmployeName			
from EmployeeTerritories et
order by TerritoryID

--13)Almanya�ya Federal Shipping ile kargolanm�� sipari�leri onaylayan �al��anlar� ve bu �al��anlar�n 
--hangi b�lgede olduklar�n� listeleyiniz.

select e.FirstName+' '+e.LastName as FullName,e.Region
from Employees e
where e.EmployeeID in(Select o.EmployeeID
					from Orders o
					where o.ShipCountry='Germany' and o.ShipVia=(select s.ShipperID
																from Shippers s
																Where s.CompanyName='Federal Shipping'))

--14)Seafood �r�nlerinden sipari� g�nderilen m��teriler kimlerdir

Select c.CompanyName
from Customers c
where c.CustomerID in(select o.CustomerID
						from Orders o
						where o.OrderID in(select od.OrderID 
											from [Order Details] od
											where od.ProductID in((select p.ProductID
																From Products p
																where p.CategoryID in(Select c.CategoryID
																					from CateGorieS C
																					where c.CategoryName='Seafood')))))


--15)1996 y�l�nda sipari� vermemi� m��teriler hangileridir?

select *
from Customers c
where c.CustomerID not in(select o.CustomerID
						from Orders o
						where year(o.OrderDate)='1996')



--16)6. En �ok hangi kargo �irketi ile g�nderilen sipari�lerde gecikme olmu�tur? �irketin ad� ve geciken 
--sipari� say�s�n� listeleyen view�� olu�turunuz.

Go
Create View vw_OrderDelay as
Select top 1 s.CompanyName,Count(OrderID)DelayOrderCount
From Orders o join Shippers s
				on o.ShipVia=s.ShipperID
Where DATEDIFF(day,ShippedDate,RequiredDate)<0
Group by s.CompanyName
Order by DelayOrderCount desc

select *
from vw_OrderDelay
					
--17)	 T�m personelin satt��� �r�nlerin toplam sat�� adetinin, her bir �al��an�n kendi toplam sat�� adetine 
--oran�n� �al��an ad� soyad�yla birlikte listeleyen view�� olu�turunuz.
Go
Create view vw_SalesRate as
Select e.FirstName+' '+e.LastName as FullName,
(convert(Decimal(7,2),sum(od.Quantity))/convert(Decimal(7,2),  (Select sum(od.Quantity) from [Order Details] od) ))as SalesRate
from Employees e join Orders o
				on e.EmployeeID=o.EmployeeID
				join [Order Details] od
				on od.OrderID=o.OrderID
Group by e.EmployeeID,e.FirstName+' '+e.LastName 

select * from vw_SalesRate

--18)�al��anlar� ve onlar�n y�neticilerini listeleyen view�� olu�turunuz

Go
Create view vw_EmployeeAndManager as
select e.FirstName+' '+e.LastName as Employee,(Select e2.FirstName+' '+e2.LastName 
												from Employees e2 
												where e.ReportsTo=e2.EmployeeID)as Manager 
from Employees e

select * from vw_EmployeeAndManager

--19)Bat� b�lgesinden sorumlu olan �al��anlar�m�n onaylad��� sipari�lerimi view olarak kaydediniz. 
--�r�nlerimin tedarik�ilerini listeleyen bir view olu�turunuz. Bu viewleri kullanarak 
--bat� b�lgesinden sorumlu olan �al��anlar�m�n onaylad��� sipari�lerimin tedarik�i bilgilerini 
--listeleyiniz.
----------------19.1----------------------
Go
Alter view vw_EmployeeWestern as
Select e.FirstName+' '+e.LastName as Employee,o.OrderID,ProductID
From Territories t join EmployeeTerritories et
					on et.TerritoryID=t.TerritoryID
					join Employees e
					on e.EmployeeID=et.EmployeeID
					join Orders o
					on o.EmployeeID=o.EmployeeID
					join [Order Details] od
					on od.OrderID=o.OrderID
where RegionID=2

select * from vw_EmployeeWestern

 -------------------19.2-------------------

Go
alter view vw_ProductAndSuppliers as
select p.ProductID,p.ProductName,S.CompanyName,ProductID
from Products p join Suppliers s
				on p.SupplierID=s.SupplierID

select * from vw_ProductAndSuppliers

-------------------19.3-------------------

select Employee,OrderID,ProductName,CompanyName
from vw_EmployeeWestern ew join vw_ProductAndSuppliers ps
							on ew.ProductID=ps.ProductID
Group by Employee,OrderID,ProductName,CompanyName




--20)Tedarik�i id�sini parametre alan ve o tedarik�inin sa�lad��� 
--�r�nlerin yer ald��� sipari�leri listeleyen stored procedure yap�s�n� olu�turunuz.
Go
Create Procedure sp_SuppliersProducts(@SuppId int) as
select od.OrderID,p.ProductName,s.CompanyName
from Suppliers s join Products p
					on s.SupplierID=p.SupplierID
					join [Order Details] od
					on od.ProductID=p.ProductID
where s.SupplierID=@SuppId

exec sp_SuppliersProducts 4
exec sp_SuppliersProducts 17


--21)Girilen iki tarih aras�ndaki g�nler i�in g�nl�k ciromu veren bir stored procedure olu�turunu
go
Create Procedure sp_DailyCiro(@FirstDate date,@LastDate date) as
select convert(date,o.OrderDate),sum(Quantity*UnitPrice*(1-Discount))Ciro
from Orders o join [Order Details] od
				on o.OrderID=od.OrderID
Group by o.OrderDate
having o.OrderDate between @FirstDate and @LastDate
order by o.OrderDate

exec sp_DailyCiro '1997-07-18','1997-07-23'

--22)Girilen �lke ad�na g�re hangi tedarik�i firmadan ka� adet �r�n al�nd���n� listeleyen stored 
--procedure yap�s�n� olu�turunuz.
Go
Alter Procedure sp_SupplierCountryProducts(@Country varchar(100)) as
select s.CompanyName,sum(od.Quantity)TotalAmount
from Suppliers s join Products p
				on s.SupplierID=p.SupplierID
				join [Order Details] od
				on od.ProductID=p.ProductID
Group by s.CompanyName,s.Country
having s.Country=@Country

exec sp_SupplierCountryProducts 'USA'
exec sp_SupplierCountryProducts 'Japan'

--23) M��terinin en �ok sipari� etti�i 3 �r�n� listeleyen stored procedure yap�s�n� olu�turun. Parametre 
--olarak m��teri numaras�n� al�n�z
Go
Create Procedure sp_CustomerTop3Order(@Customer varchar(100)) as
Select top 3 p.ProductName,sum(Quantity)TotalOrderAmount
from Customers c join Orders o
				on c.CustomerID=o.CustomerID
				join [Order Details] od
				on od.OrderID=o.OrderID
				join Products p
				on p.ProductID=od.ProductID
where c.CompanyName=@Customer
Group by p.ProductName
order by TotalOrderAmount desc

exec sp_CustomerTop3Order 'Ernst Handel'

--24)Parametre olarak ad soyad ve do�um tarihi bilgisini al�p �al��anlara mail adresi 
--olu�turacak fonksiyonu olu�turunuz.

Create Function Email(@Name varchar(40),@Surname varchar(40),@Birthday date)
returns varchar(100)
as
begin
	declare @CreatedMail varchar(100)
	set @CreatedMail=@Name+'.'+@Surname+convert(varchar(20),@Birthday)+'@northwind.com'
	return @CreatedMail 
end

select dbo.Email('enes','sagban','05-11-1995')

--25)Parametre olarak al�nan m��teri numaras�na g�re m��terinin toplam vermi� oldu�u 
--sipari� say�s�n� geri d�nd�ren fonksiyonu yaz�n�z. 

Create Function OrderCounter(@CustID varchar(5))
returns int
as
begin
declare @OrderCount int
select @OrderCount=count(o.OrderID)
from Customers c join Orders o
				on c.CustomerID=o.CustomerID
where c.CustomerID=@CustID
Group by c.CustomerID
return @OrderCount
end

select dbo.OrderCounter('ALFKI')
select dbo.OrderCounter('ANATR')

create function awsd(@id nchar(5))
returns int 
as
begin
declare @sipar�ssay�s� int
select  @sipar�ssay�s�= count(o.OrderID) from orders o where o.CustomerID=@id group by CustomerID 
return @sipar�ssay�s�
end 
select dbo.awsd('ALFKI')

--26)Girdi olarak sipari� numaras� al�p sipari�in hangi m��teriye, hangi kargo �irketiyle, hangi 
--�al��an taraf�ndan g�nderildi�ini ve g�nderilen �r�nlerin ka�ar adet oldu�unu �r�nlerin 
--ad� ile birlikte listeleyen fonksiyonu yaz�n�z.

Create Function OrderProductQuantity(@OrderID int)
returns table
as
return
select c.CompanyName as CustomerCompany,s.CompanyName as ShipperCompany,e.FirstName+' '+e.LastName as Employee,p.ProductName,od.Quantity
From Orders o join Shippers s
					on s.ShipperID=o.ShipVia
					join [Order Details] od
					on od.OrderID=o.OrderID
					join Products p
					on p.ProductID=od.ProductID
					join Customers c
					on c.CustomerID=o.CustomerID
					join Categories ct
					on ct.CategoryID=p.CategoryID
					join Suppliers sp
					on sp.SupplierID=p.SupplierID
					join Employees e
					on e.EmployeeID=O.EmployeeID
where o.OrderID=@OrderID

Select * from OrderProductQuantity(10248)

--27)0 ile 100 aras�ndaki asal say�lar� print eden sql sorgusunu yaz�n�z.

Declare @AsalKontrol int=2
Declare @Bolen int=1
Declare @counter int=0
while (@AsalKontrol < 100)
begin 
		while(@Bolen<=@AsalKontrol)
		begin
			if(@AsalKontrol % @Bolen=0)
			begin
				set @counter+=1
			end
			set @Bolen+=1
		end
		if(@counter<=2)
		begin
			print (@AsalKontrol)
		end
		set @Bolen =1
		set @counter =0
		set @AsalKontrol+=1
end

