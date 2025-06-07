#!/usr/bin/env python3

import subprocess
import json

def run_test(trip_days, miles, receipts):
    cmd = f"./run.sh {trip_days} {miles} {receipts}"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return float(result.stdout.strip())

def print_test_result(test_name, expected, actual, tolerance=0.01):
    error = abs(expected - actual)
    status = "✓" if error <= tolerance else "✗"
    print(f"{status} {test_name}")
    print(f"  Expected: ${expected:.2f}")
    print(f"  Actual:   ${actual:.2f}")
    print(f"  Error:    ${error:.2f}")
    print()

# Test Cases

print("=== Per Diem Tests ===")
# H1.1: Base per diem
print_test_result("Base per diem (3 days)", 300.00, run_test(3, 50, 0))

# H1.2: 5-day bonus
print_test_result("5-day bonus", 575.00, run_test(5, 50, 0))

# H1.5: Minimum guarantee
print_test_result("Short trip minimum", 80.00, run_test(1, 20, 0))

print("\n=== Mileage Tests ===")
# H2.1: Tiered mileage
print_test_result("First 100 miles", 58.00, run_test(1, 100, 0))
print_test_result("101-300 miles", 108.50, run_test(1, 200, 0))
print_test_result("301+ miles", 133.00, run_test(1, 400, 0))

# H6.6: Single-day high mileage penalty
print_test_result("Single-day high mileage", 406.00, run_test(1, 1000, 0))

print("\n=== Receipt Tests ===")
# H3.1: Diminishing returns
print_test_result("First $100", 100.00, run_test(1, 0, 100))
print_test_result("$101-$500", 340.00, run_test(1, 0, 500))
print_test_result("$501-$1000", 540.00, run_test(1, 0, 1000))
print_test_result("$1000+", 740.00, run_test(1, 0, 2000))

# H3.2: Low receipt penalty
print_test_result("Low receipt penalty", 16.00, run_test(1, 0, 20))

# H3.3: Rounding bonus
print_test_result("Rounding bonus .49", 101.00, run_test(1, 0, 100.49))
print_test_result("Rounding bonus .99", 101.00, run_test(1, 0, 100.99))

# H3.4: Daily spending penalty
print_test_result("High daily spending", 140.00, run_test(1, 0, 200))

print("\n=== Efficiency Tests ===")
# H4.1: Efficiency bonuses
print_test_result("Optimal efficiency", 230.00, run_test(1, 180, 0))
print_test_result("Good efficiency", 216.00, run_test(1, 150, 0))
print_test_result("Above optimal", 206.00, run_test(1, 220, 0))

# H4.2: Efficiency penalties
print_test_result("Low efficiency", 80.00, run_test(1, 80, 0))
print_test_result("High efficiency", 225.00, run_test(1, 350, 0))

print("\n=== Special Conditions ===")
# H5.4: Vacation penalty
print_test_result("Vacation penalty", 900.00, run_test(7, 0, 1000))

# H6.1: Maximum cap
print_test_result("Maximum cap", 1500.00, run_test(1, 2000, 2000))

# H6.5: Complexity bonus
print_test_result("Complexity bonus", 206.00, run_test(1, 250, 100))

print("\n=== Edge Cases ===")
# Very short trip with high receipts
print_test_result("Short trip high receipts", 200.00, run_test(1, 20, 1000))

# Long trip with low mileage
print_test_result("Long trip low mileage", 560.00, run_test(7, 50, 0))

# High mileage with low receipts
print_test_result("High mileage low receipts", 290.00, run_test(1, 500, 10))

# Problem cases from evaluation
print("\n=== Problem Cases ===")
print_test_result("Case 711", 669.85, run_test(5, 516, 1878.49))
print_test_result("Case 520", 877.17, run_test(14, 481, 939.99))
print_test_result("Case 152", 322.00, run_test(4, 69, 2321.49))
print_test_result("Case 367", 902.09, run_test(11, 740, 1171.99))
print_test_result("Case 996", 446.94, run_test(1, 1082, 1809.49)) 