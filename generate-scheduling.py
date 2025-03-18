import json
import os
from datetime import datetime, timedelta

def load_map():
    map_file = 'map.name'
    mapping = {}
    if os.path.exists(map_file):
        with open(map_file, 'r') as file:
            for line in file:
                name, phone = line.strip().split(',')
                mapping[name] = phone
    return mapping

def save_map(mapping):
    with open('map.name', 'w') as file:
        for name, phone in mapping.items():
            file.write(f"{name},{phone}\n")

def get_start_date():
    while True:
        date_input = input("Enter start date (YYYY-MM-DD) or press Enter for today: ")
        if not date_input.strip():
            return datetime.now().date()  # Use today if nothing entered
        
        try:
            # Parse the input date
            return datetime.strptime(date_input, "%Y-%m-%d").date()
        except ValueError:
            print("Invalid date format. Please use YYYY-MM-DD format.")

def calculate_end_date(start_date):
    """Calculate the end date (one full month from start date)"""
    # Get the first day of the next month
    if start_date.month == 12:
        next_month = datetime(start_date.year + 1, 1, 1).date()
    else:
        next_month = datetime(start_date.year, start_date.month + 1, 1).date()
    
    # Find the day before the first day of the month after next
    if next_month.month == 12:
        end_date = datetime(next_month.year + 1, 1, 1).date() - timedelta(days=1)
    else:
        end_date = datetime(next_month.year, next_month.month + 1, 1).date() - timedelta(days=1)
    
    return end_date

def create_schedule_manual(mapping):
    # Get start date for the schedule
    start_date = get_start_date()
    end_date = calculate_end_date(start_date)
    
    # Create weekly pattern first
    weekly_pattern = {}
    days = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri']
    periods = ['day', 'night']

    for day in days:
        for period in periods:
            name = input(f"{day}, {period}: Enter name: ")
            if name not in mapping:
                phone = input(f"Phone number for {name}: ")
                mapping[name] = phone
            weekly_pattern[f"{day}_{period}"] = {'name': name, 'phone': mapping[name]}

    # Now create the date-based schedule
    date_schedule = {}
    current_date = start_date
    
    while current_date <= end_date:
        weekday = current_date.strftime('%a').lower()
        date_str = current_date.strftime('%Y-%m-%d')
        
        date_schedule[date_str] = {
            'weekday': weekday,
            'day': weekly_pattern.get(f"{weekday}_day"),
            'night': weekly_pattern.get(f"{weekday}_night")
        }
        
        current_date += timedelta(days=1)

    save_map(mapping)
    save_schedule(date_schedule, weekly_pattern)
    save_date_info(start_date, end_date)
    display_schedule_with_dates(date_schedule, weekly_pattern, start_date, end_date)

def create_schedule_auto(mapping):
    # Get start date for the schedule
    start_date = get_start_date()
    end_date = calculate_end_date(start_date)
    
    # Create the weekly pattern first
    weekly_pattern = {}
    days = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri']
    periods = ['day', 'night']
    names = list(mapping.keys())
    
    # Calculate offset for night shift (about halfway through the list)
    night_offset = len(names) // 2
    
    day_index = 0
    night_index = night_offset  # Start night shifts from a different position
    
    for day in days:
        # Assign day shift (using one rotation)
        day_name = names[day_index % len(names)]
        weekly_pattern[f"{day}_day"] = {'name': day_name, 'phone': mapping[day_name]}
        day_index += 1
        
        # Assign night shift (using a different rotation)
        night_name = names[night_index % len(names)]
        weekly_pattern[f"{day}_night"] = {'name': night_name, 'phone': mapping[night_name]}
        night_index += 1

    # Now create the date-based schedule
    date_schedule = {}
    current_date = start_date
    
    while current_date <= end_date:
        weekday = current_date.strftime('%a').lower()
        date_str = current_date.strftime('%Y-%m-%d')
        
        date_schedule[date_str] = {
            'weekday': weekday,
            'day': weekly_pattern.get(f"{weekday}_day"),
            'night': weekly_pattern.get(f"{weekday}_night")
        }
        
        current_date += timedelta(days=1)

    # Save both the weekly pattern and date-based schedule
    save_schedule(date_schedule, weekly_pattern)
    save_date_info(start_date, end_date)
    display_schedule_with_dates(date_schedule, weekly_pattern, start_date, end_date)

