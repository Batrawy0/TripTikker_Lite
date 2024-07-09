-- User Type Table
CREATE TABLE user_type
(
    id   SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

-- Role Table
CREATE TABLE role
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Booking Status Table
CREATE TABLE booking_status
(
    id     SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL
);

-- Payment Integration Type Table
CREATE TABLE payment_integration_type
(
    id   SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

-- Payment Status Table
CREATE TABLE payment_status
(
    id     SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL
);

-- Notification Type Table
CREATE TABLE notification_type
(
    id   SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

-- Notification Status Table
CREATE TABLE notification_status
(
    id     SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL
);

-- User Table
CREATE TABLE "user"
(
    id           SERIAL PRIMARY KEY,
    first_name   VARCHAR(100)        NOT NULL,
    last_name    VARCHAR(100)        NOT NULL,
    email        VARCHAR(255) UNIQUE NOT NULL,
    password     VARCHAR(255)        NOT NULL,
    username     VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    user_type_id INTEGER             NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active    BOOLEAN   DEFAULT TRUE,
    FOREIGN KEY (user_type_id) REFERENCES user_type (id)
);

-- User Role Table
CREATE TABLE user_role
(
    id          SERIAL PRIMARY KEY,
    user_id     INTEGER NOT NULL,
    role_id     INTEGER NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "user" (id),
    FOREIGN KEY (role_id) REFERENCES role (id)
);

-- Customer Table
CREATE TABLE customer
(
    id                           SERIAL PRIMARY KEY,
    user_id                      INTEGER NOT NULL,
    preferred_payment_setting_id INTEGER,
    created_at                   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES "user" (id)
);

-- Preferred Payment Setting Table
CREATE TABLE preferred_payment_setting
(
    customer_id                 INTEGER NOT NULL,
    payment_integration_type_id INTEGER NOT NULL,
    PRIMARY KEY (customer_id, payment_integration_type_id),
    FOREIGN KEY (customer_id) REFERENCES customer (id),
    FOREIGN KEY (payment_integration_type_id) REFERENCES payment_integration_type (id)
);

-- Address Table
CREATE TABLE address
(
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER      NOT NULL,
    line1       VARCHAR(255) NOT NULL,
    line2       VARCHAR(255),
    city        VARCHAR(100) NOT NULL,
    state       VARCHAR(100) NOT NULL,
    zip         VARCHAR(20)  NOT NULL,
    country     VARCHAR(100) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer (id)
);

-- Customer Preferences Table
CREATE TABLE customer_preferences
(
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    preferences TEXT    NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer (id)
);

-- Payment Type Configuration Table
CREATE TABLE payment_type_configuration
(
    id                          SERIAL PRIMARY KEY,
    payment_integration_type_id INTEGER NOT NULL,
    config_details              TEXT    NOT NULL,
    FOREIGN KEY (payment_integration_type_id) REFERENCES payment_integration_type (id)
);

-- Transaction Table
CREATE TABLE transaction
(
    id                            SERIAL PRIMARY KEY,
    payment_type_configuration_id INTEGER        NOT NULL,
    payment_status_id             INTEGER        NOT NULL,
    total_amount                  NUMERIC(10, 2) NOT NULL,
    currency                      VARCHAR(10)    NOT NULL,
    transaction_date              TIMESTAMP      NOT NULL,
    created_at                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_type_configuration_id) REFERENCES payment_type_configuration (id),
    FOREIGN KEY (payment_status_id) REFERENCES payment_status (id)
);

-- Flight Booking Table
CREATE TABLE flight_booking
(
    id                SERIAL PRIMARY KEY,
    customer_id       INTEGER      NOT NULL,
    booking_status_id INTEGER      NOT NULL,
    transaction_id    INTEGER      NOT NULL,
    flight_number     VARCHAR(50)  NOT NULL,
    departure_date    TIMESTAMP    NOT NULL,
    arrival_date      TIMESTAMP    NOT NULL,
    departure_airport VARCHAR(100) NOT NULL,
    arrival_airport   VARCHAR(100) NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer (id),
    FOREIGN KEY (booking_status_id) REFERENCES booking_status (id),
    FOREIGN KEY (transaction_id) REFERENCES transaction (id)
);

-- Hotel Booking Table
CREATE TABLE hotel_booking
(
    id                SERIAL PRIMARY KEY,
    customer_id       INTEGER      NOT NULL,
    booking_status_id INTEGER      NOT NULL,
    transaction_id    INTEGER      NOT NULL,
    hotel_name        VARCHAR(255) NOT NULL,
    check_in_date     TIMESTAMP    NOT NULL,
    check_out_date    TIMESTAMP    NOT NULL,
    room_type         VARCHAR(50)  NOT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer (id),
    FOREIGN KEY (booking_status_id) REFERENCES booking_status (id),
    FOREIGN KEY (transaction_id) REFERENCES transaction (id)
);



-- Transaction Details Table
CREATE TABLE transaction_details
(
    id             SERIAL PRIMARY KEY,
    transaction_id INTEGER NOT NULL,
    details        TEXT    NOT NULL,
    FOREIGN KEY (transaction_id) REFERENCES transaction (id)
);



-- Notification Table
CREATE TABLE notification
(
    id                     SERIAL PRIMARY KEY,
    customer_id            INTEGER NOT NULL,
    notification_type_id   INTEGER NOT NULL,
    notification_status_id INTEGER NOT NULL,
    message                TEXT    NOT NULL,
    created_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer (id),
    FOREIGN KEY (notification_type_id) REFERENCES notification_type (id),
    FOREIGN KEY (notification_status_id) REFERENCES notification_status (id)
);

-- Audit Table
CREATE TABLE audit
(
    id         SERIAL PRIMARY KEY,
    details    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
