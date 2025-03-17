# Phone Scheduler Project

This project consists of several components that work together to create a scheduling system for phone numbers, which is stored and updated in a `phone.txt` file. The main components are:

1. `generate-scheduling.py` — Generates a scheduling file (`schedule.json`), mapping names to phone numbers.
2. `map.name` — A text file containing a list of names and associated phone numbers.
3. `schedule.json` — A scheduling file that is dynamically created by the `generate-scheduling.py` script.
4. `phone-reader.py` — A script that continuously checks the schedule and updates the `phone.txt` file based on the current time block.
5. `phone.txt` — A text file that is updated with the phone number based on the schedule, used by another project for phone lookup.

---

## Project Overview

The goal of this project is to generate a `phone.txt` file that is updated according to a schedule defined by `schedule.json`. The schedule specifies which phone number should be active during a particular time block (day or night) on each day of the week.

The process involves two primary steps:

1. **Generate Scheduling** (`generate-scheduling.py`): This script reads the phone number mappings from `map.name` and creates a schedule (`schedule.json`). You can choose to create the schedule manually by entering names or automatically based on the list of names.

2. **Update Phone File** (`phone-reader.py`): This script continuously monitors the current time and updates the `phone.txt` file with the correct phone number based on the current time block (e.g., `mon_day`, `wed_night`). It checks the schedule file every 5 minutes to update the `phone.txt` file.

---

## Project Components

### 1. `map.name`
This file contains a list of names and their corresponding phone numbers, separated by commas. Example:

```
ali,09123456789
reza,0917777
ak7,44334433
asghar,1234
mobin,9999999
roshan,00000000
elham,454545
```

This is used as the input for generating the schedule.

### 2. `generate-scheduling.py`
This script generates the `schedule.json` file based on the mappings in `map.name`. It offers two modes of scheduling:

- **Manual Mode**: The script prompts the user to enter a name and phone number for each day and time period (day or night).
- **Automatic Mode**: The script automatically assigns names from the `map.name` file to the schedule.

**Usage**:
1. Run the script using Python:
   ```bash
   python generate-scheduling.py
   ```
2. Choose the scheduling mode (manual or automatic).
   ( if you choose the manual option, remember that the day means 12:00 AM to 12:00 PM and the night means 12:00 PM to 12:00 AM )

3. The script will generate the `schedule.json` file with the assigned schedule.

### 3. `schedule.json`
This is the scheduling file created by `generate-scheduling.py`. It stores the schedule for each day and time period. Example format:

```json
{
    "sat_day": {
        "name": "ali",
        "phone": "09123456789"
    },
    "sat_night": {
        "name": "reza",
        "phone": "0917777"
    }
}
```

### 4. `phone-reader.py`
This script runs as a background service, continuously checking the current time and updating the `phone.txt` file based on the schedule.

**Usage**:
1. Start the script:
   ```bash
   python phone-reader.py
   ```
2. The script will check every 5 minutes to see if the schedule has changed, and update `phone.txt` with the current phone number for that time block.

### 5. `phone.txt`
This is the output file that is updated by `phone-reader.py`. It contains the phone number for the current time block.

---

## How It Works

1. **Step 1: Generate the Schedule**  
   Run `generate-scheduling.py` to create a schedule (`schedule.json`) based on the names and phone numbers in `map.name`. You can choose to either input the schedule manually or let the script generate it automatically.

2. **Step 2: Update the Phone File**  
   Run `phone-reader.py` as a service. It checks the `schedule.json` file every 5 minutes to determine the current time block (day/night for a specific weekday) and updates `phone.txt` with the appropriate phone number.

3. **Step 3: Consume the `phone.txt` File**  
   Another project can then use `phone.txt` for phone number lookup, with the file being dynamically updated based on the schedule.

---

## Requirements

- Python 3.x
- Basic understanding of JSON and file handling in Python

You can install any required dependencies using `pip` if necessary.

---

## Running the Project

1. Prepare your `map.name` file with the list of names and phone numbers.
2. Generate the schedule using `generate-scheduling.py`.
3. Start `phone-reader.py` to monitor the schedule and update the phone file.
4. The `phone.txt` file will be updated according to the schedule defined in `schedule.json`.

---

## Notes

- Ensure that `schedule.json` is always in sync with the time and that `phone-reader.py` is running as a background process to keep `phone.txt` updated.
- If any errors occur while loading the schedule or updating the file, the script will log the error but continue running.