def save_schedule(date_schedule, weekly_pattern):
    # Create a combined structure with both date-based and pattern-based schedules
    combined_schedule = {
        "date_schedule": date_schedule,
        "weekly_pattern": weekly_pattern
    }
    
    with open('schedule.json', 'w') as file:
        json.dump(combined_schedule, file, indent=4)
        file.write('\n')
        
def save_date_info(start_date, end_date):
    """Save date information to a file for reference"""
    date_info = {
        "start_date": start_date.strftime('%Y-%m-%d'),
        "end_date": end_date.strftime('%Y-%m-%d')
    }
    
    # Save as a JSON for easier parsing
    with open('date_info.json', 'w') as file:
        json.dump(date_info, file, indent=4)
    
    # Also save as plain text for backward compatibility
    with open('date_info.txt', 'w') as file:
        file.write(f"Start: {start_date.strftime('%Y-%m-%d')}\n")
        file.write(f"End: {end_date.strftime('%Y-%m-%d')}\n")

def display_schedule(schedule):
    # ANSI color codes
    HEADER = '\033[1;36m'  # Cyan, bold
    DAY = '\033[1;33m'     # Yellow, bold
    NIGHT = '\033[1;34m'   # Blue, bold
    NAME = '\033[1;32m'    # Green, bold
    RESET = '\033[0m'      # Reset to default
    
    print("\n" + HEADER + "WEEKLY TIMELINE" + RESET)
    print(HEADER + "===============" + RESET + "\n")
    
    days = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri']
    day_names = {
        'sat': 'Saturday',
        'sun': 'Sunday',
        'mon': 'Monday',
        'tue': 'Tuesday',
        'wed': 'Wednesday',
        'thu': 'Thursday',
        'fri': 'Friday'
    }
    
    # Collect all names to find max length for alignment
    all_names = set()
    
    for day in days:
        day_person = schedule.get(f"{day}_day", {}).get('name', 'N/A')
        night_person = schedule.get(f"{day}_night", {}).get('name', 'N/A')
        all_names.add(day_person)
        all_names.add(night_person)
    
    # Find max name length for padding
    max_name_len = max(len(name) for name in all_names)
    
    # Initialize shift counts
    shift_counts = {}
    
    for day in days:
        day_person = schedule.get(f"{day}_day", {}).get('name', 'N/A')
        night_person = schedule.get(f"{day}_night", {}).get('name', 'N/A')
        
        # Update shift counts
        if day_person != 'N/A':
            shift_counts[day_person] = shift_counts.get(day_person, {'day': 0, 'night': 0})
            shift_counts[day_person]['day'] += 1
            
        if night_person != 'N/A':
            shift_counts[night_person] = shift_counts.get(night_person, {'day': 0, 'night': 0})
            shift_counts[night_person]['night'] += 1
        
        # Format with consistent padding
        day_label = f"{day_names[day]}:"
        day_section = f"[{DAY}Day:{RESET} {NAME}{day_person.ljust(max_name_len)}{RESET}]"
        night_section = f"[{NIGHT}Night:{RESET} {NAME}{night_person.ljust(max_name_len)}{RESET}]"
        
        print(f"{day_label:<12} {day_section}  |  {night_section}")
    
    # Print summary of shift distribution
    print("\n" + HEADER + "SHIFT SUMMARY" + RESET)
    print(HEADER + "=============" + RESET)
    
    # Find max name length for summary alignment
    max_name_len = max(len(person) for person in shift_counts.keys())
    
    for person, counts in shift_counts.items():
        total = counts['day'] + counts['night']
        day_count = f"{DAY}{counts['day']} day shifts{RESET}"
        night_count = f"{NIGHT}{counts['night']} night shifts{RESET}"
        print(f"{NAME}{person.ljust(max_name_len)}{RESET}: {day_count.ljust(20)}, {night_count.ljust(20)} (Total: {total})")

