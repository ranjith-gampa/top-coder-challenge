# Initial Hypotheses for Reimbursement Calculation

Based on the analysis of `public_cases.json` and `INTERVIEWS.md`, the following initial hypotheses have been formulated regarding the core reimbursement rules.

## 1. Per Diem Rates

*   **H1.1:** A base per diem (e.g., $100/day) is applied for each day of the trip.
*   **H1.2:** Trips of a specific duration (e.g., exactly 5 days, or a range like 4-6 days) may receive a special per diem bonus or follow a different per diem calculation.
*   **H1.3:** (From interviews, not directly testable with `public_cases.json` alone) Employee tenure or history might influence per diem calculations (e.g., new employees getting lower rates).
*   **H1.4:** Optimal daily spending caps likely exist and might vary by trip duration. Exceeding these caps could negatively impact the total reimbursement, effectively reducing the per diem benefits.

## 2. Mileage Tiers & Calculation

*   **H2.1:** Mileage reimbursement is tiered. A higher rate (e.g., $0.58/mile) applies to an initial block of miles (e.g., the first 100 miles). Subsequent miles are reimbursed at a lower rate or multiple lower rates.
*   **H2.2:** The drop-off in mileage rate after the initial tier is not necessarily linear and might follow a curve or a step-down function.
*   **H2.3:** An "efficiency" factor, calculated as (miles_traveled / trip_duration_days), significantly impacts mileage reimbursement or overall reimbursement. There might be an optimal range for this ratio to maximize bonuses. (Also see Section 4)
*   **H2.4:** (From interviews) The overall spending pattern (e.g., modest vs. high receipts) on a trip, especially longer ones, might interact with how mileage reimbursement is calculated. For instance, high spending could dampen mileage reimbursement.

## 3. Receipt Impacts

*   **H3.1:** Reimbursement from `total_receipts_amount` is not a direct 1:1 pass-through. There's likely a cap or a system of diminishing returns, where each dollar of receipts contributes less to the reimbursement above certain thresholds. These thresholds might depend on trip duration.
*   **H3.2:** Submitting very low receipt amounts (e.g., below a certain absolute threshold or a threshold relative to trip duration) can result in a penalty, potentially leading to a reimbursement amount lower than if no receipts were submitted (i.e., just per diem and mileage).
*   **H3.3:** (From interviews) Receipt totals ending in specific cent amounts (e.g., $XX.49 or $XX.99) might trigger a small favorable rounding anomaly or bonus in the calculation.
*   **H3.4:** Exceeding certain average daily spending rates (total_receipts_amount / trip_duration_days) may lead to penalties or reduced reimbursement for receipts. This could be linked to H1.4.

## 4. Efficiency Bonuses/Penalties

*   **H4.1:** A significant bonus or penalty is likely applied based on the travel efficiency, calculated as average miles per day (miles_traveled / trip_duration_days).
*   **H4.2:** This efficiency bonus/penalty system is non-linear. An optimal range for miles/day (e.g., 180-220 miles/day as suggested in interviews) might yield the maximum bonus. Rates below or significantly above this range could result in lower bonuses or even penalties.

## 5. Special Conditions & Other Factors

*   **H5.1:** Specific trip durations (e.g., exactly 5 days, or a general range of 4-6 days) might trigger special bonuses or follow distinct calculation rules not fully covered by standard per diem, mileage, or efficiency calculations. (Overlaps with H1.2)
*   **H5.2:** The reimbursement system might use different calculation paths or rule-sets based on broad categories of trips, determined by combinations of duration, mileage, and receipt levels (e.g., "short duration, high mileage, low receipts" vs. "long duration, low mileage, high receipts"). A single unified formula might not apply to all cases.
*   **H5.3:** (From interviews, not directly testable with `public_cases.json` data) External factors like the timing of submission (day of week, month, quarter) or even more esoteric factors (e.g., "lunar cycles" as humorously suggested) might introduce variability. While these are hard to model without more data, they highlight the perceived unpredictability.
*   **H5.4:** A "vacation penalty" might exist, where very long trips (e.g., 8+ days) combined with high spending patterns are specifically penalized, beyond general receipt caps. (Related to H3.4 and H1.4).
*   **H5.5:** (From interviews) The system might have a "memory" or build a profile for employees, leading to different treatments over time, but this is not testable with the current dataset.

These hypotheses will guide further quantitative analysis of `public_cases.json` to derive specific formulas and thresholds.
