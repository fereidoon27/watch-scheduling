#!/usr/bin/env python3
import json
import os
import re
from datetime import datetime, timedelta
import calendar

def load_map():
    """Load name-to-phone mapping from file"""
    map_file = 'map.name'
    mapping = {}
    if os.path.exists(map_file):
        with open(map_file, 'r') as file:
            for line in file:
                if ',' in line:
                    name, phone = line.strip().split(',')
                    mapping[name] = phone
    return mapping

def save_map(mapping):
    """Save name-to-phone mapping to file"""
    with open('map.name', 'w') as file:
        for name, phone in mapping.items():
            file.write(f"{name},{phone}\n")

def get_start_date():
    """Get start date from user input or default to today"""
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
    """Create schedule manually with user input"""
    # Get start date for the schedule
    start_date = get_start_date()
    end_date = calculate_end_date(start_date)
    
    # Create an empty schedule
    date_schedule = {}
    
    # Go through each day in the period and ask for assignments
    current_date = start_date
    while current_date <= end_date:
        date_str = current_date.strftime('%Y-%m-%d')
        weekday = current_date.strftime('%a').lower()
        weekday_full = current_date.strftime('%A')
        
        print(f"\n{current_date.strftime('%b %d')} ({weekday_full}):")
        
        # Ask for day shift
        day_person = input(f"  Day shift: Enter name: ")
        if day_person not in mapping:
            phone = input(f"  Phone number for {day_person}: ")
            mapping[day_person] = phone
        
        # Ask for night shift
        night_person = input(f"  Night shift: Enter name: ")
        if night_person not in mapping:
            phone = input(f"  Phone number for {night_person}: ")
            mapping[night_person] = phone
        
        # Add to schedule
        date_schedule[date_str] = {
            'weekday': weekday,
            'day': {'name': day_person, 'phone': mapping[day_person]},
            'night': {'name': night_person, 'phone': mapping[night_person]}
        }
        
        current_date += timedelta(days=1)
    
    save_map(mapping)
    save_schedule(date_schedule)
    save_date_info(start_date, end_date)
    display_schedule_with_dates(date_schedule, start_date, end_date)

def create_schedule_auto(mapping):
    """Create schedule automatically with fair distribution of shifts"""
    # Get start date for the schedule
    start_date = get_start_date()
    end_date = calculate_end_date(start_date)
    
    # Create the date-based schedule using a fair distribution approach
    date_schedule = create_fair_date_schedule(mapping, start_date, end_date)
    
    save_schedule(date_schedule)
    save_date_info(start_date, end_date)
    display_schedule_with_dates(date_schedule, start_date, end_date)

def create_fair_date_schedule(mapping, start_date, end_date):
    """Create a fair date-based schedule with equal distribution of shifts"""
    date_schedule = {}
    names = list(mapping.keys())
    
    # Calculate total days in the period
    total_days = (end_date - start_date).days + 1
    total_shifts = total_days * 2  # Each day has a day and night shift
    
    # Calculate ideal shifts per person
    shifts_per_person = total_shifts / len(names)
    print(f"\nFair Scheduling Analysis:")
    print(f"- Total days in period: {total_days}")
    print(f"- Total shifts to assign: {total_shifts}")
    print(f"- Team members: {len(names)}")
    print(f"- Target shifts per person: {shifts_per_person:.1f}\n")
    
    # Initialize shift counters
    shift_counts = {}
    for name in names:
        shift_counts[name] = {'day': 0, 'night': 0}
    
    # Create a systematic rotation with tracking
    day_index = 0
    night_index = len(names) // 2  # Start night shifts from halfway through the list
    
    # Create date-based schedule
    current_date = start_date
    while current_date <= end_date:
        date_str = current_date.strftime('%Y-%m-%d')
        weekday = current_date.strftime('%a').lower()
        
        # Get the next person for day shift
        day_person = names[day_index % len(names)]
        # Update their shift count
        shift_counts[day_person]['day'] += 1
        
        # For night shift, make sure it's a different person than day
        night_person = names[night_index % len(names)]
        # If same person assigned both shifts (can happen with small teams),
        # move to next person for night shift
        if night_person == day_person:
            night_index += 1
            night_person = names[night_index % len(names)]
        
        # Update night shift count
        shift_counts[night_person]['night'] += 1
        
        # Add to schedule
        date_schedule[date_str] = {
            'weekday': weekday,
            'day': {'name': day_person, 'phone': mapping[day_person]},
            'night': {'name': night_person, 'phone': mapping[night_person]}
        }
        
        # Move to next people in rotation for next day
        day_index += 1
        night_index += 1
        current_date += timedelta(days=1)
    
    # Analyze the distribution
    print("Shift distribution:")
    totals = []
    for name, counts in shift_counts.items():
        total = counts['day'] + counts['night']
        totals.append(total)
        print(f"{name}: {counts['day']} day shifts, {counts['night']} night shifts (Total: {total})")
    
    # Check fairness
    if max(totals) - min(totals) <= 1:
        print("\nThe schedule is fair! Maximum difference is 1 shift.")
    else:
        print(f"\nWarning: The schedule has a difference of {max(totals) - min(totals)} shifts.")
        print("Consider having more team members or a different length scheduling period.")
    
    return date_schedule

def save_schedule(date_schedule):
    """Save schedule to JSON file"""
    with open('schedule.json', 'w') as file:
        json.dump(date_schedule, file, indent=4)
        file.write('\n')

