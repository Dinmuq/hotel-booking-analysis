-- 1. Пронумеровать бронирования внутри каждой страны
-- от самого дорогого к самому дешёвому

SELECT
    Country,
    BookingID,
    TotalAmount,
    ROW_NUMBER() OVER (
        PARTITION BY Country
        ORDER BY TotalAmount DESC
    ) AS RowNum
FROM hotel_bookings;

-- 2. Найти 3 самых дорогих бронирования в каждой стране

WITH country_total AS(
SELECT
	Country,
	BookingID,
	TotalAmount,
	ROW_NUMBER() OVER (
        PARTITION BY Country
        ORDER BY TotalAmount DESC
    ) AS RowNum
FROM hotel_bookings
)

SELECT *
FROM country_total
WHERE RowNum <=3;

-- 3. Присвоить каждому бронированию место в рейтинге по сумме
-- внутри своей страны. Одинаковые суммы получают одинаковый ранг,
-- следующее место может быть пропущено.

SELECT
    Country,
    BookingID,
    TotalAmount,
    RANK() OVER (
        PARTITION BY Country
        ORDER BY TotalAmount DESC
    ) AS RankNum
FROM hotel_bookings;

-- 4. Присвоить каждому бронированию место в рейтинге по сумме
-- внутри своей страны. Одинаковые суммы получают одинаковый ранг
-- без пропусков следующих мест.

SELECT
    Country,
    BookingID,
    TotalAmount,
    DENSE_RANK() OVER (
        PARTITION BY Country
        ORDER BY TotalAmount DESC
    ) AS DenseRankNum
FROM hotel_bookings;

-- 5. Показать каждое бронирование и рядом общую сумму всех бронирований этой страны.

SELECT Country, BookingID, TotalAmount, 
		SUM(TotalAmount) OVER (
        PARTITION BY Country
		) AS CountryTotal
FROM hotel_bookings;

-- 6. Показать накопительную сумму бронирований внутри каждой страны,
-- начиная от самого дорогого бронирования.

