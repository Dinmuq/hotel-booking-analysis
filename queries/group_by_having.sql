-- 1. Какие типы номеров бронируют чаще всего?

SELECT RoomType,
	COUNT(*) AS TotalBookings
FROM hotel_bookings
GROUP BY RoomType
ORDER BY TotalBookings DESC;

-------------------------------------------------------------------

-- 2. Какой канал бронирования используется чаще всего?

SELECT Channel,
	COUNT(*) AS TotalBookings
FROM hotel_bookings
GROUP BY Channel
ORDER  BY TotalBookings DESC;

--------------------------------------------------------------------

-- 3. Какая максимальная стоимость бронирования?
SELECT MAX(TotalAmount) AS MaxBookingAmount
FROM hotel_bookings;

--------------------------------------------------------------------

-- 4. Какая минимальная стоимость бронирования?
SELECT MIN(TotalAmount) AS MinBookingAmount
FROM hotel_bookings;

--------------------------------------------------------------------

-- 5. Какая средняя продолжительность проживания?

SELECT AVG(Nights) AS AverageNights
FROM hotel_bookings;

--------------------------------------------------------------------

-- 6. Сколько завершённых бронирований было создано в каждом месяце?

SELECT EXTRACT(MONTH FROM BookingDate) AS BookingMonth,
	COUNT(*) AS BookingForMonth
FROM hotel_bookings
WHERE Status = 'Checked-out'
GROUP BY EXTRACT(MONTH FROM BookingDate)
ORDER BY BookingMonth DESC;

--------------------------------------------------------------------

-- 7. Сколько бронирований было отменено и какой это процент от всех бронирований?

SELECT
    COUNT(*) FILTER (WHERE Status = 'Cancelled') AS CancelledBookings,
    COUNT(*) AS TotalBookings,
    COUNT(*) FILTER (WHERE Status = 'Cancelled') * 100.0 / COUNT(*) AS CancellationRate
FROM hotel_bookings;

--------------------------------------------------------------------

-- 8. Страны, где было больше 300 бронирований.

SELECT 
	Country,
	COUNT(*) AS Bookings
FROM hotel_bookings
GROUP BY Country
HAVING COUNT(*) > 300;

--------------------------------------------------------------------

-- 9. Какие типы номеров имеют наибольшую общую сумму бронирований?

SELECT 
    RoomType,	
    SUM(TotalAmount) AS TotalBookingAmount
FROM hotel_bookings
GROUP BY RoomType
ORDER BY TotalBookingAmount DESC;

--------------------------------------------------------------------

-- 10. Какие каналы бронирования имеют общую сумму бронирований более 30 000?

SELECT 
    Channel,
    SUM(TotalAmount) AS TotalBookingAmount
FROM hotel_bookings
GROUP BY Channel
HAVING SUM(TotalAmount) > 30000
ORDER BY TotalBookingAmount DESC;

--------------------------------------------------------------------

-- 11. Какие типы номеров имеют среднюю стоимость за ночь больше 100?

SELECT RoomType,
	AVG(PricePerNight) AS AvgPricePerNight
FROM hotel_bookings
GROUP BY RoomType
HAVING AVG(PricePerNight) > 100;

-----------------------------------------------------------------------

-- 12. Со сколькими уникальными странами мы работали через каждый канал бронирования?

SELECT 
	Channel,
	COUNT(DISTINCT Country) AS UniqueCountries
FROM hotel_bookings
GROUP BY Channel;

-- 13. Найти каналы, у которых средняя сумма бронирования выше
-- средней суммы бронирования по всему отелю.
-- Показать количество бронирований, общую и среднюю сумму.

SELECT
    Channel,
    COUNT(*) AS BookingCount,
    SUM(TotalAmount) AS TotalBookingAmount,
    ROUND(AVG(TotalAmount), 2) AS AvgBookingAmount
FROM hotel_bookings
GROUP BY Channel
HAVING AVG(TotalAmount) > (
    SELECT AVG(TotalAmount)
    FROM hotel_bookings
)
ORDER BY TotalBookingAmount DESC;