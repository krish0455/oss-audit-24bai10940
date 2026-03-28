#!/bin/bash
# ============================================================
# Script 2: FOSS Package Inspector
# Author: Krish Kumar | Reg No: 24BAI10940
# Course: Open Source Software | Chosen Software: Python
# Purpose: Checks if Python (and related FOSS packages) are
#          installed, shows version/license info, and prints
#          a philosophy note using a case statement.
# ============================================================

# --- Package to inspect (primary: python3) ---
PACKAGE="python3"

echo "============================================================"
echo "          FOSS PACKAGE INSPECTOR — Python Edition           "
echo "============================================================"
echo ""

# -------------------------------------------------------
# SECTION 1: Detect package manager and check installation
# We support both apt (Debian/Ubuntu) and rpm (Fedora/RHEL)
# This makes the script portable across Linux distributions.
# -------------------------------------------------------

# Function to check and display package info
check_package() {
    local PKG=$1

    echo "------------------------------------------------------------"
    echo "  Inspecting package: $PKG"
    echo "------------------------------------------------------------"

    # Try dpkg first (Debian/Ubuntu systems)
    if command -v dpkg &>/dev/null; then
        if dpkg -l "$PKG" &>/dev/null 2>&1 | grep -q "^ii"; then
            echo "  [FOUND] $PKG is installed (via dpkg/apt)"
            # Extract version and description from dpkg
            VERSION=$(dpkg -l "$PKG" 2>/dev/null | grep "^ii" | awk '{print $3}')
            echo "  Version : $VERSION"
            echo "  Manager : apt / dpkg (Debian/Ubuntu)"
        else
            echo "  [NOT FOUND] $PKG is not installed via dpkg."
            echo "  To install: sudo apt install $PKG"
        fi

    # Try rpm next (Fedora/RHEL/CentOS systems)
    elif command -v rpm &>/dev/null; then
        if rpm -q "$PKG" &>/dev/null; then
            echo "  [FOUND] $PKG is installed (via rpm)"
            rpm -qi "$PKG" | grep -E 'Version|License|Summary'
        else
            echo "  [NOT FOUND] $PKG is not installed via rpm."
            echo "  To install: sudo dnf install $PKG"
        fi
    else
        echo "  [WARN] Neither apt/dpkg nor rpm found on this system."
    fi
}

# Check primary package
check_package "$PACKAGE"

echo ""

# -------------------------------------------------------
# SECTION 2: Direct Python version check
# Even if package manager doesn't detect it, Python might
# be available in PATH (e.g., compiled from source)
# -------------------------------------------------------
echo "------------------------------------------------------------"
echo "  Direct Python Binary Check"
echo "------------------------------------------------------------"

# Check python3 binary
if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 --version 2>&1)
    PY_PATH=$(which python3)
    echo "  Binary  : $PY_PATH"
    echo "  Version : $PY_VERSION"
    echo "  Status  : Python 3 is available on this system."
else
    echo "  python3 binary not found in PATH."
fi

# Also check for python (version 2 or fallback)
if command -v python &>/dev/null; then
    echo "  Also found: $(python --version 2>&1) at $(which python)"
fi

echo ""

# -------------------------------------------------------
# SECTION 3: Case statement — FOSS philosophy notes
# The case statement maps package names to a short note
# about the philosophy behind each open-source project.
# -------------------------------------------------------
echo "------------------------------------------------------------"
echo "  Open Source Philosophy Notes"
echo "------------------------------------------------------------"

# We loop through a list of notable FOSS packages to show philosophy
for PKG_NAME in python3 git firefox vlc mysql apache2 httpd libreoffice; do
    case $PKG_NAME in
        python3|python)
            echo "  Python   : 'Batteries included' — built by community,"
            echo "             for everyone. The PSF license lets even"
            echo "             corporations embed Python freely, accelerating"
            echo "             adoption and cementing Python's dominance."
            ;;
        git)
            echo "  Git      : Born from necessity — Linus built Git when"
            echo "             BitKeeper revoked its free license. A reminder"
            echo "             that open source protects against vendor lock-in."
            ;;
        firefox)
            echo "  Firefox  : A nonprofit browser in a world of corporate"
            echo "             browsers. Mozilla proves open source can fight"
            echo "             for users even when profit isn't the motive."
            ;;
        vlc)
            echo "  VLC      : Started by students at École Centrale Paris."
            echo "             LGPL/GPL licensed — plays everything. Proof"
            echo "             that student projects can outlast corporations."
            ;;
        mysql)
            echo "  MySQL    : Dual-licensed (GPL + commercial) — a fascinating"
            echo "             case study in how open source and business models"
            echo "             can coexist, and sometimes conflict."
            ;;
        apache2|httpd)
            echo "  Apache   : The Apache 2.0 license is business-friendly."
            echo "             Apache HTTP Server powers ~30% of the web —"
            echo "             proof that permissive licenses drive adoption."
            ;;
        libreoffice)
            echo "  LibreOffice: Born from a community fork of OpenOffice"
            echo "             when Oracle acquired Sun. A lesson in why"
            echo "             community governance matters more than code."
            ;;
        *)
            echo "  $PKG_NAME : An open-source tool contributing to the"
            echo "             commons — freely available for all to use."
            ;;
    esac
done

echo ""
echo "============================================================"
echo "  Inspection complete. Python: your chosen OSS project."
echo "============================================================"
