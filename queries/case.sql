-- 1. Присвоить каждому бронированию категорию Low / Medium / High

SELECT 
	BookingID,
	TotalAmount,
	CASE
		WHEN TotalAmount < 300 THEN 'Low' 
		WHEN TotalAmount <= 600 THEN 'Medium'
		ELSE 'High' 
	END AS PriceCategory
FROM hotel_bookings;

-- 2. Сколько бронирований попало в каждую категорию Low / Medium / High?

SELECT 
	CASE
		WHEN TotalAmount < 300 THEN 'Low' 
		WHEN TotalAmount <= 600 THEN 'Medium'
		ELSE 'High' 
	END AS PriceCategory,
COUNT(*) AS TotalBookings
FROM hotel_bookings
GROUP BY PriceCategory;

-- 3. Классифицировать бронирования по продолжительности проживания

SELECT 
	BookingID,
		Nights,
	CASE
		WHEN Nights <= 2 THEN 'Short' 
		WHEN Nights <= 5 THEN 'Medium'
		ELSE 'Long' 
	END AS StayType
FROM hotel_bookings;