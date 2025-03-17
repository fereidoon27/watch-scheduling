import json
import os
from collections import defaultdict

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

def save_schedule(schedule):
    with open('schedule.json', 'w') as file:
        json.dump(schedule, file, indent=4)
        file.write('\n')
    
    # Display schedule overview
    display_schedule_overview(schedule)

def display_schedule_overview(schedule):
    days = ['sat', 'sun', 'mon', 'tue', 'wed', 'thu', 'fri']
    day_labels = {'sat': 'Sat', 'sun': 'Sun', 'mon': 'Mon', 'tue': 'Tue', 'wed': 'Wed', 'thu': 'Thu', 'fri': 'Fri'}
    
    # Calculate the maximum name length for formatting
    max_name_length = max(len(entry['name']) for entry in schedule.values())
    max_name_length = max(max_name_length, 8)  # Ensure minimum width for column headers
    
    # Print header with a nice box
    print("\n" + "╔" + "═"*48 + "╗")
    print("║" + "          WEEKLY SCHEDULE OVERVIEW           " + "║")
    print("╠" + "═"*48 + "╣")
    
    # Print schedule table
    header = f"║ {'DAY':<5} │ {'DAY SHIFT':<{max_name_length}} │ {'NIGHT SHIFT':<{max_name_length}} ║"
    print(header)
    print("╠" + "═"*5 + "═╪═" + "═"*max_name_length + "═╪═" + "═"*max_name_length + "═╣")
    
    for day in days:
        day_person = schedule.get(f"{day}_day", {}).get('name', 'N/A')
        night_person = schedule.get(f"{day}_night", {}).get('name', 'N/A')
        print(f"║ {day_labels[day]:<5} │ {day_person:<{max_name_length}} │ {night_person:<{max_name_length}} ║")
    
    print("╠" + "═"*5 + "═╪═" + "═"*max_name_length + "═╪═" + "═"*max_name_length + "═╣")
    
    # Calculate and print shift distribution summary
    shift_counts = defaultdict(lambda: {'day': 0, 'night': 0, 'total': 0})
    
    for time_block, assignment in schedule.items():
        name = assignment['name']
        if '_day' in time_block:
            shift_counts[name]['day'] += 1
        else:
            shift_counts[name]['night'] += 1
        shift_counts[name]['total'] += 1
    
    # Print shift distribution
    print("║" + "          SHIFT DISTRIBUTION SUMMARY          " + "║")
    print("╠" + "═"*max_name_length + "═╤═" + "═"*7 + "═╤═" + "═"*7 + "═╤═" + "═"*7 + "═╣")
    print(f"║ {'NAME':<{max_name_length}} │ {'DAY':<7} │ {'NIGHT':<7} │ {'TOTAL':<7} ║")
    print("╠" + "═"*max_name_length + "═╪═" + "═"*7 + "═╪═" + "═"*7 + "═╪═" + "═"*7 + "═╣")
    
    for name, counts in sorted(shift_counts.items(), key=lambda x: x[0]):
        day = str(counts['day'])
        night = str(counts['night'])
        total = str(counts['total'])
        print(f"║ {name:<{max_name_length}} │ {day:^7} │ {night:^7} │ {total:^7} ║")
    
    print("╚" + "═"*max_name_length + "═╧═" + "═"*7 + "═╧═" + "═"*7 + "═╧═" + "═"*7 + "═╝")

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