def save_date_info(start_date, end_date):
    """Save date information in JSON format for reference"""
    date_info = {
        "start_date": start_date.strftime('%Y-%m-%d'),
        "end_date": end_date.strftime('%Y-%m-%d')
    }
    
    # Save as a JSON for easier parsing
    with open('date_info.json', 'w') as file:
        json.dump(date_info, file, indent=4)

def ansi_to_html(ansi_text):
    """Convert ANSI color codes to HTML"""
    # Define mapping from ANSI color codes to HTML/CSS colors
    color_map = {
        '\033[1;36m': '<span style="color:#00CCCC; font-weight:bold">',  # Cyan, bold
        '\033[1;33m': '<span style="color:#CCCC00; font-weight:bold">',  # Yellow, bold
        '\033[1;34m': '<span style="color:#0000CC; font-weight:bold">',  # Blue, bold
        '\033[1;32m': '<span style="color:#00CC00; font-weight:bold">',  # Green, bold
        '\033[1;35m': '<span style="color:#CC00CC; font-weight:bold">',  # Purple, bold
        '\033[0m': '</span>'  # Reset to default
    }
    
    # Replace ANSI codes with HTML spans
    html_text = ansi_text
    for ansi_code, html_tag in color_map.items():
        html_text = html_text.replace(ansi_code, html_tag)
    
    # Handle newlines
    html_text = html_text.replace('\n', '<br>')
    
    return html_text

def save_schedule_as_html(output_text, start_date):
    """Save the schedule output as HTML file"""
    # Format filename with date
    filename = f"schedule_{start_date.strftime('%Y-%m-%d')}.html"
    
    # Create HTML document
    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shift Schedule {start_date.strftime('%B %Y')}</title>
    <style>
        body {{
            font-family: 'Courier New', monospace;
            background-color: #f5f5f5;
            line-height: 1.5;
            padding: 15px;
            max-width: 800px;
            margin: 0 auto;
        }}
        pre {{
            white-space: pre-wrap;
            background-color: #fff;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            overflow-x: auto;
        }}
        h1 {{
            color: #00CCCC;
            text-align: center;
        }}
        @media (max-width: 600px) {{
            body {{
                padding: 10px;
                font-size: 14px;
            }}
        }}
    </style>
</head>
<body>
    <h1>Phone On-Call Schedule</h1>
    <pre>{ansi_to_html(output_text)}</pre>
</body>
</html>
"""
    
    # Write HTML to file
    with open(filename, 'w') as file:
        file.write(html_content)
    
    print(f"\nSchedule saved as {filename}")
    
    return filename

def display_schedule_with_dates(date_schedule, start_date, end_date):
    """Display schedule with real dates for the specified date range"""
    # ANSI color codes
    HEADER = '\033[1;36m'  # Cyan, bold
    DAY = '\033[1;33m'     # Yellow, bold
    NIGHT = '\033[1;34m'   # Blue, bold
    NAME = '\033[1;32m'    # Green, bold
    DATE = '\033[1;35m'    # Purple, bold for dates
    RESET = '\033[0m'      # Reset to default
    
    # Initialize a string to collect the entire output
    output_text = ""
    
    month_str = start_date.strftime("%B %Y") + " to " + end_date.strftime("%B %Y")
    header_line = f"\n{HEADER}MONTHLY SCHEDULE{RESET}"
    output_text += header_line
    print(header_line)
    
    underline = f"{HEADER}================{RESET}"
    output_text += f"\n{underline}"
    print(underline)
    
    date_range = f"{DATE}{month_str}{RESET}\n"
    output_text += f"\n{date_range}"
    print(date_range)
    
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
            
            output_text += f"\n{line}"
            print(line)
    
    # Print summary of shift distribution
    summary_header = f"\n{HEADER}SHIFT SUMMARY{RESET}"
    output_text += summary_header
    print(summary_header)
    
    summary_underline = f"{HEADER}============={RESET}"
    output_text += f"\n{summary_underline}"
    print(summary_underline)
    
    # Find max name length for summary alignment
    max_name_len = max(len(person) for person in shift_counts.keys()) if shift_counts else 0
    
    for person, counts in shift_counts.items():
        total = counts['day'] + counts['night']
        day_count = f"{DAY}{counts['day']} day shifts{RESET}"
        night_count = f"{NIGHT}{counts['night']} night shifts{RESET}"
        
        # Ensure consistent alignment with colon
        summary_line = f"{NAME}{person.ljust(max_name_len)}{RESET}:  {day_count.ljust(20)}, {night_count.ljust(20)} (Total: {total})"
        output_text += f"\n{summary_line}"
        print(summary_line)
    
    # Save the output to an HTML file
    save_schedule_as_html(output_text, start_date)

def main():
    mapping = load_map()
    
    print(f"{'-'*50}")
    print("Phone Scheduler Generator")
    print(f"{'-'*50}")
    
    print("\nThis program will create a schedule for on-call duty.")
    print("The schedule will include a full month of assignments.")
    print("The output will also be saved as a colorful HTML file for mobile viewing.\n")
    
    choice = input("Set scheduling file: 1. Manually 2. Automatically\nEnter choice: ")
    if choice == '1':
        create_schedule_manual(mapping)
    elif choice == '2':
        create_schedule_auto(mapping)
    else:
        print("Invalid choice")

if __name__ == "__main__":
    main()