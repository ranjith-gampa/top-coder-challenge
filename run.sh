#!/usr/bin/env python3

import sys
import math

def calculate_reimbursement(trip_duration_days, miles_traveled, total_receipts_amount):
    # Base components
    per_diem_total = 0.0
    mileage_reimbursement = 0.0
    receipt_reimbursement = 0.0

    # Calculate per diem based on trip length
    if trip_duration_days == 1:
        per_diem_total = 100.0
    elif trip_duration_days <= 3:
        per_diem_total = trip_duration_days * 100.0
    elif trip_duration_days <= 5:
        per_diem_total = trip_duration_days * 95.0
    elif trip_duration_days <= 7:
        per_diem_total = trip_duration_days * 90.0
    elif trip_duration_days <= 10:
        per_diem_total = trip_duration_days * 85.0
    else:
        per_diem_total = trip_duration_days * 80.0

    # 5-day trip bonus (H1.2)
    if trip_duration_days == 5:
        per_diem_total *= 1.15  # Changed from 1.25

    # Minimum per diem guarantee for short trips (H1.5)
    if trip_duration_days <= 2 and miles_traveled < 50:
        per_diem_total = max(per_diem_total, 100.0)

    # Calculate mileage reimbursement with adjusted rates
    if miles_traveled <= 100:
        mileage_reimbursement = miles_traveled * 0.58
    elif miles_traveled <= 300:
        mileage_reimbursement = (100 * 0.58) + ((miles_traveled - 100) * 0.45)
    elif miles_traveled <= 500:
        mileage_reimbursement = (100 * 0.58) + (200 * 0.45) + ((miles_traveled - 300) * 0.35)
    elif miles_traveled <= 800:
        mileage_reimbursement = (100 * 0.58) + (200 * 0.45) + (200 * 0.35) + ((miles_traveled - 500) * 0.27)
    else:
        mileage_reimbursement = (100 * 0.58) + (200 * 0.45) + (200 * 0.35) + (300 * 0.27) + ((miles_traveled - 800) * 0.21)

    # --- Receipt Calculation (H3.1, H3.2, H3.3, H3.4) ---
    if total_receipts_amount > 0:
        # Calculate receipt reimbursement with adjusted caps
        if trip_duration_days == 1:
            if total_receipts_amount <= 100:
                receipt_reimbursement = total_receipts_amount
            elif total_receipts_amount <= 200:
                receipt_reimbursement = 100 + ((total_receipts_amount - 100) * 0.90)
            elif total_receipts_amount <= 500:
                receipt_reimbursement = 190 + ((total_receipts_amount - 200) * 0.80)
            else: # total_receipts_amount > 500
                receipt_reimbursement = 430 + ((total_receipts_amount - 500) * 0.70)
        else:
            if total_receipts_amount <= 100:
                receipt_reimbursement = total_receipts_amount
            elif total_receipts_amount <= 200:
                receipt_reimbursement = 100 + ((total_receipts_amount - 100) * 0.90)
            elif total_receipts_amount <= 500:
                receipt_reimbursement = 190 + ((total_receipts_amount - 200) * 0.80)
            elif total_receipts_amount <= 1000:
                receipt_reimbursement = 430 + ((total_receipts_amount - 500) * 0.70)
            else: # total_receipts_amount > 1000
                receipt_reimbursement = 780 + ((total_receipts_amount - 1000) * 0.10) # Changed from 0.20

        # Apply specific cap for 2-day trips before general cap
        if trip_duration_days == 2:
            receipt_reimbursement = min(receipt_reimbursement, 850.0) # New cap for 2-day trips

        receipt_reimbursement = min(receipt_reimbursement, total_receipts_amount)

        # Low receipt penalty (H3.2)
        if total_receipts_amount < 20:
            receipt_reimbursement *= 0.85

        # Daily spending penalty (H3.4)
        daily_spending = total_receipts_amount / trip_duration_days
        if daily_spending > 200:
            receipt_reimbursement *= 0.8

        # Rounding bonus for .49 or .99 (H3.3)
        if str(total_receipts_amount).endswith('.49') or str(total_receipts_amount).endswith('.99'):
            receipt_reimbursement *= 1.02

    # --- Efficiency Calculations (H4.1, H4.2, H4.3) ---
    miles_per_day = miles_traveled / trip_duration_days if trip_duration_days > 0 else 0
    efficiency_multiplier = 1.0

    # Special handling for extreme single-day trips
    if trip_duration_days == 1 and miles_traveled > 1000:
        efficiency_multiplier = 0.85 # Changed from 0.7
    else:
        if 180 <= miles_per_day <= 220:
            efficiency_multiplier = 1.20
        elif 150 <= miles_per_day < 180:
            efficiency_multiplier = 1.10
        elif 220 < miles_per_day <= 250:
            efficiency_multiplier = 1.05
        elif miles_per_day < 100:
            efficiency_multiplier = 0.85
        elif miles_per_day > 300:
            efficiency_multiplier = 0.90

    # Weight efficiency more heavily for longer trips (H4.3)
    if trip_duration_days >= 5:
        efficiency_multiplier = 1.0 + ((efficiency_multiplier - 1.0) * 1.2)

    # H4.4 Start: Nullify positive efficiency bonus under certain conditions
    # This logic is now placed *before* applying efficiency_multiplier to base_reimbursement sum
    original_efficiency_multiplier_for_H4_4_check = efficiency_multiplier # Store before potential modification

    nullify_bonus_now = False
    if trip_duration_days > 0:
        if (total_receipts_amount / trip_duration_days) > 400: # Reverted from 350
            nullify_bonus_now = True
        if trip_duration_days >= 7 and total_receipts_amount > 900: # Condition b
            nullify_bonus_now = True
        if trip_duration_days == 5 and total_receipts_amount > 800: # New condition c
            nullify_bonus_now = True

    if nullify_bonus_now:
        if original_efficiency_multiplier_for_H4_4_check > 1.0: # Only nullify if it was a bonus
            efficiency_multiplier = 1.0
    # H4.4 End

    # --- Special Conditions (H5.1-H5.7, H6.1-H6.5) ---
    # Calculate base reimbursement
    base_reimbursement = per_diem_total + mileage_reimbursement + receipt_reimbursement
    
    # Apply efficiency multiplier (which might have been modified by H4.4)
    base_reimbursement *= efficiency_multiplier

    # Vacation penalty (H5.4)
    if trip_duration_days >= 8 and (total_receipts_amount / trip_duration_days) > 150:
        base_reimbursement *= 0.9

    # Maximum reimbursement cap (H6.1)
    base_reimbursement = min(base_reimbursement, 2000.0)

    # Minimum reimbursement guarantee (H5.6)
    base_reimbursement = max(base_reimbursement, 100.0)

    # Complexity bonus (H6.5)
    if miles_per_day > 200 and 50 <= (total_receipts_amount / trip_duration_days) <= 150:
        base_reimbursement *= 1.05

    # Round to nearest cent with slight upward bias (H6.4)
    final_reimbursement = math.ceil(base_reimbursement * 100) / 100

    return final_reimbursement

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
