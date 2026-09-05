-- 1. Страны с общей стоимостью бронирований более 100 000

WITH country_booking_amount AS (
    SELECT
        Country,
        SUM(TotalAmount) AS TotalBookingAmount
    FROM hotel_bookings
    GROUP BY Country
)
SELECT *
FROM country_booking_amount
WHERE TotalBookingAmount > 100000
ORDER BY TotalBookingAmount DESC;

-- 2. Какие страны имеют среднюю стоимость бронирования выше 500?
WITH country_avg AS (
SELECT
	Country,
	AVG(TotalAmount) AS AvgTotal
FROM hotel_bookings
GROUP BY Country
)

SELECT *
FROM country_avg
WHERE AvgTotal > 500
ORDER BY AvgTotal DESC;

-- 3. Найди страны, у которых количество бронирований выше среднего количества 
-- бронирований среди всех стран.

WITH country_count AS(
SELECT 
	Country,
	COUNT(*) AS Bookings
FROM hotel_bookings
GROUP BY Country
)

SELECT *
FROM country_count
WHERE Bookings > (
	SELECT AVG(Bookings)
	FROM country_count
);