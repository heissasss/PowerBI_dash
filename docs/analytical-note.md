# Analytical Report

## 1. Overall Metrics

| Metric | Value |
|---|--:|
| Players in the status log | 82,827 |
| Registered players (have *Pending Verification*) | 81,835 |
| Verified players | 54,126 |
| Verified share | 66.1% |
| Players with a first successful deposit | 13,468 |
| CR registration → verification | 66.1% |
| CR registration → first deposit | 16.5% |
| CR verification → first deposit | 24.9% |
| Successful deposits (OK) | 73,257 |
| Total deposit attempts | 106,750 |
| Transaction success rate | 68.6% |
| Total successful deposit amount | 247,537,023 |
| Average successful deposit | 3,379 |
| Deposits per depositor | 5.4 |
| Average amount per depositor (ARPPU) | 18,380 |
| Average time from registration to FTD | 482 h |
| Median time to FTD | 1.4 h |
| Share of FTDs within 24 h | 65.5% |

## 2. Breakdown by Traffic Type

| Traffic | Reg. | Verified | CR reg-ver | FTD | CR reg-FTD | CR ver-FTD | Depositors | Amount | ARPPU | Avg. deposit |
|---|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
| Inhouse | 37,312 | 28,246 | 75.7% | 5,990 | 16.1% | 21.2% | 5,990 | 124,036,488 | 20,707 | 3,728 |
| Organic | 26,348 | 14,967 | 56.8% | 4,171 | 15.8% | 27.9% | 4,171 | 78,450,666 | 18,809 | 3,284 |
| Unknown | 13,168 | 7,276 | 55.3% | 2,459 | 18.7% | 33.8% | 2,459 | 31,567,374 | 12,838 | 2,589 |
| Partner | 3,633 | 2,570 | 70.7% | 607 | 16.7% | 23.6% | 607 | 11,138,618 | 18,350 | 3,949 |
| OwnedMedia | 1,080 | 890 | 82.4% | 181 | 16.8% | 20.3% | 181 | 2,238,199 | 12,366 | 2,259 |
| Retention | 294 | 177 | 60.2% | 60 | 20.4% | 33.9% | 60 | 105,680 | 1,761 | 1,161 |

## 3. Key Affiliates (Top by Volume)

| Affiliate ID | Traffic | Reg. | CR reg-ver | CR reg-FTD | CR ver-FTD | Depositors | Amount | ARPPU |
|---|--:|--:|--:|--:|--:|--:|--:|--:|
| 3096085 | Inhouse | 23,295 | 79.0% | 19.0% | 24.1% | 4,437 | 109,869,467 | 24,762 |
| 3193723 | Inhouse | 13,729 | 70.4% | 11.0% | 15.7% | 1,513 | 13,439,801 | 8,883 |
| 3582226 | Unknown | 3,463 | 35.7% | 12.4% | 34.8% | 430 | 5,665,342 | 13,175 |
| 4174649 | Unknown | 2,956 | 55.3% | 12.9% | 23.3% | 381 | 2,584,256 | 6,783 |
| 3255400 | Partner | 1,503 | 77.8% | 9.6% | 12.3% | 144 | 1,663,748 | 11,554 |
| 3831029 | Unknown | 1,347 | 49.4% | 26.3% | 53.2% | 354 | 2,135,157 | 6,032 |
| 3661951 | Unknown | 737 | 66.5% | 36.5% | 54.9% | 269 | 7,010,978 | 26,063 |
| 3147327 | OwnedMedia | 767 | 82.4% | 15.0% | 18.2% | 115 | 598,738 | 5,206 |
| 3466614 | Partner | 367 | 80.9% | 37.1% | 45.8% | 136 | 442,973 | 3,257 |
| 3073029 | OwnedMedia | 310 | 82.6% | 21.0% | 25.4% | 65 | 1,638,461 | 25,207 |
| 3308983 | Partner | 167 | 11.4% | 1.8% | 15.8% | 3 | 3,700 | 1,233 |

**Best** by CR registration → FTD (with at least 200 registrations): 4570085 (42.9%), 3466614 (37.1%), 3661951 (36.5%), 3831029 (26.3%).

**Worst:** 3308983 (1.8%), 3255400 (9.6%), 3193723 (11.0%), 3582226 (12.4%).

## 4. Data Quality Issues Found

