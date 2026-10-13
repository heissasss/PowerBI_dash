# Data Model

## Tables

- **Players** (1 row = 1 player) — built in Power Query from `Customer_status_change_report`: registration date (first *Pending Verification* status), verification date (first *Active* status), first successful deposit date (pulled from Deposits), and the assigned affiliate.
- **Deposits** (1 row = 1 transaction) — cleaned `Deposit_history` with a success flag.
- **Dim_Affiliate** — union of `partner_union_players` and the `Dictionary` lookup; a player missing from `partner_union_players` is Organic; an affiliate missing from `Dictionary` is Unknown.
- **Dim_Date** — calendar table, marked as a Date table.
- **Dim_Status** — lookup of transaction statuses.

## Key Design Decision: Three Relationships to the Calendar

Players is related to Dim_Date in three ways: by registration date (active), and by verification date and first deposit date (inactive, enabled in DAX via `USERELATIONSHIP`). This supports two types of metrics:

- **event-based** — registrations / verifications / deposits over time, by the actual date of each event;
- **cohort-based** — conversions where a player is pinned to the period of their registration, regardless of when later actions happened.

Traffic type and affiliate are not duplicated in Deposits — they flow transitively through Players → Dim_Affiliate, so filtering by affiliate works consistently for both conversions and deposit amounts.
