#!/bin/bash
# ============================================================
# Script 1: System Identity Report
# Author: [Your Name] | Reg No: [Your Registration Number]
# Course: Open Source Software | Chosen Software: Python
# Purpose: Displays a welcome screen with system info and
#          the open-source license covering the OS kernel.
# ============================================================

# --- Student Variables ---
STUDENT_NAME="[Your Name]"
REG_NUMBER="[Your Reg Number]"
SOFTWARE_CHOICE="Python"

# --- Gather system information using command substitution ---
KERNEL=$(uname -r)                        # Linux kernel version
DISTRO=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')  # Distro name
USER_NAME=$(whoami)                       # Currently logged-in user
HOME_DIR=$HOME                            # Home directory of current user
UPTIME=$(uptime -p)                       # Human-readable uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')     # Formatted date
CURRENT_TIME=$(date '+%H:%M:%S')         # Current time
HOSTNAME=$(hostname)                      # Machine hostname

# --- Linux kernel license note ---
# The Linux kernel is licensed under GPL v2 (GNU General Public License version 2)
# This means the OS itself is free and open source — anyone can view, modify,
# and redistribute the source code, as long as they share changes under the same license.
KERNEL_LICENSE="GPL v2 (GNU General Public License, Version 2)"

# --- Display formatted output ---
echo "============================================================"
echo "       OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT          "
echo "============================================================"
echo ""
echo "  Student     : $STUDENT_NAME ($REG_NUMBER)"
echo "  Software    : $SOFTWARE_CHOICE (PSF License)"
echo "  Course      : Open Source Software"
echo ""
echo "------------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "------------------------------------------------------------"
echo "  Hostname    : $HOSTNAME"
echo "  Distribution: $DISTRO"
echo "  Kernel Ver  : $KERNEL"
echo "  Logged in as: $USER_NAME"
echo "  Home Dir    : $HOME_DIR"
echo "  Uptime      : $UPTIME"
echo "  Date        : $CURRENT_DATE"
echo "  Time        : $CURRENT_TIME"
echo ""
echo "------------------------------------------------------------"
echo "  LICENSE INFORMATION"
echo "------------------------------------------------------------"
echo "  OS License  : $KERNEL_LICENSE"
echo ""
echo "  Note: The Linux kernel you are running is covered by the"
echo "  GPL v2 license. This guarantees your four freedoms:"
echo "    [0] Freedom to run the program for any purpose"
echo "    [1] Freedom to study and modify the source code"
echo "    [2] Freedom to redistribute copies"
echo "    [3] Freedom to distribute your modified versions"
echo ""
echo "  Your chosen software (Python) is licensed under the"
echo "  Python Software Foundation (PSF) License — a permissive"
echo "  license compatible with commercial and open-source use."
echo "============================================================"
