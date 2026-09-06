CREATE TABLE hotel_bookings (
    id UUID PRIMARY KEY,
    org_id UUID NOT NULL,
    hotel_id VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    amount NUMERIC(12,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,

    CONSTRAINT hotel_bookings_dates_check
        CHECK (checkout_date > checkin_date),

    CONSTRAINT hotel_bookings_amount_check
        CHECK (amount >= 0),

    CONSTRAINT hotel_bookings_status_check
        CHECK (
            status IN (
                'pending',
                'confirmed',
                'cancelled',
                'completed'
            )
        )
);

CREATE TABLE booking_events (
    id BIGSERIAL PRIMARY KEY,
    booking_id UUID NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB,
    created_at TIMESTAMP NOT NULL,

    CONSTRAINT booking_events_booking_fk
        FOREIGN KEY (booking_id)
        REFERENCES hotel_bookings(id)
);