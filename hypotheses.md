# Initial Hypotheses for Reimbursement Calculation

Based on the analysis of `public_cases.json` and `INTERVIEWS.md`, the following initial hypotheses have been formulated regarding the core reimbursement rules.

## 1. Per Diem Rates

*   **H1.1:** A base per diem of approximately $100/day is applied for each day of the trip.
*   **H1.2:** Trips of exactly 5 days receive a significant bonus of 15%.
*   **H1.3:** (From interviews, not directly testable with `public_cases.json` alone) Employee tenure or history might influence per diem calculations (e.g., new employees getting lower rates).
*   **H1.4:** Optimal daily spending caps exist and vary by trip duration:
    - 1-3 day trips: ~$75/day
    - 4-6 day trips: ~$120/day
    - 7+ day trips: ~$90/day
*   **H1.5:** Very short trips (1-2 days) with low mileage (<50 miles) receive a minimum per diem guarantee.

## 2. Mileage Tiers & Calculation

*   **H2.1:** Mileage reimbursement follows a tiered structure:
    - First 100 miles: ~$0.58/mile
    - 101-300 miles: ~$0.45/mile
    - 301+ miles: ~$0.35/mile
*   **H2.2:** The mileage rate drop-off is non-linear and appears to follow a logarithmic curve.
*   **H2.3:** An "efficiency" factor (miles_traveled / trip_duration_days) impacts reimbursement:
    - Optimal range: 180-220 miles/day
    - Below 100 miles/day: Penalty
    - Above 300 miles/day: Diminishing returns
*   **H2.4:** High receipt amounts (>$1000) appear to reduce mileage reimbursement by approximately 15-20%.

## 3. Receipt Impacts

*   **H3.1:** Receipt reimbursement follows a diminishing returns model:
    - First $100: 100% reimbursement
    - $101-$500: 80% reimbursement
    - $501-$1000: 60% reimbursement
    - $1000+: 40% reimbursement
*   **H3.2:** Very low receipt amounts (<$20) trigger a penalty, reducing total reimbursement by 10-15%.
*   **H3.3:** Receipt totals ending in .49 or .99 receive a small rounding bonus (approximately 2-3%).
*   **H3.4:** Daily spending rates exceeding $200/day trigger a penalty multiplier of 0.8x on receipt reimbursement.

## 4. Efficiency Bonuses/Penalties

*   **H4.1:** Efficiency bonuses are calculated as a percentage of base reimbursement:
    - 150-179 miles/day: +10% bonus
    - 180-220 miles/day: +20% bonus
    - 221-250 miles/day: +5% bonus
*   **H4.2:** Efficiency penalties:
    - <100 miles/day: -15% penalty
    - >300 miles/day: -10% penalty
*   **H4.3:** The efficiency calculation appears to be weighted more heavily for longer trips (5+ days).
*   **H4.4:** The positive efficiency bonus (e.g., 1.20x or 1.10x) is nullified (set to 1.0) if any of the following conditions are met:
        a. Average daily receipts (`total_receipts_amount / trip_duration_days`) exceed $400.
        b. The trip duration is 7 days or longer AND the `total_receipts_amount` exceeds $900.
        c. The trip duration is 5 days AND the `total_receipts_amount` exceeds $800.
*   **H4.5:** Special handling for extreme single-day trips: if `trip_duration_days == 1` and `miles_traveled > 1000`, the `efficiency_multiplier` is set to 0.85.*

## 5. Special Conditions & Other Factors

*   **H5.1:** 5-day trips receive a special "sweet spot" bonus of approximately 25% on total reimbursement.
*   **H5.2:** The system uses distinct calculation paths based on trip categories:
    - Quick trips (1-2 days): Focus on mileage efficiency
    - Medium trips (3-6 days): Balanced calculation
    - Long trips (7+ days): Focus on spending efficiency
*   **H5.3:** (From interviews) Submission timing may affect results, but this is not testable with current data.
*   **H5.4:** "Vacation penalty" applies to trips of 8+ days with average daily spending >$150.
*   **H5.5:** (From interviews) Employee history may affect calculations, but not testable with current data.
*   **H5.6:** There appears to be a minimum reimbursement guarantee of approximately $100 for any valid trip.
*   **H5.7:** The system may apply different rules based on the ratio of receipts to mileage, with optimal ratios varying by trip duration.

## 6. New Hypotheses from Public Cases Analysis

*   **H6.1:** The system appears to have a maximum reimbursement cap of approximately $2000 for standard trips.
*   **H6.2:** There is a "minimum activity" threshold where trips with very low mileage (<20 miles) and low receipts (<$10) receive a standardized minimum reimbursement.
*   **H6.3:** The interaction between mileage and receipts follows a non-linear pattern, where high mileage can partially offset low receipts and vice versa.
*   **H6.4:** The system appears to round final amounts to the nearest $0.01, with a slight bias towards rounding up.
*   **H6.5:** There may be a "complexity bonus" for trips that combine high mileage with moderate receipts, suggesting the system rewards business activity.

These hypotheses will guide further quantitative analysis of `public_cases.json` to derive specific formulas and thresholds.
