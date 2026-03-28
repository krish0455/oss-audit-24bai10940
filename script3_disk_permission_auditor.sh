#!/bin/bash
# ============================================================
# Script 3: Disk and Permission Auditor
# Author: Krish Kumar | Reg No: 24BAI10940
# Course: Open Source Software | Chosen Software: Python
# Purpose: Loops through key system directories and reports
#          permissions, ownership, and disk usage. Also checks
#          Python's specific installation directories.
# ============================================================

echo "============================================================"
echo "        DISK AND PERMISSION AUDITOR — Python Edition        "
echo "============================================================"
echo ""

# -------------------------------------------------------
# SECTION 1: Audit standard system directories
# We use a for loop to iterate over the directory array.
# du -sh gives human-readable sizes; ls -ld shows permissions.
# awk extracts specific fields from ls output.
# -------------------------------------------------------

# Array of important system directories to audit
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/opt" "/usr/lib")

echo "------------------------------------------------------------"
echo "  Standard System Directory Audit"
echo "------------------------------------------------------------"
printf "  %-20s %-15s %-10s %-10s %s\n" "DIRECTORY" "PERMISSIONS" "OWNER" "GROUP" "SIZE"
echo "  ---------------------------------------------------------------"

# Loop through each directory in the array
for DIR in "${DIRS[@]}"; do
    # Check if the directory actually exists before trying to read it
    if [ -d "$DIR" ]; then
        # Extract permissions, owner, and group using awk on ls -ld output
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')
        # du gives disk usage; 2>/dev/null suppresses permission errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)
        printf "  %-20s %-15s %-10s %-10s %s\n" "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE"
    else
        # Directory does not exist on this system — print gracefully
        printf "  %-20s %s\n" "$DIR" "[does not exist on this system]"
    fi
done

echo ""

# -------------------------------------------------------
# SECTION 2: Python-specific directory audit
# Python installs files across multiple locations.
# This section checks where Python lives on this system.
# -------------------------------------------------------

echo "------------------------------------------------------------"
echo "  Python Installation Directory Audit"
echo "------------------------------------------------------------"

# Detect Python's actual installation paths using Python itself
if command -v python3 &>/dev/null; then
    # Get Python's prefix (root install location)
    PY_PREFIX=$(python3 -c "import sys; print(sys.prefix)")
    # Get site-packages directory (where third-party libs go)
    PY_SITE=$(python3 -c "import site; print(site.getsitepackages()[0])" 2>/dev/null || echo "N/A")
    # Get Python standard lib location
    PY_LIB=$(python3 -c "import sysconfig; print(sysconfig.get_path('stdlib'))")
    # Get Python executable path
    PY_BIN=$(which python3)

    echo ""
    echo "  Python executable: $PY_BIN"
    echo ""

    # Build array of Python-specific directories to audit
    PY_DIRS=("$PY_PREFIX" "$PY_LIB" "$PY_SITE" "/etc/python3" "/usr/lib/python3")

    printf "  %-35s %-15s %-10s %s\n" "PYTHON DIRECTORY" "PERMISSIONS" "OWNER" "SIZE"
    echo "  -----------------------------------------------------------------------"

    for PY_DIR in "${PY_DIRS[@]}"; do
        if [ -d "$PY_DIR" ]; then
            PERMS=$(ls -ld "$PY_DIR" | awk '{print $1}')
            OWNER=$(ls -ld "$PY_DIR" | awk '{print $3}')
            SIZE=$(du -sh "$PY_DIR" 2>/dev/null | cut -f1)
            printf "  %-35s %-15s %-10s %s\n" "$PY_DIR" "$PERMS" "$OWNER" "$SIZE"
        else
            printf "  %-35s %s\n" "$PY_DIR" "[not found]"
        fi
    done

else
    echo "  Python3 not found in PATH. Install it to see Python directories."
fi

echo ""

# -------------------------------------------------------
# SECTION 3: Permission risk analysis
# Checks for world-writable directories — a security concern.
# World-writable means any user can write files there, which
# can be exploited for privilege escalation attacks.
# -------------------------------------------------------

echo "------------------------------------------------------------"
echo "  Permission Risk Check (World-Writable Directories)"
echo "------------------------------------------------------------"
echo ""
echo "  Scanning /tmp, /var/tmp for world-writable entries..."
echo ""

# find with -perm -0002 detects world-writable files/dirs
WORLD_WRITABLE=$(find /tmp /var/tmp -maxdepth 2 -perm -0002 -type d 2>/dev/null | head -10)

if [ -n "$WORLD_WRITABLE" ]; then
    echo "  [WARN] World-writable directories found (normal for /tmp):"
    echo "$WORLD_WRITABLE" | while read -r LINE; do
        echo "    -> $LINE"
    done
else
    echo "  [OK] No unexpected world-writable directories found."
fi

echo ""
echo "  Security Note: Python scripts should never be placed in"
echo "  world-writable directories like /tmp in production."
echo "  Always store Python apps in /opt or /home/<user>/."

echo ""
echo "============================================================"
echo "  Disk and permission audit complete."
echo "============================================================"
