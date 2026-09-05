-- 1. Посчитать количество бронирований и общую сумму бронирований по месяцам

SELECT DATE_TRUNC('month', BookingDate) AS Month,
	COUNT(*) AS BookingCount,
	SUM(TotalAmount) AS TotalAmount
FROM hotel_bookings
GROUP BY Month
ORDER BY Month;

-- 2. Проверить корректность количества ночей:
-- найти бронирования, где Nights не совпадает с разницей между CheckOut и CheckIn

SELECT 
	BookingID, 
	CheckIn,
	CheckOut,
	Nights,
	CheckOut - CheckIn AS CalculatedNights
FROM hotel_bookings
WHERE Nights <> (CheckOut - CheckIn);

-- 3. Рассчитать среднее количество дней между бронированием и заездом

SELECT 
    ROUND(AVG(CheckIn - BookingDate), 1) AS AvgLeadTime
FROM hotel_bookings;

-- 4. Показать бронирования, созданные в июне 2025 года.

SELECT 
	BookingID,
	BookingDate,
	Country,
	TotalAmount
FROM hotel_bookings
WHERE BookingDate BETWEEN '2025-06-01' AND '2025-06-30';

-- 5. Заезды не позднее чем через 7 дней после создания бронирования.

SELECT
    BookingID,
    BookingDate,
    CheckIn,
    CheckIn - BookingDate AS LeadTime
FROM hotel_bookings
WHERE CheckIn <= BookingDate + INTERVAL '7 days';