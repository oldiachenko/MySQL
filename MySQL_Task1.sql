# 1. Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT *
FROM client
WHERE LENGTH(FirstName) < 6;

# 2. Вибрати львівські відділення банку.
SELECT *
FROM department
WHERE DepartmentCity = 'Lviv';

# 3. Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT *
FROM client
WHERE Education = 'high'
ORDER BY LastName;

# 4. Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT *
FROM application
ORDER BY Sum DESC
LIMIT 5 OFFSET 10;

# 5. Вивести усіх клієнтів, чиє прізвище закінчується на IV чи IVA.
SELECT *
FROM client
WHERE LastName LIKE '%iv'
   OR LastName LIKE '%iva';

# 6. Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT client.FirstName, client.LastName, d.DepartmentCity
FROM client
         JOIN department d ON client.Department_idDepartment = d.idDepartment
WHERE d.DepartmentCity = 'Kyiv';

# 7. Вивести імена клієнтів та їхні номера паспортів, погрупувавши їх за іменами.
SELECT FirstName, Passport
FROM client
GROUP BY FirstName;

# 8. Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT client.FirstName, client.LastName, a.Sum, a.Currency, a.CreditState
FROM client
         JOIN application a ON client.idClient = a.Client_idClient
WHERE a.Currency = 'Gryvnia'
  AND a.CreditState NOT LIKE 'Returned'
  AND a.Sum > 5000;

# 9. Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(*)
FROM client
UNION
SELECT COUNT(*)
FROM client
         JOIN department d ON client.Department_idDepartment = d.idDepartment
WHERE d.DepartmentCity = 'Lviv';


# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(SUM), c.FirstName, c.LastName
FROM application
         JOIN client c ON c.idClient = application.Client_idClient
GROUP BY c.idClient;

# 11. Визначити кількість заявок на кредит для кожного клієнта.
SELECT Count(*) as appCount, c.FirstName, c.LastName
FROM application
         JOIN client c ON c.idClient = application.Client_idClient
GROUP BY c.FirstName, c.LastName;

# 12. Визначити найбільший та найменший кредити.
SELECT MAX(SUM) as maxCredit, MIN(SUM) as minCredit
FROM application;


# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT Count(*) as appCountHight
FROM application
         JOIN client c ON c.idClient = application.Client_idClient
WHERE c.Education = 'high';


# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.

SELECT AVG(Sum) as avgSum, c.FirstName, c.LastName
FROM application
         JOIN client c on c.idClient = application.Client_idClient
GROUP BY c.FirstName, c.LastName
ORDER BY avgSum DESC
LIMIT 1;


# 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT SUM(Sum) Sum, d.idDepartment, d.DepartmentCity
FROM application
         JOIN client c on c.idClient = application.Client_idClient
         JOIN department d on d.idDepartment = c.Department_idDepartment
GROUP BY d.idDepartment
ORDER BY Sum DESC
LIMIT 1;


# 16. Вивести відділення, яке видало найбільший кредит.
SELECT application.Sum, d.DepartmentCity, d.idDepartment
FROM application
         JOIN client c on c.idClient = application.Client_idClient
         JOIN department d on d.idDepartment = c.Department_idDepartment
ORDER BY Sum DESC
LIMIT 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application
    JOIN client c on c.idClient = application.Client_idClient
SET Sum = 6000
WHERE Education = 'high';

# 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client
    JOIN department d on d.idDepartment = client.Department_idDepartment
SET City = 'Kyiv'
WHERE d.DepartmentCity = 'Kyiv';

# 19. Видалити усі кредити, які є повернені.
DELETE
FROM application
WHERE CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE application
FROM application
         JOIN client c on c.idClient = application.Client_idClient
WHERE LastName LIKE '_a%'
   OR LastName LIKE '_e%'
   OR LastName LIKE '_i%'
   OR LastName LIKE '_o%'
   OR LastName LIKE '_u%'
   OR LastName LIKE '_y%';

# DELETE FROM application WHERE Client_idClient IN (SELECT idClient from client WHERE REGEXP_LIKE(LastName, '^.[aeyuio].*$'));

# 21. Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT d.DepartmentCity, d.idDepartment
FROM application
         JOIN client c on c.idClient = application.Client_idClient
         JOIN department d on d.idDepartment = c.Department_idDepartment
WHERE d.DepartmentCity = 'Lviv'
GROUP BY d.idDepartment
HAVING SUM(application.Sum) > 5000;


# 22. Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT c.FirstName, c.LastName
FROM application
         JOIN client c on c.idClient = application.Client_idClient
WHERE application.CreditState = 'Returned'
  AND application.Sum > 5000;

# 23. Знайти максимальний неповернений кредит.
SELECT MAX(Sum)
FROM application
WHERE CreditState = 'Not returned';

# 24. Знайти клієнта, сума кредиту якого найменша
SELECT MIN(Sum), client.FirstName, client.LastName
FROM client
         JOIN application a on client.idClient = a.Client_idClient;


# 25. Знайти кредити, сума яких більша за середнє значення усіх кредитів
SELECT *
FROM application
WHERE Sum > (SELECT AVG(Sum) FROM application);

# 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
select * from client where City = (select City as co 
   from client join application a on client.idClient = a.Client_idClient
   group by Client_idClient order by count(idApplication) desc limit 1);


# 27. Знайти місто чувака який набрав найбільше кредитів
SELECT COUNT(*) count, c.City
FROM application
         JOIN client c on c.idClient = application.Client_idClient
GROUP BY c.LastName
ORDER BY count DESC
LIMIT 1;
