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