#!/usr/bin/env python3
import json
import os
from datetime import datetime

# File paths
SCHEDULE_FILE = 'schedule.json'
MAP_FILE = 'map.name'

def load_schedule():
    """Load the schedule from the JSON file."""
    try:
        with open(SCHEDULE_FILE, 'r') as file:
            return json.load(file)
    except FileNotFoundError:
        print(f"Error: {SCHEDULE_FILE} not found!")
        return {}
    except json.JSONDecodeError:
        print(f"Error: {SCHEDULE_FILE} contains invalid JSON!")
        return {}

def save_schedule(schedule):
    """Save the schedule to the JSON file."""
    with open(SCHEDULE_FILE, 'w') as file:
        json.dump(schedule, file, indent=4)
    print(f"Schedule saved to {SCHEDULE_FILE}")

def update_map_file(name, phone):
    """Update map.name file with a new name-phone mapping if it doesn't exist."""
    mappings = {}
    
    # Read existing mappings
    if os.path.exists(MAP_FILE):
        with open(MAP_FILE, 'r') as file:
            for line in file:
                if ',' in line:
                    n, p = line.strip().split(',', 1)
                    mappings[n] = p
    
    # Add new mapping if it doesn't exist
    if name not in mappings:
        mappings[name] = phone
        
        # Write updated mappings
        with open(MAP_FILE, 'w') as file:
            for n, p in mappings.items():
                file.write(f"{n},{p}\n")

def get_unique_names(schedule):
    """Extract all unique names from the schedule."""
    names = set()
    for date_info in schedule.values():
        if 'day' in date_info and 'name' in date_info['day']:
            names.add(date_info['day']['name'])
        if 'night' in date_info and 'name' in date_info['night']:
            names.add(date_info['night']['name'])
    return sorted(list(names))

def get_person_schedule(schedule, name):
    """Get all shifts assigned to a person."""
    shifts = []
    for date, date_info in schedule.items():
        weekday = date_info.get('weekday', '')
        
        if 'day' in date_info and date_info['day'].get('name') == name:
            shifts.append((date, weekday, 'Day Shift'))
            
        if 'night' in date_info and date_info['night'].get('name') == name:
            shifts.append((date, weekday, 'Night Shift'))
            
    return shifts

def format_date(date_str):
    """Format a date string to be more readable."""
    try:
        date_obj = datetime.strptime(date_str, "%Y-%m-%d")
        return date_obj.strftime("%Y-%m-%d (%A)")
    except ValueError:
        return date_str

def display_menu(options, title=None):
    """Display a menu with numbered options."""
    if title:
        print(f"\n{title}")
    
    for i, option in enumerate(options, 1):
        print(f"{i}- {option}")
    
    print()  # Empty line for better readability

def get_user_choice(prompt, options, allow_multiple=False):
    """Get the user's choice from a menu."""
    while True:
        choice = input(prompt).strip()
        
        if allow_multiple:
            try:
                choices = [int(c.strip()) for c in choice.split(',')]
                if all(1 <= c <= len(options) for c in choices):
                    return choices
                print(f"Invalid choices. Please enter numbers between 1 and {len(options)}.")
            except ValueError:
                print("Invalid input. Please enter comma-separated numbers.")
        else:
            try:
                choice = int(choice)
                if 1 <= choice <= len(options):
                    return choice
                print(f"Invalid choice. Please enter a number between 1 and {len(options)}.")
            except ValueError:
                print("Invalid input. Please enter a number.")

def main():
    # Load the schedule
    schedule = load_schedule()
    if not schedule:
        print("No schedule data available. Exiting.")
        return
    
    # Get all unique names from the schedule
    names = get_unique_names(schedule)
    if not names:
        print("No names found in the schedule. Exiting.")
        return
    
    # Display menu of names
    display_menu(names, "Available Staff:")
    
    # Get user's choice of person
    choice = get_user_choice("Select a person (enter number): ", names)
    selected_name = names[choice - 1]
    
    # Get all shifts for the selected person
    person_shifts = get_person_schedule(schedule, selected_name)
    if not person_shifts:
        print(f"No shifts found for {selected_name}. Exiting.")
        return
    
    # Display menu of shifts
    shift_descriptions = [f"{format_date(date)}: {shift_type}" for date, weekday, shift_type in person_shifts]
    display_menu(shift_descriptions, f"{selected_name}'s Schedule:")
    
    # Get user's choices of shifts to modify
    shift_choices = get_user_choice("Select shifts to reassign (comma-separated numbers, e.g., 1,3,5): ", shift_descriptions, allow_multiple=True)
    selected_shifts = [person_shifts[i - 1] for i in shift_choices]
    
    # Display menu of other names for replacement
    other_names = [name for name in names if name != selected_name]
    display_menu(other_names, "Select replacement:")
    
    # Get user's choice of replacement
    replacement_choice = get_user_choice("Select a replacement (enter number): ", other_names)
    replacement_name = other_names[replacement_choice - 1]
    
    # Find the phone number for the replacement
    replacement_phone = None
    for date_info in schedule.values():
        if 'day' in date_info and date_info['day'].get('name') == replacement_name:
            replacement_phone = date_info['day'].get('phone')
            break
        if 'night' in date_info and date_info['night'].get('name') == replacement_name:
            replacement_phone = date_info['night'].get('phone')
            break
    
    if not replacement_phone:
        replacement_phone = input(f"Phone number for {replacement_name}: ")
        update_map_file(replacement_name, replacement_phone)
    
    # Modify the schedule
    modified_count = 0
    for date, _, shift_type in selected_shifts:
        period = 'day' if shift_type == 'Day Shift' else 'night'
        
        if date in schedule and period in schedule[date]:
            schedule[date][period]['name'] = replacement_name
            schedule[date][period]['phone'] = replacement_phone
            modified_count += 1
    
    # Save the modified schedule
    if modified_count > 0:
        save_schedule(schedule)
        print(f"Successfully reassigned {modified_count} shift(s) from {selected_name} to {replacement_name}.")
    else:
        print("No shifts were modified.")

if __name__ == "__main__":
    main()