def display_schedule_with_dates(date_schedule, weekly_pattern, start_date, end_date):
    """Display schedule with real dates for the specified date range"""
    # ANSI color codes
    HEADER = '\033[1;36m'  # Cyan, bold
    DAY = '\033[1;33m'     # Yellow, bold
    NIGHT = '\033[1;34m'   # Blue, bold
    NAME = '\033[1;32m'    # Green, bold
    DATE = '\033[1;35m'    # Purple, bold for dates
    RESET = '\033[0m'      # Reset to default
    
    month_str = start_date.strftime("%B %Y") + " to " + end_date.strftime("%B %Y")
    print(f"\n{HEADER}MONTHLY SCHEDULE{RESET}")
    print(f"{HEADER}================{RESET}")
    print(f"{DATE}{month_str}{RESET}\n")
    
    # Collect all names to find max length for alignment
    all_names = set()
    for date_info in date_schedule.values():
        if 'day' in date_info and date_info['day'] and 'name' in date_info['day']:
            all_names.add(date_info['day']['name'])
        if 'night' in date_info and date_info['night'] and 'name' in date_info['night']:
            all_names.add(date_info['night']['name'])
    
    # Find max name length for padding
    max_name_len = max(len(name) for name in all_names) if all_names else 0
    
    # Calculate dates for each day
    shift_counts = {}
    
    # Find maximum weekday length for padding
    max_weekday_len = 9  # "Wednesday" is the longest day name
    
    # Sort the dates
    sorted_dates = sorted(date_schedule.keys())
    
    # Create a template with fixed column positions
    date_width = 6      # "Mar 18"
    weekday_width = 11  # "(Wednesday)"
    day_label_width = 8  # "[Day:   "
    night_label_width = 9  # "[Night: "
    
    for date_str in sorted_dates:
        date_info = date_schedule[date_str]
        
        if 'day' in date_info and date_info['day'] and 'night' in date_info and date_info['night']:
            day_person = date_info['day']['name']
            night_person = date_info['night']['name']
            
            # Update shift counts
            if day_person not in shift_counts:
                shift_counts[day_person] = {'day': 0, 'night': 0}
            shift_counts[day_person]['day'] += 1
            
            if night_person not in shift_counts:
                shift_counts[night_person] = {'day': 0, 'night': 0}
            shift_counts[night_person]['night'] += 1
            
            # Parse the date
            current_date = datetime.strptime(date_str, '%Y-%m-%d').date()
            
            # Format date components separately with fixed widths
            month_abbr = current_date.strftime('%b')
            day_num = current_date.day
            weekday_full = current_date.strftime('%A')
            
            # Format day with leading zero only for single-digit days
            if day_num < 10:
                date_part = f"{DATE}{month_abbr} 0{day_num}{RESET}"
            else:
                date_part = f"{DATE}{month_abbr} {day_num}{RESET}"
                
            weekday_part = f"({weekday_full})"
            
            # Build the line with fixed-width columns
            line = date_part.ljust(date_width + len(DATE) + len(RESET))  # Account for color codes
            line += " " + weekday_part.ljust(weekday_width)
            line += " " + f"[{DAY}Day:{RESET}   "
            line += f"{NAME}{day_person.ljust(max_name_len)}{RESET}]"
            line += "  |  "
            line += f"[{NIGHT}Night:{RESET} "
            line += f"{NAME}{night_person.ljust(max_name_len)}{RESET}]"
            
            print(line)
    
    # Print summary of shift distribution
    print("\n" + HEADER + "SHIFT SUMMARY" + RESET)
    print(HEADER + "=============" + RESET)
    
    # Find max name length for summary alignment
    max_name_len = max(len(person) for person in shift_counts.keys()) if shift_counts else 0
    
    for person, counts in shift_counts.items():
        total = counts['day'] + counts['night']
        day_count = f"{DAY}{counts['day']} day shifts{RESET}"
        night_count = f"{NIGHT}{counts['night']} night shifts{RESET}"
        
        # Ensure consistent alignment with colon
        print(f"{NAME}{person.ljust(max_name_len)}{RESET}:  {day_count.ljust(20)}, {night_count.ljust(20)} (Total: {total})")

def main():
    mapping = load_map()
    
    print(f"{'-'*50}")
    print("Phone Scheduler Generator")
    print(f"{'-'*50}")
    
    print("\nThis program will create a schedule for on-call duty.")
    print("The schedule will include a full month of assignments.\n")
    
    choice = input("Set scheduling file: 1. Manually 2. Automatically\nEnter choice: ")
    if choice == '1':
        create_schedule_manual(mapping)
    elif choice == '2':
        create_schedule_auto(mapping)
    else:
        print("Invalid choice")

if __name__ == "__main__":
    main()