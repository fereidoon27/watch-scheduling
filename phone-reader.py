import json
from datetime import datetime
import time
import os

# Use paths relative to the script location
script_dir = os.path.dirname(os.path.abspath(__file__))
SCHEDULE_FILE = os.path.join(script_dir, 'schedule.json')
PHONE_FILE = os.path.join(script_dir, 'phone.txt')
CHECK_INTERVAL = 3000  # Check every 50 minutes

# Function to load the schedule
def load_schedule():
    with open(SCHEDULE_FILE, 'r') as file:
        return json.load(file)

# Function to determine the current date and time block
def get_current_time_info():
    now = datetime.now()
    current_date = now.strftime('%Y-%m-%d')
    
    # Determine if it's day or night
    # "day" is 12:00 PM to 11:59 PM, "night" is 12:00 AM to 11:59 AM
    time_block = 'day' if 12 <= now.hour < 24 else 'night'
    
    return current_date, time_block

# Function to update the phone.txt file
def update_phone_file(phone_number):
    with open(PHONE_FILE, 'w') as file:
        file.write(phone_number.strip() + '\n')

# Main function to check the schedule and update the phone file
def main():
    while True:
        try:
            schedule = load_schedule()
            current_date, time_block = get_current_time_info()
            
            if current_date in schedule:
                if time_block in schedule[current_date]:
                    phone_number = schedule[current_date][time_block]['phone']
                    name = schedule[current_date][time_block]['name']
                    update_phone_file(phone_number)
                    print(f"Updated phone.txt with: {phone_number} ({name}) for {current_date}, {time_block}")
                else:
                    print(f"No schedule found for {current_date}, {time_block}")
            else:
                print(f"No schedule found for current date: {current_date}")
        except Exception as e:
            print(f"Error occurred: {e}")

        time.sleep(CHECK_INTERVAL)

if __name__ == "__main__":
    main()