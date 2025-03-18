import json
import os

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

def create_schedule_manual(mapping):
    schedule = {}
    days = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri']
    periods = ['day', 'night']

    for day in days:
        for period in periods:
            name = input(f"{day}, {period}: Enter name: ")
            if name not in mapping:
                phone = input(f"Phone number for {name}: ")
                mapping[name] = phone
            schedule[f"{day}_{period}"] = {'name': name, 'phone': mapping[name]}

    save_map(mapping)
    save_schedule(schedule)
    display_schedule(schedule)

def create_schedule_auto(mapping):
    schedule = {}
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
        schedule[f"{day}_day"] = {'name': day_name, 'phone': mapping[day_name]}
        day_index += 1
        
        # Assign night shift (using a different rotation)
        night_name = names[night_index % len(names)]
        schedule[f"{day}_night"] = {'name': night_name, 'phone': mapping[night_name]}
        night_index += 1

    save_schedule(schedule)
    display_schedule(schedule)

def save_schedule(schedule):
    with open('schedule.json', 'w') as file:
        json.dump(schedule, file, indent=4)
        file.write('\n')
        
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
    
    # Calculate shift counts for summary
    shift_counts = {}
    
    # Collect all names to find max length for alignment
    all_names = set()
    for day in days:
        day_person = schedule.get(f"{day}_day", {}).get('name', 'N/A')
        night_person = schedule.get(f"{day}_night", {}).get('name', 'N/A')
        all_names.add(day_person)
        all_names.add(night_person)
    
    # Find max name length for padding
    max_name_len = max(len(name) for name in all_names)
    
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

def main():
    mapping = load_map()
    choice = input("Set scheduling file: 1. Manually 2. Automatically\nEnter choice: ")
    if choice == '1':
        create_schedule_manual(mapping)
    elif choice == '2':
        create_schedule_auto(mapping)
    else:
        print("Invalid choice")

if __name__ == "__main__":
    main()