- **The Dictionary lookup does not cover most affiliates.** There are 241 affiliates in the data but only 98 in the dictionary. 168 affiliates and 13,168 players (16% of registrations) have no traffic type, including the large sources 3582226 and 4174649. Fix: assign traffic type *Unknown* instead of dropping rows, plus a separate counter on the data quality page. This is a question for the client — without it, the traffic type comparison is incomplete.
- **Deposit history is truncated on the left.** Registrations start on 2023-11-29, but transactions only start on 2025-01-20. For the 2023–2024 cohorts (≈76 players), FTD and conversions are understated. Fix: the dashboard defaults to the period starting 2025-01.
- **992 players** have an *Active* (or other) status but never had *Pending Verification*, so they have no registration date. They are excluded from cohort conversions but visible in the *Players Without Registration* measure.
- **Repeated statuses:** 3,485 players received *Pending Verification* more than once (up to 3 times), and 435 players received *Active* up to 5 times (re-verifications / reactivations).
- **3 players were verified before their registration date** (*Active* < *Pending Verification*). The volume is negligible; conversion for them is not adjusted.
- **The dictionary contains a row with an empty Affiliate ID and type Organic.** It must not participate in the join — organic traffic is defined by an explicit surrogate key `ORGANIC`.
- **Three players from `partner_union_players` are missing from the status log** — attribution without a registration event; they are not included in the metrics.
- **31% of deposit attempts fail** (33,403 Rejected, 42 Pending, 37 Refunded, 11 Chargeback). Per the assignment, Refunded and Chargeback are not subtracted from the deposit amount, but they distort the real value of traffic, so they are shown as a separate metric.
- **Anomalous conversion spike in November 2025:** 6,529 registrations and 3,054 FTDs from the same cohort (46.8% vs. a typical 10–15%), with 2,883 of them depositing in the same month. This looks like a one-off promotion/bonus or test traffic — this month should not be used as a benchmark.
- **Extreme spread of amounts:** from 100 to 351,000 with a median of 1,000; 0.1% of transactions are ≥ 100,000. The average deposit is heavily skewed, so the dashboard shows the median next to the mean.

## 5. Analytical Findings

**1. Acquisition volume relies almost entirely on two internal sources.** Inhouse delivers 45.6% of registrations and organic 32.2%, while all external Partner traffic accounts for only 4.4% (3,633 registrations). A single affiliate, 3096085, brings 28% of all registrations and 44% of all deposits. This is a concentration risk: a failure in one source would wipe out half of the funnel. The business should either consciously accept this dependency or deliberately scale the partner channel.

**2. The funnel bottleneck is the first deposit, not verification.** Two thirds of registered players get verified (66%), but only a quarter of verified players make a deposit (24.9%). The loss between registration and deposit is almost 68K players. At the same time, the median time to FTD is 1.4 hours, and 65% of depositors pay within the first day: if a player has not deposited on day one, the probability that they will later drops sharply. Business takeaway: the first 24 hours are critical — welcome communication and bonuses must fire immediately, not a week later.

**3. The best volume and the best quality come from different sources.** The largest affiliates convert below average: 3193723 (13.7K registrations) has a CR reg-FTD of 11.0%, and 3255400 has 9.6%. In contrast, mid-sized sources 3466614 (37.1%), 3661951 (36.5%) and 3831029 (26.3%) convert 2–3× better. 3661951 stands out in particular: 36.5% conversion with an ARPPU of 26,063 — the most valuable audience among sources with more than 500 registrations. The worst source is 3308983: 167 registrations, 11.4% verification, 3 depositors, 3,700 in deposits; this traffic is effectively junk and should be switched off or have its terms renegotiated.

**4. Organic traffic monetizes no worse than paid traffic, but verifies worse.** Organic CR reg-ver is 56.8% vs. 75.7% for Inhouse, yet among verified players organic converts to a deposit better (27.9% vs. 21.2%), and ARPPU is comparable (18,809 vs. 20,707). In other words, organic brings fewer "ready" players, but those who get through verification are solvent. This is an argument for investing in simpler verification for the organic channel: even a small increase in CR reg-ver here yields the highest revenue gain.

**5. Retention traffic does not work economically in its current setup.** 294 registrations, ARPPU of 1,761 and an average deposit of 1,161 — an order of magnitude lower than any other type. Either these are re-registrations of existing players (in which case acquisition metrics should not be applied to them), or the channel is misconfigured. The tracking methodology needs clarification.

## 6. Data Needed for a More Accurate Performance Assessment

- **Acquisition cost** (CPA/RevShare, spend per affiliate) — without it, ROI/ROMI cannot be calculated, and conversion alone does not show whether a source is profitable.
- **Withdrawals, bonuses and NGR** — currently only deposit turnover is measured, not actual margin; a source with high deposits and high withdrawals may be unprofitable.
- **Geo, device, language, landing page / campaign (sub-id)** — would explain conversion differences within a single affiliate.
- **"Registration started" event and verification rejections with reasons** — would show exactly where the 34% of unverified players drop off.
- **Post-FTD activity** (sessions, bets, last activity date) — to assess retention and LTV, not just the first deposit.
- **The complete affiliate dictionary + transaction currency** — closes the two main gaps in the current data.
