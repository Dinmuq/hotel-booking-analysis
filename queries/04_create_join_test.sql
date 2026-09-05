-- Тестовая таблица для демонстрации различных типов JOIN.

DROP TABLE IF EXISTS join_test;

CREATE TABLE join_test (
    BookingID INT,
    Channel TEXT
);

INSERT INTO join_test (BookingID, Channel)
VALUES
    (1, 'Booking'),
    (2, 'Phone'),
    (3, 'Partner');
	
