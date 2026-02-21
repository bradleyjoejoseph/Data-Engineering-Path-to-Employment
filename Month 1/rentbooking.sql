/*
project: booking data analysis
deliverable: month 1 - sql fundamentals
description: 
    this script initializes a relational database for a property booking app. 
    it demonstrates core sql proficiency including schema design, data 
    manipulation, and analytical querying.

business logic & objectives:
    - user retention: identifies new signups via date filtering.
    - revenue optimization: calculates total and city-specific earnings 
      from confirmed stays while ignoring cancelled/null entries.
    - operational efficiency: tracks null-status bookings to identify 
      system drop-offs and abandoned checkouts.
    - customer segmentation: isolates high-value users (spending > 1000) 
      for loyalty targeting using 'having' clauses.
    - market inventory: audits property types and pricing averages to 
      balance supply and demand across cities.
*/

create table users (
    user_id integer primary key,
    name text,
    email text,
    signup_date date,
    membership_level text
);

create table properties (
    property_id integer primary key,
    city text,
    property_type text,
    price_per_night integer
);

create table bookings (
    booking_id integer primary key,
    user_id integer,
    property_id integer,
    check_in_date date,
    nights integer,
    status text,
    foreign key (user_id) references users(user_id),
    foreign key (property_id) references properties(property_id)
);

insert into users (user_id, name, email, signup_date, membership_level) values
    (1, 'Bradley Joe Joseph', 'bradleyjoejoseph@email.com', '2023-01-15', 'vip'),
    (2, 'Ben Roberts', 'benroberts@email.com', '2023-03-22', 'basic'),
    (3, 'George Pickens', '1ssue@email.com', '2023-05-10', 'vip'),
    (4, 'Conor Mcgregor', 'mysticmac@email.com', '2023-07-01', 'vip'),
    (5, 'Alfie Regrecious', 'regrecious@email.com', '2023-11-12', 'basic');

insert into properties (property_id, city, property_type, price_per_night) values
    (101, 'new york', 'apartment', 250),
    (102, 'new york', 'house', 450),
    (103, 'miami', 'apartment', 180),
    (104, 'austin', 'house', 300),
    (105, 'miami', 'house', 500);

insert into bookings (booking_id, user_id, property_id, check_in_date, nights, status) values
    (501, 1, 101, '2024-01-10', 3, 'confirmed'),
    (502, 2, 103, '2024-02-15', 2, 'confirmed'),
    (503, 3, 102, '2024-03-01', 5, null),
    (504, 4, 105, '2024-04-10', 1, 'confirmed'),
    (505, 1, 104, '2024-05-20', 2, 'cancelled'),
    (506, 5, 101, '2024-06-05', 4, 'confirmed'),
    (507, 2, 104, '2024-07-12', 3, 'confirmed');

select * from properties 
    where city = 'new york';

select * from bookings 
    where status is null;

select * from users 
    where signup_date between '2023-01-01' and '2023-06-30';

select * from properties 
    where price_per_night > 200 and property_type = 'house';

select distinct city from properties;

select sum(price_per_night * nights) as total_revenue from bookings 
    join properties on bookings.property_id = properties.property_id
    where status = 'confirmed';

select property_type, avg(price_per_night) as avg_price from properties 
    group by property_type;

select user_id, count(booking_id) as booking_count from bookings
    group by user_id;

select max(price_per_night) as max_price, min(price_per_night) as min_price from properties;

select city, count(*) as property_count from properties
    group by city;

select bookings.booking_id, users.name from bookings 
    inner join users on bookings.user_id = users.user_id;

select users.name, bookings.booking_id from users 
    left join bookings on users.user_id = bookings.user_id;

select users.name, properties.city, bookings.check_in_date from bookings 
    join users on bookings.user_id = users.user_id 
    join properties on bookings.property_id = properties.property_id;

select properties.city, sum(properties.price_per_night * bookings.nights) as city_revenue from bookings 
    join properties on bookings.property_id = properties.property_id 
    where bookings.status = 'confirmed'
    group by properties.city;

select users.name, sum(properties.price_per_night * bookings.nights) as total_spent from bookings 
    join users on bookings.user_id = users.user_id 
    join properties on bookings.property_id = properties.property_id 
    group by users.name having total_spent > 1000;