#!/bin/bash
# ============================================================
# Script 4: Log File Analyzer
# Author: Krish Kumar | Reg No: 24BAI10940
# Course: Open Source Software | Chosen Software: Python
# Purpose: Reads a log file line by line, counts lines that
#          match a keyword, and prints a summary with context.
#          Demonstrates: while-read loop, if-then, counters,
#          command-line arguments ($1, $2), and retry logic.
# Usage:   ./script4_log_analyzer.sh /var/log/syslog error
#          ./script4_log_analyzer.sh /var/log/syslog warning
# ============================================================

# -------------------------------------------------------
# SECTION 1: Accept command-line arguments
# $1 = path to log file (required)
# $2 = keyword to search for (optional, defaults to "error")
# -------------------------------------------------------

LOGFILE=$1                    # First argument: log file path
KEYWORD=${2:-"error"}         # Second argument: keyword (default: "error")

# Counters for tracking matches and total lines read
COUNT=0
TOTAL_LINES=0
MAX_RETRIES=3                 # Maximum retry attempts if file is empty
RETRY=0

echo "============================================================"
echo "          LOG FILE ANALYZER — Open Source Audit             "
echo "============================================================"
echo ""

# -------------------------------------------------------
# SECTION 2: Validate that a log file was provided
# If no argument is given, show usage and exit with error.
# -------------------------------------------------------

if [ -z "$LOGFILE" ]; then
    echo "  [ERROR] No log file specified."
    echo ""
    echo "  Usage: $0 <logfile> [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    echo ""
    echo "  Common log files to try:"
    echo "    /var/log/syslog       (Ubuntu/Debian)"
    echo "    /var/log/messages     (Fedora/RHEL)"
    echo "    /var/log/dpkg.log     (apt package logs)"
    echo "    /var/log/auth.log     (authentication logs)"
    exit 1
fi

# -------------------------------------------------------
# SECTION 3: Check if the file exists and is readable
# -f checks for regular file; -r checks readability.
# -------------------------------------------------------

if [ ! -f "$LOGFILE" ]; then
    echo "  [ERROR] File not found: $LOGFILE"
    echo ""
    echo "  Tip: Run 'ls /var/log/' to see available log files."
    exit 1
fi

if [ ! -r "$LOGFILE" ]; then
    echo "  [ERROR] Cannot read file: $LOGFILE"
    echo "  Try: sudo $0 $LOGFILE $KEYWORD"
    exit 1
fi

echo "  Log File : $LOGFILE"
echo "  Keyword  : '$KEYWORD' (case-insensitive)"
echo ""

# -------------------------------------------------------
# SECTION 4: Do-while style retry if file is empty
# We simulate a do-while using a while loop with a break.
# If the file is empty, we wait 1 second and retry.
# This is useful for log files that are still being written.
# -------------------------------------------------------

while [ $RETRY -le $MAX_RETRIES ]; do
    # Check if file has any content (non-zero size)
    if [ -s "$LOGFILE" ]; then
        break   # File has content — exit the retry loop
    else
        RETRY=$((RETRY + 1))
        if [ $RETRY -le $MAX_RETRIES ]; then
            echo "  [WARN] File appears empty. Retry $RETRY/$MAX_RETRIES in 1 second..."
            sleep 1
        else
            echo "  [ERROR] File is still empty after $MAX_RETRIES retries."
            echo "  The log file may not have any entries yet."
            exit 1
        fi
    fi
done

echo "------------------------------------------------------------"
echo "  Scanning log file..."
echo "------------------------------------------------------------"
echo ""

# Array to store matching lines for displaying last 5
declare -a MATCHING_LINES=()

# -------------------------------------------------------
# SECTION 5: Main analysis loop — while read
# IFS= prevents stripping of leading/trailing whitespace.
# -r prevents backslash interpretation.
# We read the file line by line and check each line.
# -------------------------------------------------------

while IFS= read -r LINE; do
    # Increment total line counter for every line read
    TOTAL_LINES=$((TOTAL_LINES + 1))

    # if-then: check if this line contains the keyword (case-insensitive via -i flag)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))
        # Store matching line in array (we'll show last 5 later)
        MATCHING_LINES+=("$LINE")
    fi

done < "$LOGFILE"   # Redirect file into the while loop

echo "------------------------------------------------------------"
echo "  Analysis Results"
echo "------------------------------------------------------------"
echo ""
echo "  Total lines scanned : $TOTAL_LINES"
echo "  Keyword matches     : $COUNT"

# Calculate percentage of lines that matched
if [ $TOTAL_LINES -gt 0 ]; then
    # Shell arithmetic doesn't support decimals, so we scale by 100
    PERCENT=$(( (COUNT * 100) / TOTAL_LINES ))
    echo "  Match percentage    : ${PERCENT}%"
fi

echo ""

# -------------------------------------------------------
# SECTION 6: Display last 5 matching lines
# We use tail + grep for this — a classic Unix pipeline.
# This confirms the matches are real and gives context.
# -------------------------------------------------------

if [ $COUNT -gt 0 ]; then
    echo "------------------------------------------------------------"
    echo "  Last 5 lines containing '$KEYWORD':"
    echo "------------------------------------------------------------"
    # grep -i = case-insensitive, then tail -5 gets the last 5 matches
    grep -i "$KEYWORD" "$LOGFILE" | tail -5 | while IFS= read -r MATCH_LINE; do
        # Truncate very long lines for readability (at 100 chars)
        echo "  >> ${MATCH_LINE:0:100}"
    done
    echo ""
else
    echo "  No lines containing '$KEYWORD' were found in this file."
    echo "  Try a different keyword: error, warning, fail, denied, started"
fi

echo ""

# -------------------------------------------------------
# SECTION 7: Python-specific bonus — check Python logs
# If the user is analyzing a file that mentions Python,
# we flag it specifically for the OSS audit context.
# -------------------------------------------------------

PYTHON_MENTIONS=$(grep -ic "python" "$LOGFILE" 2>/dev/null || echo "0")
if [ "$PYTHON_MENTIONS" -gt 0 ]; then
    echo "------------------------------------------------------------"
    echo "  Python-Specific Mentions in Log: $PYTHON_MENTIONS lines"
    echo "------------------------------------------------------------"
    grep -i "python" "$LOGFILE" | tail -3 | while IFS= read -r PY_LINE; do
        echo "  py>> ${PY_LINE:0:100}"
    done
    echo ""
fi

echo "============================================================"
echo "  Log analysis complete."
echo "  Keyword '$KEYWORD' found $COUNT time(s) in $TOTAL_LINES lines."
echo "============================================================"
