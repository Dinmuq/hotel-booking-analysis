-- Справочная таблица для классификации каналов бронирования
-- на OTA и Direct.

CREATE TABLE booking_channels (
    Channel TEXT PRIMARY KEY,
    ChannelType TEXT
);

INSERT INTO booking_channels (Channel, ChannelType)
VALUES
    ('Booking', 'OTA'),
    ('Agoda', 'OTA'),
    ('Walk-in', 'Direct'),
    ('Phone', 'Direct'),
    ('Website', 'Direct');