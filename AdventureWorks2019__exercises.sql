-- TOTAL SALES PER SALESMAN DEVIDED BY YEAR
SELECT sp.BusinessEntityID,
YEAR(soh.OrderDate) sales_year,
CAST(SUM(sod.LineTotal) AS DECIMAL (10, 2)) sales
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
-- WHERE YEAR(soh.OrderDate) = 2011
GROUP BY YEAR(soh.OrderDate), sp.BusinessEntityID
-- ORDER BY sales DESC;
ORDER BY sp.BusinessEntityID, YEAR(soh.OrderDate) ASC;


-- TOTAL SALES BY SALESMAN
SELECT sp.BusinessEntityID,
SUM(sod.LineTotal) sales
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY sp.BusinessEntityID
ORDER BY sp.BusinessEntityID;


-- TOTAL SALES PER SALESMAN DEVIDED BY YEAR AND PRODUCT MODEL
SELECT sp.BusinessEntityID,
YEAR(soh.OrderDate) sales_year,
SUM(sod.LineTotal) sales,
p.ProductModelID
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY sp.BusinessEntityID, YEAR(soh.OrderDate), p.ProductModelID
ORDER BY sp.BusinessEntityID, YEAR(soh.OrderDate) ASC, p.ProductModelID ASC;


-- TOTAL SALES PER SALESMAN DEVIDED BY YEAR, PRODUCT AND PRODUCT MODEL 
SELECT sp.BusinessEntityID,
YEAR(soh.OrderDate) sales_year,
SUM(sod.LineTotal) sales,
p.ProductID,
p.ProductModelID
FROM Sales.SalesPerson sp
JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY YEAR(soh.OrderDate), sp.BusinessEntityID, p.ProductID, p.ProductModelID
ORDER BY sp.BusinessEntityID, YEAR(soh.OrderDate) ASC, p.ProductModelID ASC, p.ProductID;


-- TOTAL SALES
SELECT
SUM(sod.LineTotal) total_sales
FROM Sales.SalesOrderDetail sod;


-- --------------------------------------------------------------------------------------------------------------------------

-- CHECK THE TABLE CONSTRAINTS AND DATATYPE
/*
CREATE TABLE EmployeesRateShiftHistory(
ID INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
Gender varchar(1) NOT NULL CHECK(Gender = 'M' OR Gender = 'F'),
Shift_name varchar(10) NOT NULL,
Max_date date NOT NULL,
Current_rate int NOT NULL CHECK(Current_rate >= 0)
);
*/



-- EMPLOYEE ID, GENDER, SHIFT AND CURRENT RATE
SELECT e.BusinessEntityID,
e.Gender,
s.Name Shift,
MAX(eph.RateChangeDate) max_date,
CAST(eph.Rate AS DECIMAL(10, 2)) current_rate
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID = e.BusinessEntityID 
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
/*
WHERE eph.RateChangeDate IN(
	SELECT MAX(sub.RateChangeDate)
	FROM HumanResources.EmployeePayHistory sub
	GROUP BY sub.BusinessEntityID
)
*/
GROUP BY e.BusinessEntityID, e.Gender, s.Name, eph.Rate, eph.RateChangeDate
ORDER BY e.BusinessEntityID, eph.RateChangeDate DESC;

/*
HAVING eph.RateChangeDate IN(
	SELECT MAX(sub.RateChangeDate)
	FROM HumanResources.EmployeePayHistory sub
	GROUP BY sub.BusinessEntityID
)
*/

-- IT WORKS BETTER THAN THE PREVIOUS ONE
SELECT e.BusinessEntityID,
e.Gender,
s.Name Shift,
eph.RateChangeDate,
CAST(eph.Rate AS DECIMAL(10, 2)) current_rate
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID = e.BusinessEntityID 
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
WHERE eph.RateChangeDate >= ALL(
	SELECT MAX(sub.RateChangeDate)
	FROM HumanResources.EmployeePayHistory sub
	WHERE sub.BusinessEntityID = eph.BusinessEntityID AND sub.RateChangeDate > eph.RateChangeDate
	GROUP BY sub.BusinessEntityID
)
GROUP BY e.BusinessEntityID, e.Gender, s.Name, eph.Rate, eph.RateChangeDate
-- ORDER BY e.BusinessEntityID, eph.RateChangeDate DESC



-- AVERAGE OF THE CURRENT RATE BY GENDER AND NAME
SELECT v.gender,
v.Shift,
CAST(AVG(v.current_rate) AS DECIMAL(10, 2)) avg_current_rate
FROM dbo.EmployeesInfo v
GROUP BY v.gender, v.Shift
ORDER BY v.Gender, v.Shift;


-- WE CAN CALCULATE THE AVERAGE RATE BY DOING THIS LITTLE QUERY ON A VIEW OR 
SELECT gender, 
shift, 
CAST(AVG(current_rate) AS DECIMAL (10,2)) avg_rete
FROM
(
	SELECT e.BusinessEntityID,
	e.Gender,
	s.Name Shift,
	eph.RateChangeDate,
	CAST(eph.Rate AS DECIMAL(10, 2)) current_rate
	FROM HumanResources.Employee e
	JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID = e.BusinessEntityID 
	JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
	JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
	WHERE eph.RateChangeDate >= ALL(
		SELECT MAX(sub.RateChangeDate)
		FROM HumanResources.EmployeePayHistory sub
		WHERE sub.BusinessEntityID = eph.BusinessEntityID AND sub.RateChangeDate > eph.RateChangeDate
		GROUP BY sub.BusinessEntityID
	)
	GROUP BY e.BusinessEntityID, e.Gender, s.Name, eph.Rate, eph.RateChangeDate
	-- ORDER BY e.BusinessEntityID, eph.RateChangeDate DESC
) main
GROUP BY gender, shift
ORDER BY gender;


-- AVERAGE OF CURRENT RATE BY GENDER
SELECT v.gender,
CAST(AVG(v.current_rate) AS DECIMAL(10, 2)) avg_current_rate
FROM dbo.EmployeesInfo v
GROUP BY v.gender;


--AVERAGE OF THE CURRENT VALUE  BY SHIFT
SELECT v.Shift,
CAST(AVG(v.current_rate) AS DECIMAL(10, 2))avg_current_rate
FROM dbo.EmployeesInfo v
GROUP BY v.Shift;


/*
-- DOES NOT WORK AS IT SHOULD
SELECT e.Gender,
CAST(AVG(eph.Rate) AS DECIMAL(5, 2)) current_rate
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON edh.BusinessEntityID = e.BusinessEntityID 
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
WHERE eph.RateChangeDate >= ALL( -- IN()
	SELECT MAX(sub.RateChangeDate)
	FROM HumanResources.EmployeePayHistory sub
	WHERE sub.BusinessEntityID = e.BusinessEntityID
	GROUP BY sub.BusinessEntityID
)
GROUP BY e.Gender;


-- DOES NOT WORK AS IT SHOULD
SELECT s.Name,
CAST(AVG(eph.Rate) AS DECIMAL(10, 2)) avg_rate
FROM HumanResources.Employee e
JOIN HumanResources.EmployeePayHistory eph ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
WHERE eph.RateChangeDate IN (
	SELECT MAX(sub.RateChangeDate)
	FROM HumanResources.EmployeePayHistory sub
	GROUP BY sub.BusinessEntityID
)
GROUP BY s.Name;
*/