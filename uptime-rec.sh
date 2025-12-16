#!/bin/bash

# Path to the record file
RECORD_FILE="/home/migara/.uptime_rec.txt"

# Ensure the file exists
touch "$RECORD_FILE"

# Get current uptime in pretty format (e.g., "up 3 weeks, 1 day, 9 hours, 18 minutes")
CURRENT_UPTIME=$(uptime -p)

# Function to convert "up x weeks, y days, z hours, w minutes" → total minutes
convert_uptime_to_minutes() {
    local up_string="$1"
    local total=0

    [[ $up_string =~ ([0-9]+)\ weeks? ]] && (( total += ${BASH_REMATCH[1]} * 10080 ))  # 7*24*60
    [[ $up_string =~ ([0-9]+)\ days? ]] && (( total += ${BASH_REMATCH[1]} * 1440 ))    # 24*60
    [[ $up_string =~ ([0-9]+)\ hours? ]] && (( total += ${BASH_REMATCH[1]} * 60 ))
    [[ $up_string =~ ([0-9]+)\ minutes? ]] && (( total += ${BASH_REMATCH[1]} ))

    echo "$total"
}

# Read recorded uptime (default to empty if file is blank)
RECORDED_UPTIME=$(<"$RECORD_FILE")

# Convert both uptimes to minutes
CURRENT_MINUTES=$(convert_uptime_to_minutes "$CURRENT_UPTIME")
RECORDED_MINUTES=$(convert_uptime_to_minutes "$RECORDED_UPTIME")

# Compare and update if current is greater
if [[ "$CURRENT_MINUTES" -gt "$RECORDED_MINUTES" ]]; then
    echo "$CURRENT_UPTIME" > "$RECORD_FILE"
    echo "Updated Uptime Record		$CURRENT_UPTIME"
else
    REC=$(cat $RECORD_FILE)
    echo "Current Uptime	  		$CURRENT_UPTIME"
    echo "Uptime Record			$REC" 
fi
