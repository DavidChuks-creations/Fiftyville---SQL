-- Keep a log of any SQL queries you execute as you solve the mystery.
-- Get the description of incident From reports
SELECT id , description ,month
  FROM crime_scene_reports
    WHERE street = 'Humphrey Street' AND year = 2021 AND month = 7 AND day = 28;


-- Get more details from witnesses using keyword bakery
SELECT *
  FROM interviews
    WHERE transcript LIKE '%bakery%'
      AND year = 2021 AND month = 7 AND day = 28;


-- Create a table called possible_criminals and store the name, phone and passport of first round of suspects using license plates
CREATE TABLE possible_criminals AS
  SELECT name, phone_number , passport_number
    FROM people WHERE license_plate IN (
      SELECT license_plate
        FROM bakery_security_logs WHERE year = 2021
         AND month = 7 AND day = 28 AND hour = 10
            AND minute >= 15 AND minute <= 25);


-- Eliminate innocent suspects by changing their name to null based on the atm_transactions carried out near bakery
UPDATE possible_criminals
   SET name = 'NULL' WHERE name NOT IN
     (SELECT name FROM people WHERE id IN (
        SELECT person_id FROM bank_accounts WHERE account_number IN(
          SELECT account_number
               FROM atm_transactions
                  WHERE atm_location = 'Leggett Street' AND transaction_type = 'withdraw'
                    AND year = 2021 AND month = 7 AND day = 28)));

-- Delete the innocent suspects
DELETE FROM possible_criminals WHERE name = 'NULL';


-- Eliminate innocent suspects by changing their name to null based on the phone calls carried out at a particular time period
UPDATE possible_criminals
  SET name = 'NULL' WHERE name NOT IN
   (
    SELECT name FROM people WHERE phone_number IN
     (
      SELECT caller FROM phone_calls
         WHERE year = 2021 AND month = 7 AND day = 28 AND duration < 60
      )
    ) ;

DELETE FROM possible_criminals WHERE name = 'NULL';


-- Eliminate innocent suspects by changing their name to null based on the flight activities and earliest flight the next day
UPDATE possible_criminals
  SET name = 'NULL' WHERE passport_number NOT IN
    (
     SELECT passport_number FROM passengers WHERE flight_id =
      (
        SELECT id FROM flights WHERE origin_airport_id =
       (
         SELECT id FROM airports WHERE city = 'Fiftyville'
        )
          AND day = 29 AND month = 7 AND year = 2021
           ORDER BY hour ASC, minute ASC LIMIT 1
        )
      );

DELETE FROM possible_criminals WHERE name = 'NULL';


--  Get accomplice name using the receiver number from phonecall with suspect
SELECT name FROM people WHERE phone_number IN
  (
    SELECT receiver FROM phone_calls WHERE caller IN
     (
       SELECT phone_number FROM possible_criminals
       )
       AND year = 2021 AND month = 7 AND day = 28 AND duration < 60
    );


-- Get city criminal departed into using his passport number and flight id
SELECT city FROM airports WHERE id IN
  (
    SELECT destination_airport_id FROM flights WHERE id IN
     (
      SELECT flight_id FROM passengers WHERE passport_number IN
       (
        SELECT passport_number FROM possible_criminals
       )
     )
   );
