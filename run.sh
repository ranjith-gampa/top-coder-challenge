#!/usr/bin/env python3

import sys
import math

def calculate_reimbursement(trip_duration_days, miles_traveled, total_receipts_amount):
    # Starting from Set 17 code.
    # Micro-Adjustment 1: Add a global fixed bonus of $1.65.

    per_diem_total_base = 0.0
    final_mileage_reimbursement = 0.0
    final_receipt_reimbursement = 0.0

    # --- Standard Per Diem Calculation ---
    per_diem_rate_actual = 0.0
    if 1 <= trip_duration_days <= 6:
        per_diem_rate_actual = 100.0
    elif 7 <= trip_duration_days <= 10:
        per_diem_rate_actual = 80.0
    else: # trip_duration_days > 10
        per_diem_rate_actual = 60.0

    per_diem_total_base = trip_duration_days * per_diem_rate_actual

    per_diem_to_use_in_final_calc = per_diem_total_base
    if trip_duration_days == 5:
        per_diem_to_use_in_final_calc += 50.0

    # --- Standard Mileage base calculation ---
    if miles_traveled > 0:
        tier1_rate = 0.58
        tier1_miles_cap = 100.0
        tier2_rate = 0.45
        if miles_traveled <= tier1_miles_cap:
            final_mileage_reimbursement = miles_traveled * tier1_rate
        else:
            final_mileage_reimbursement = (tier1_miles_cap * tier1_rate) + \
                                    ((miles_traveled - tier1_miles_cap) * tier2_rate)

    # --- Standard Receipt Pre-Calculation & DSL ---
    actual_daily_spending = 0
    if trip_duration_days > 0:
        actual_daily_spending = total_receipts_amount / trip_duration_days

    dsl = 0.0
    if trip_duration_days == 1:
        if total_receipts_amount > 800:
            dsl = total_receipts_amount
        else:
            dsl = 200.0
    elif 1 < trip_duration_days <= 3:
        dsl = 200.0
    elif trip_duration_days <= 6:
        dsl = 120.0
    else: # trip_duration_days > 6
        dsl = 90.0

    effective_receipts_for_calc = total_receipts_amount
    if dsl != total_receipts_amount and actual_daily_spending > dsl:
        effective_receipts_for_calc = dsl * trip_duration_days

    low_receipt_min_daily_avg = 20.0
    if effective_receipts_for_calc < (trip_duration_days * low_receipt_min_daily_avg):
        final_receipt_reimbursement = 0.0
    else:
        receipt_cap1 = 400.0; receipt_rate1 = 0.80
        receipt_cap2 = 800.0; receipt_rate2 = 0.50
        receipt_rate3 = 0.30

        if effective_receipts_for_calc <= receipt_cap1:
            final_receipt_reimbursement = effective_receipts_for_calc * receipt_rate1
        elif effective_receipts_for_calc <= receipt_cap2:
            final_receipt_reimbursement = (receipt_cap1 * receipt_rate1) + \
                                    ((effective_receipts_for_calc - receipt_cap1) * receipt_rate2)
        else:
            final_receipt_reimbursement = (receipt_cap1 * receipt_rate1) + \
                                    ((receipt_cap2 - receipt_cap1) * receipt_rate2) + \
                                    ((effective_receipts_for_calc - receipt_cap2) * receipt_rate3)

    reimbursement = per_diem_to_use_in_final_calc + final_mileage_reimbursement + final_receipt_reimbursement

    # --- Efficiency Adjustments (from Set 17) ---
    if trip_duration_days > 0:
        miles_per_day = miles_traveled / trip_duration_days
        if 160 <= miles_per_day <= 240: # Bonus zone
            reimbursement *= 1.05

    # --- Micro-Adjustment 1: Global Fixed Bonus ---
    reimbursement += 1.65

    return round(reimbursement, 2)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: ./run.sh <trip_duration_days> <miles_traveled> <total_receipts_amount>", file=sys.stderr)
        sys.exit(1)
    try:
        trip_duration_days = int(sys.argv[1])
        miles_traveled = float(sys.argv[2])
        total_receipts_amount = float(sys.argv[3])
    except ValueError:
        print("Error: Input arguments must be numeric.", file=sys.stderr)
        sys.exit(1)
    if trip_duration_days <= 0:
        print("Error: Trip duration must be a positive integer.", file=sys.stderr)
        sys.exit(1)
    if miles_traveled < 0:
        print("Error: Miles traveled cannot be negative.", file=sys.stderr)
        sys.exit(1)
    if total_receipts_amount < 0:
        print("Error: Total receipts amount cannot be negative.", file=sys.stderr)
        sys.exit(1)
    final_reimbursement = calculate_reimbursement(trip_duration_days, miles_traveled, total_receipts_amount)
    print(final_reimbursement)
