-- ============================================================
-- SQL Murder Mystery Solution
-- Source: https://mystery.knightlab.com/
-- ============================================================

-- ============================================================
-- PART 1: Finding the Murderer
-- ============================================================

-- Step 1: Find the crime scene report (murder, Jan 15 2018, SQL City)
SELECT *
FROM crime_scene_report
WHERE date = '20180115'
  AND city = 'SQL City'
  AND type = 'murder';
-- Result: 2 witnesses
--   #1 lives at the last house on Northwestern Dr
--   #2 lives somewhere on Franklin Ave

-- Step 2: Find witness #1 (last house = highest address number on Northwestern Dr)
SELECT p.*, i.transcript
FROM person p
JOIN interview i ON p.id = i.person_id
WHERE p.address_street_name = 'Northwestern Dr'
ORDER BY p.address_number DESC
LIMIT 1;
-- Result: Morty Schapiro (id 14887)
-- Clues: gym bag starting with "48Z", gold member, car plate includes "H42W"

-- Step 3: Find witness #2 (Franklin Ave — get her interview in the same query)
SELECT p.*, i.transcript
FROM person p
JOIN interview i ON p.id = i.person_id
WHERE p.address_street_name = 'Franklin Ave'
  AND p.id IN (
    SELECT person_id
    FROM get_fit_now_check_in
    WHERE check_in_date = '20180109'
  );

-- Step 4: Find gold members whose membership ID starts with "48Z"
-- and whose car plate includes "H42W" — all in one query
SELECT p.id, p.name, g.id AS membership_id, g.membership_status, d.plate_number
FROM get_fit_now_member g
JOIN person p ON g.person_id = p.id
JOIN drivers_license d ON p.license_id = d.id
WHERE g.id LIKE '48Z%'
  AND g.membership_status = 'gold'
  AND d.plate_number LIKE '%H42W%';
-- Result: Jeremy Bowers (id 67318)

-- ============================================================
-- PART 2: Finding the True Villain
-- ============================================================

-- Step 5: Read Jeremy Bowers' interview
SELECT transcript
FROM interview
WHERE person_id = 67318;
-- Clues: woman, height 65-67", red hair, Tesla Model S,
--        attended SQL Symphony Concert 3x in December 2017

-- Step 6: Find women matching the physical description driving a Tesla Model S
--         who also attended the SQL Symphony Concert exactly 3 times in Dec 2017
SELECT p.id, p.name, d.height, d.hair_color, d.car_make, d.car_model, f.times_attended
FROM drivers_license d
JOIN person p ON d.id = p.license_id
JOIN (
    SELECT person_id, COUNT(*) AS times_attended
    FROM facebook_event_checkin
    WHERE event_name = 'SQL Symphony Concert'
      AND date LIKE '201712%'
    GROUP BY person_id
    HAVING COUNT(*) = 3
) f ON p.id = f.person_id
WHERE d.height BETWEEN 65 AND 67
  AND d.hair_color = 'red'
  AND d.gender = 'female'
  AND d.car_make = 'Tesla'
  AND d.car_model = 'Model S';
-- Result: Miranda Priestly (person_id 99716)
