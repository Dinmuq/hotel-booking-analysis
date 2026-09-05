-- 1. Добавить к каждому бронированию тип канала (OTA или Direct).

SELECT
    hb.BookingID,
    hb.Channel,
    bc.ChannelType
FROM hotel_bookings AS hb
INNER JOIN booking_channels AS bc
    ON hb.Channel = bc.Channel;

-- 2. Показать все записи тестовой таблицы и добавить тип канала,
-- если канал найден в справочнике.

SELECT 
	jt.BookingID, 
	jt.Channel,
	bc.ChannelType
FROM join_test AS jt
LEFT JOIN booking_channels AS bc
    ON jt.channel = bc.channel;

-- 3. Найти каналы из тестовой таблицы,
-- которых нет в справочнике booking_channels.

SELECT
    jt.BookingID,
    jt.Channel,
    bc.ChannelType
FROM join_test AS jt
LEFT JOIN booking_channels AS bc
    ON jt.Channel = bc.Channel
WHERE bc.Channel IS NULL;



-- 4. Найти каналы из справочника booking_channels,
-- которых нет в тестовой таблице.

SELECT
    bc.Channel,
    bc.ChannelType
FROM booking_channels AS bc
LEFT JOIN join_test AS jt
    ON bc.Channel = jt.Channel
WHERE jt.Channel IS NULL;

-- 5. Показать все каналы из справочника booking_channels,
-- даже если для них нет совпадения в тестовой таблице.

SELECT
    jt.BookingID,
    bc.Channel,
    bc.ChannelType
FROM join_test AS jt
RIGHT JOIN booking_channels AS bc
    ON jt.Channel = bc.Channel;

-- 6. Показать все каналы из обеих таблиц,
-- включая строки без совпадения.

SELECT
    jt.BookingID,
    jt.Channel AS TestChannel,
    bc.Channel AS ReferenceChannel,
    bc.ChannelType
FROM join_test AS jt
FULL OUTER JOIN booking_channels AS bc
    ON jt.Channel = bc.Channel;

-- 7. Показать все каналы из обеих таблиц.
-- Если канал присутствует только в одной таблице,
-- вывести его название с помощью COALESCE.

SELECT
    bc.ChannelType,
    jt.BookingID,
    COALESCE(jt.Channel, bc.Channel) AS Channel
FROM join_test AS jt
FULL OUTER JOIN booking_channels AS bc
    ON jt.Channel = bc.Channel;

-- 8. Сравнить типы каналов по количеству бронирований,
-- общей и средней сумме бронирования.

SELECT 
    bc.ChannelType, 
    COUNT(*) AS BookingCount,
    SUM(hb.TotalAmount) AS TotalBookingAmount,
	ROUND(AVG(hb.TotalAmount), 2) AS AvgBookingAmount
FROM hotel_bookings AS hb
INNER JOIN booking_channels AS bc
    ON hb.Channel = bc.Channel
GROUP BY bc.ChannelType;