# sql_murder_mystery
SQL murder mystery solution using SQLite

**Source:** [mystery.knightlab.com](https://mystery.knightlab.com/)  
**Database:** SQLite  
**Concepts used:** JOIN, subqueries, GROUP BY, HAVING, LIKE, ORDER BY, LIMIT

---

## The Case

A murder took place in SQL City on January 15, 2018. Starting only from that fact, I used SQL to query a relational database of police records, gym memberships, driver's licenses, and social media check-ins to identify both the murderer and the person who hired them.

---

## Part 1: Finding the Murderer

**Approach:** Retrieved the crime scene report → located both witnesses → joined their interviews → filtered gym members by membership ID prefix and gold status → confirmed suspect via license plate.

**Key queries:**
- `ORDER BY address_number DESC LIMIT 1` to find the last house on a street
- Multi-table `JOIN` across `get_fit_now_member`, `person`, and `drivers_license` to match gym membership, identity, and vehicle in a single query
- `LIKE '48Z%'` and `LIKE '%H42W%'` for partial string matching

**Murderer:** Jeremy Bowers

---

## Part 2: Finding the True Villain

**Approach:** Read Jeremy's interview → joined `drivers_license` and `person` on physical description → used a subquery with `GROUP BY / HAVING` to find people who attended the SQL Symphony Concert exactly 3 times in December 2017 → cross-referenced both result sets.

**Key queries:**
- Subquery to pre-aggregate concert attendance, then joined back to the suspect list
- `HAVING COUNT(*) = 3` to filter post-aggregation (vs WHERE which runs before grouping)
- `BETWEEN` for height range filtering

**True villain:** Miranda Priestly
