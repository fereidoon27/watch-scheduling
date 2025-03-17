import json
from datetime import datetime
import time

SCHEDULE_FILE = './schedule.json'
PHONE_FILE = './phone.txt'
CHECK_INTERVAL = 5  # 3000 for Check every 50 minutes

# Function to load the schedule
def load_schedule():
    with open(SCHEDULE_FILE, 'r') as file:
        return json.load(file)

# Function to determine the current time block
def get_current_time_block():
    now = datetime.now()
    weekday = now.strftime('%a').lower()  # e.g., sat, sun, mon
    hour = now.hour

    # Determine if it's day or night
    time_block = 'day' if 12 <= hour < 24 else 'night'
    return f"{weekday}_{time_block}"

# Function to update the phone.txt file
def update_phone_file(phone_number):
    with open(PHONE_FILE, 'w') as file:
        file.write(phone_number.strip() + '\n')

# Main function to check the schedule and update the phone file
def main():
    while True:
        try:
            schedule = load_schedule()
            current_time_block = get_current_time_block()

            if current_time_block in schedule:
                phone_number = schedule[current_time_block]['phone']
                update_phone_file(phone_number)
                print(f"Updated phone.txt with: {phone_number}")
            else:
                print("No schedule found for current time block")
        except Exception as e:
            print(f"Error occurred: {e}")

        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()