SELECT Country, BookingID, TotalAmount,
	SUM(TotalAmount) OVER (
    PARTITION BY Country
    ORDER BY TotalAmount DESC, BookingID
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS RunningTotal
FROM hotel_bookings;



-- 7. Для каждого бронирования показать его сумму и среднюю сумму бронирования 
-- по его стране.

SELECT Country, BookingID, TotalAmount,
	AVG(TotalAmount) OVER (
	PARTITION BY Country
	) AS CountryAvg
FROM hotel_bookings;

-- 8. Найти бронирования, сумма которых выше
-- средней суммы бронирования по своей стране.

WITH country_avg AS(
SELECT Country, BookingID, TotalAmount, 
	AVG(TotalAmount) OVER (
	PARTITION BY Country
	) AS CountryAvg
FROM hotel_bookings
)

SELECT *
FROM country_avg
WHERE TotalAmount > CountryAvg;

-- 9. Для каждого бронирования показать его дату, уникальный номер, сумму 
-- и сумму предыдущего бронирования по дате.

SELECT BookingDate, BookingID, TotalAmount,
	LAG(TotalAmount) OVER (
	ORDER BY BookingDate, BookingID
	) AS PreviousAmount
FROM hotel_bookings;

-- 10. Сравнить общую сумму бронирований каждого месяца
-- с предыдущим месяцем.

SELECT 
    DATE_TRUNC('month', BookingDate) AS BookingMonth,
    SUM(TotalAmount) AS MonthlyBookingAmount,

    LAG(SUM(TotalAmount)) OVER (
        ORDER BY DATE_TRUNC('month', BookingDate)
    ) AS PreviousAmount,

    SUM(TotalAmount)
    -
    LAG(SUM(TotalAmount)) OVER (
        ORDER BY DATE_TRUNC('month', BookingDate)
    ) AS BookingAmountDifference

FROM hotel_bookings
GROUP BY DATE_TRUNC('month', BookingDate)
ORDER BY BookingMonth;

-- 11. Показать по каждому месяцу, выросла общая сумма бронирований,
-- уменьшилась или осталась без изменений по сравнению с предыдущим месяцем.

WITH monthly_data AS (
    SELECT 
        EXTRACT(MONTH FROM BookingDate) AS BookingMonth,
        SUM(TotalAmount) AS MonthlyBookingAmount,
        LAG(SUM(TotalAmount)) OVER (
            ORDER BY EXTRACT(MONTH FROM BookingDate)
        ) AS PreviousAmount
    FROM hotel_bookings
    GROUP BY EXTRACT(MONTH FROM BookingDate)
)

SELECT
    BookingMonth,
    MonthlyBookingAmount,
    PreviousAmount,
    MonthlyBookingAmount - PreviousAmount AS BookingAmountDifference,

    CASE
        WHEN PreviousAmount IS NULL THEN 'No previous month'
		WHEN MonthlyBookingAmount > PreviousAmount THEN 'Growth'
        WHEN MonthlyBookingAmount < PreviousAmount THEN 'Decline'
        ELSE 'No change'
    END AS BookingAmountTrend

FROM monthly_data
ORDER BY BookingMonth;
	
-- 12. Рассчитать процент изменения общей суммы бронирований
-- относительно предыдущего месяца.

WITH monthly_data AS (
    SELECT 
        EXTRACT(MONTH FROM BookingDate) AS BookingMonth,
        SUM(TotalAmount) AS MonthlyBookingAmount,
        LAG(SUM(TotalAmount)) OVER (
            ORDER BY EXTRACT(MONTH FROM BookingDate)
        ) AS PreviousAmount
    FROM hotel_bookings
    GROUP BY EXTRACT(MONTH FROM BookingDate)
)

SELECT
    BookingMonth,
    MonthlyBookingAmount,
    PreviousAmount,
   	CASE
    WHEN PreviousAmount IS NULL THEN NULL
    ELSE ROUND(
        (MonthlyBookingAmount - PreviousAmount) / PreviousAmount * 100,
        2
    )
END AS PercentageChange
FROM monthly_data
ORDER BY BookingMonth;

-- 13. Для каждого месяца показать общую сумму бронирований
-- и сумму следующего месяца.

SELECT 
    DATE_TRUNC('month', BookingDate) AS BookingMonth,
    SUM(TotalAmount) AS MonthlyBookingAmount,
    LEAD(SUM(TotalAmount)) OVER (
        ORDER BY DATE_TRUNC('month', BookingDate)
    ) AS NextAmount
FROM hotel_bookings
GROUP BY DATE_TRUNC('month', BookingDate)
ORDER BY BookingMonth;

-- 14. Для каждого бронирования показать его сумму и 
-- долю этой суммы от общей суммы бронирований его страны в процентах.

WITH country_total AS (
SELECT 
	Country, 
	TotalAmount, 
	SUM(TotalAmount) OVER (
	PARTITION BY Country
	) AS CountryTotal
FROM hotel_bookings
)

SELECT
	Country,
	TotalAmount,
	CountryTotal,
	ROUND(
        TotalAmount / CountryTotal * 100,
		2
    )AS SharePercent
FROM country_total;

-- 15. Для каждого бронирования показать его сумму и сумму самого дорогого бронирования в его стране.

SELECT 
	Country, 
	BookingID, 
	TotalAmount,
	FIRST_VALUE(TotalAmount) OVER(
	PARTITiON BY Country
	ORDER BY TotalAmount DESC
	) AS MaxBookingInCountry
FROM hotel_bookings;

-- 16. Для каждого бронирования показать сумму
-- самого дешёвого бронирования в его стране.
SELECT
	Country,
	BookingID,
	TotalAmount,
	LAST_VALUE(TotalAmount) OVER(
	PARTITION BY Country
	ORDER BY TotalAmount DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
	) AS MinBookingInCountry
FROM hotel_bookings;

-- 17. Для каждого месяца показать общую сумму бронирований
-- и накопительную сумму с января по текущий месяц.

SELECT
    DATE_TRUNC('month', BookingDate) AS Month,
    SUM(TotalAmount) AS MonthlyBookingAmount,

    SUM(SUM(TotalAmount)) OVER (
        ORDER BY DATE_TRUNC('month', BookingDate)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningBookingAmount

FROM hotel_bookings
GROUP BY DATE_TRUNC('month', BookingDate)
ORDER BY Month;

-- 18. Для каждого бронирования показать его сумму, среднюю сумму по стране и 
-- отклонение от средней.

SELECT 
    Country,
    TotalAmount,
	
    AVG(TotalAmount) OVER (
        PARTITION BY Country
    ) AS CountryAvg,

    TotalAmount - AVG(TotalAmount) OVER (
        PARTITION BY Country
    ) AS DifferenceFromAvg

FROM hotel_bookings;

