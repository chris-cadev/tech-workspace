#!python3

import csv
import datetime


def log_food(csv_filename, meal_name, calories):
    """
    Log a meal in the CSV file.
    """
    now = datetime.datetime.now()
    date_string = now.strftime("%Y-%m-%d")
    time_string = now.strftime("%H:%M:%S")
    with open(csv_filename, mode='a', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(
            [date_string, time_string, meal_name, calories, '', ''])


def log_fast(csv_filename, fast_start_time, fast_end_time):
    """
    Log an intermittent fast in the CSV file.
    """
    with open(csv_filename, mode='a', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow([fast_start_time.date(), '', 'FAST',
                            '', fast_start_time.time(), fast_end_time.time()])


def log_exercise(csv_filename, exercise_name, duration_minutes):
    """
    Log an exercise in the CSV file.
    """
    now = datetime.datetime.now()
    date_string = now.strftime("%Y-%m-%d")
    time_string = now.strftime("%H:%M:%S")
    with open(csv_filename, mode='a', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(
            [date_string, time_string, exercise_name, '', '', duration_minutes])


def prompt_log_food():
    """
    Prompt the user to log a meal.
    """
    meal_name = input("Enter meal name: ")
    calories = input("Enter calories: ")
    log_food('food_log.csv', meal_name, calories)
    print("Meal logged successfully.")


def prompt_log_fast():
    """
    Prompt the user to log an intermittent fast.
    """
    fast_start_time_str = input(
        "Enter fast start time (format: YYYY-MM-DD HH:MM:SS): ")
    fast_start_time = datetime.datetime.strptime(
        fast_start_time_str, "%Y-%m-%d %H:%M:%S")
    fast_end_time_str = input(
        "Enter fast end time (format: YYYY-MM-DD HH:MM:SS): ")
    fast_end_time = datetime.datetime.strptime(
        fast_end_time_str, "%Y-%m-%d %H:%M:%S")
    log_fast('fast_log.csv', fast_start_time, fast_end_time)
    print("Fast logged successfully.")


def prompt_log_exercise():
    """
    Prompt the user to log an exercise.
    """
    exercise_name = input("Enter exercise name: ")
    duration_minutes = input("Enter duration (in minutes): ")
    log_exercise('exercise_log.csv', exercise_name, duration_minutes)
    print("Exercise logged successfully.")


# Main loop
while True:
    print("Enter a command:")
    print("  1. Log food")
    print("  2. Log intermittent fast")
    print("  3. Log exercise")
    print("  4. Quit")
    choice = input("Enter choice (1-4): ")
    if choice == '1':
        prompt_log_food()
    elif choice == '2':
        prompt_log_fast()
    elif choice == '3':
        prompt_log_exercise()
    elif choice == '4':
        break
    else:
        print("Invalid choice. Please try again.")
