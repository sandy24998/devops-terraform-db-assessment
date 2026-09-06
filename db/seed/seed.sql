INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    ('00000000-0000-0000-0000-00000000000' || ((g - 1) % 5 + 1))::uuid,
    'HOTEL-' || ((g - 1) % 10 + 1),
    CASE ((g - 1) % 5)
        WHEN 0 THEN 'delhi'
        WHEN 1 THEN 'mumbai'
        WHEN 2 THEN 'bangalore'
        WHEN 3 THEN 'hyderabad'
        ELSE 'pune'
    END,
    CURRENT_DATE + ((g % 30) + 1),
    CURRENT_DATE + ((g % 30) + 3),
    (100 + (random() * 9900))::numeric(12,2),
    CASE ((g - 1) % 4)
        WHEN 0 THEN 'pending'
        WHEN 1 THEN 'confirmed'
        WHEN 2 THEN 'cancelled'
        ELSE 'completed'
    END,
    CASE
        WHEN g % 3 = 0
            THEN NOW() - ((g % 30) || ' days')::interval
        ELSE NOW() - ((30 + g % 90) || ' days')::interval
    END
FROM generate_series(1, 200) AS g;

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    CASE ((row_number() OVER (ORDER BY id)) % 3)
        WHEN 0 THEN 'booking_created'
        WHEN 1 THEN 'booking_confirmed'
        ELSE 'booking_updated'
    END,
    jsonb_build_object(
        'source', 'seed',
        'booking_id', id
    ),
    created_at + INTERVAL '1 hour'
FROM (
    SELECT id, created_at
    FROM hotel_bookings
    ORDER BY id
    LIMIT 50
) AS selected_bookings;