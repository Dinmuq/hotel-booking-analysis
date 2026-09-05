-- =====================================================
-- BASIC QUERIES
-- Dataset: Hotel Booking Analysis
-- =====================================================


-- 1. Посмотреть первые 10 строк

SELECT *
FROM hotel_bookings
LIMIT 10;

-- 2. Посчитать количество всех бронирований

SELECT COUNT(*) AS TotalBookings
FROM hotel_bookings;

-- 3. Показать только отмененные бронирования

SELECT *
FROM hotel_bookings
WHERE Status = 'Cancelled';

-- 4. Посчитать количество отмененных бронирований

SELECT COUNT(*) AS CancelledBookings
FROM hotel_bookings
WHERE Status = 'Cancelled';

-- 5. Сколько бронирований приходится на каждый статус?

SELECT Status,
       COUNT(*) AS BookingCount
FROM hotel_bookings
GROUP BY Status;

-- 6. Отсортировать бронирования по стоимости
-- От самых дорогих к самым дешевым


SELECT *
FROM hotel_bookings
ORDER BY TotalAmount DESC;



-- 7. Отсортировать бронирования по дате
-- От самых ранних к самым поздним

SELECT *
FROM hotel_bookings
ORDER BY BookingDate;

-- 8. Показать 5 самых дорогих бронирований

SELECT *
FROM hotel_bookings
ORDER BY TotalAmount DESC
LIMIT 5;

-- 9. Показать 5 самых дорогих завершенных бронирований


SELECT *
FROM hotel_bookings
WHERE Status = 'Checked-out'
ORDER BY TotalAmount DESC
LIMIT 5;

-- 10. Сколько бронирований приходится на каждую страну?

SELECT Country,
       COUNT(*) AS TotalBookings
FROM hotel_bookings
GROUP BY Country
ORDER BY TotalBookings DESC;

-- 11. Какова общая сумма бронирований по каждой стране?

SELECT Country,
       SUM(TotalAmount) AS TotalBookingAmount
FROM hotel_bookings
GROUP BY Country
ORDER BY TotalBookingAmount DESC;

-- 12. Какая средняя стоимость всего проживания?

SELECT AVG(TotalAmount) AS AverageBookingAmount
FROM hotel_bookings;

-- 13. Какая средняя стоимость номера за ночь?

SELECT AVG(PricePerNight) AS AveragePricePerNight
FROM hotel_bookings;

-- 14. Бронирования, в которых не заполнена страна.

SELECT 
	BookingID,
	Country,
	Channel,
	TotalAmount
FROM hotel_bookings
WHERE Country IS NULL;
