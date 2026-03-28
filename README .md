# OSS Audit — Python
**Student Name:** Krish Kumar  
**Registration Number:** 24BAI10940  
**Course:** Open Source Software | VIT  
**Chosen Software:** Python (PSF License v2)  
**GitHub Repo:** `oss-audit-24bai10940`

---

## About This Project

This repository is the shell script submission for the Open Source Audit capstone project. The audit examines **Python** — its origin, its PSF license, its Linux footprint, its FOSS ecosystem, and its comparison to proprietary alternatives (MATLAB). The full written report is submitted separately on the VITyarthi portal.

---

## Scripts Overview

| Script | File | Purpose |
|--------|------|---------|
| Script 1 | `script1_system_identity.sh` | Displays system info (kernel, distro, user, uptime) and the OS license |
| Script 2 | `script2_package_inspector.sh` | Checks if Python is installed, shows version/license, case statement with FOSS philosophy notes |
| Script 3 | `script3_disk_permission_auditor.sh` | Audits system + Python directories for permissions, ownership, disk usage |
| Script 4 | `script4_log_analyzer.sh` | Reads a log file, counts keyword matches, shows last 5 hits. Accepts CLI arguments |
| Script 5 | `script5_manifesto_generator.sh` | Interactive: asks 3 questions, generates a personal open-source manifesto, saves to .txt |

---

## How to Run Each Script

### Prerequisites
- A Linux system (Ubuntu, Debian, Fedora, or a VM)
- Bash shell (pre-installed on all Linux distributions)
- Python 3 installed (for Scripts 2 and 3)

### Setup — Make Scripts Executable

```bash
# Clone this repository
git clone https://github.com/krish0455/oss-audit-24bai10940.git
cd oss-audit-24bai10940

# Make all scripts executable
chmod +x *.sh
```

---

### Script 1 — System Identity Report

```bash
./script1_system_identity.sh
```

No arguments required. Displays kernel version, distro, username, home directory, uptime, date/time, and the GPL v2 license note for the Linux kernel.

---

### Script 2 — FOSS Package Inspector

```bash
./script2_package_inspector.sh
```

No arguments required. Automatically detects whether you are on apt (Ubuntu/Debian) or rpm (Fedora/RHEL). Checks Python installation and prints philosophy notes for multiple FOSS packages using a `case` statement.

---

### Script 3 — Disk and Permission Auditor

```bash
./script3_disk_permission_auditor.sh
```

No arguments required. May need `sudo` for accurate sizes of some system directories:

```bash
sudo ./script3_disk_permission_auditor.sh
```

---

### Script 4 — Log File Analyzer

```bash
# Basic usage — searches for 'error' (default keyword)
./script4_log_analyzer.sh /var/log/syslog

# Custom keyword
./script4_log_analyzer.sh /var/log/syslog warning

# On Fedora/RHEL use /var/log/messages
./script4_log_analyzer.sh /var/log/messages error

# May need sudo to read some log files
sudo ./script4_log_analyzer.sh /var/log/auth.log failed
```

**Arguments:**
- `$1` — Path to the log file (required)
- `$2` — Keyword to search for (optional, default: `error`)

---

### Script 5 — Open Source Manifesto Generator

```bash
./script5_manifesto_generator.sh
```

Interactive script. Answer the three prompts. Your personal manifesto is saved to `manifesto_krish0455.txt` in the current directory and displayed on screen.

---

## Dependencies

| Dependency | Used By | Install Command |
|-----------|---------|----------------|
| `bash` | All scripts | Pre-installed on Linux |
| `python3` | Scripts 2, 3 | `sudo apt install python3` or `sudo dnf install python3` |
| `dpkg` / `rpm` | Script 2 | Pre-installed on Debian/Fedora respectively |
| `coreutils` (du, ls, df) | Script 3 | Pre-installed on all Linux |
| `grep`, `awk`, `cut` | Scripts 3, 4 | Pre-installed on all Linux |

---

## File Structure

```
oss-audit-24bai10940/
├── README.md
├── script1_system_identity.sh
├── script2_package_inspector.sh
├── script3_disk_permission_auditor.sh
├── script4_log_analyzer.sh
└── script5_manifesto_generator.sh
```

---

## Submission

- **GitHub Repo:** This repository (must be public)
- **Report PDF:** Submitted separately on VITyarthi portal
- **Portal:** VITyarthi — paste GitHub URL, confirm README present, upload PDF
