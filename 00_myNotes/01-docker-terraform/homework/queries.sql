
green_taxi_data schema
"congestion_surcharge"	"double precision"
"VendorID"	"bigint"
"lpep_pickup_datetime"	"timestamp without time zone"
"lpep_dropoff_datetime"	"timestamp without time zone"
"trip_type"	"double precision"
"index"	"bigint"
"RatecodeID"	"double precision"
"PULocationID"	"bigint"
"DOLocationID"	"bigint"
"passenger_count"	"double precision"
"trip_distance"	"double precision"
"fare_amount"	"double precision"
"extra"	"double precision"
"mta_tax"	"double precision"
"tip_amount"	"double precision"
"tolls_amount"	"double precision"
"improvement_surcharge"	"double precision"
"total_amount"	"double precision"
"payment_type"	"double precision"
"store_and_fwd_flag"	"text"
"ehail_fee"	"text"

taxi_zone schema
"index"	"bigint"
"LocationID"	"bigint"
"Borough"	"text"
"Zone"	"text"
"service_zone"	"text"

SELECT
    COUNT(*) FILTER (WHERE trip_distance <= 1) AS trips_up_to_1_mile,
    COUNT(*) FILTER (WHERE trip_distance > 1 AND trip_distance <= 3) AS trips_between_1_and_3_miles,
    COUNT(*) FILTER (WHERE trip_distance > 3 AND trip_distance <= 7) AS trips_between_3_and_7_miles,
    COUNT(*) FILTER (WHERE trip_distance > 7 AND trip_distance <= 10) AS trips_between_7_and_10_miles,
    COUNT(*) FILTER (WHERE trip_distance > 10) AS trips_over_10_miles
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01';


SELECT
    lpep_pickup_datetime::date AS pickup_date,
    MAX(trip_distance) AS longest_trip_distance
FROM green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01'
GROUP BY pickup_date
ORDER BY longest_trip_distance DESC
LIMIT 1;


SELECT
    gtd."PULocationID",
    tz."Zone",
    SUM(gtd.total_amount) AS total_revenue
FROM green_taxi_data gtd
JOIN taxi_zone tz ON gtd."PULocationID" = tz."LocationID"
WHERE gtd.lpep_pickup_datetime::date = '2019-10-18'
GROUP BY gtd."PULocationID", tz."Zone"
HAVING SUM(gtd.total_amount) > 13000
ORDER BY total_revenue DESC;


SELECT
    tz_dropoff."Zone" AS dropoff_zone,
    MAX(gtd."tip_amount") AS largest_tip
FROM green_taxi_data gtd
JOIN taxi_zone tz_pickup ON gtd."PULocationID" = tz_pickup."LocationID"
JOIN taxi_zone tz_dropoff ON gtd."DOLocationID" = tz_dropoff."LocationID"
WHERE tz_pickup."Zone" = 'East Harlem North'
AND gtd.lpep_pickup_datetime >= '2019-10-01'
AND gtd.lpep_pickup_datetime < '2019-11-01'
GROUP BY dropoff_zone
ORDER BY largest_tip DESC
LIMIT 1;