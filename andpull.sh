#!/bin/bash

# --- Configuration ---
LOCAL_DIR="/home/k/script/adb/data/"

# Command to list potential storage directories on the Android device
# We look in /storage/ and /mnt/ for potential mounts
FIND_CMD="ls -d /storage/*/ /mnt/*/ 2>/dev/null"

# --- Script Start ---

#already did this ###mkdir -p "${LOCAL_DIR}"
echo "Local destination directory: ${LOCAL_DIR}"

# 1. Use adb shell to run the find command remotely and store the output
# We use 'tr' to convert newline characters into spaces for easy iteration in bash
REMOTE_DIRS=$(adb shell "${FIND_CMD}" | tr '\n' ' ')

if [ -z "$REMOTE_DIRS" ]; then
    echo "No dynamic directories found or adb connection failed. Reverting to default /sdcard."
    REMOTE_DIRS="/sdcard"
fi

echo "Found remote directories to pull: ${REMOTE_DIRS}"
echo "------------------------------------------------"

# 2. Iterate over the dynamically populated list of directories
for DIR in ${REMOTE_DIRS}; do
    # Remove trailing slashes for cleaner output/local paths
    DIR_CLEAN=$(echo "${DIR}" | sed 's:/*$::')

    echo "Attempting to pull data from ${DIR_CLEAN}..."
    
    # Use -a flag to preserve timestamps and modes
    adb pull -a "${DIR_CLEAN}" "${LOCAL_DIR}"

    if [ $? -eq 0 ]; then
        echo "--> Successfully pulled some data from ${DIR_CLEAN}."
    else
        echo "--> Failed to pull from ${DIR_CLEAN} or directory inaccessible."
    fi
    echo "-----------------------------------------------"
done
