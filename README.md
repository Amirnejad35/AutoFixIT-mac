# AutoFixIT-mac

**AutoFixIT-mac** is a macOS automation script designed for IT support diagnostics, system cleanup, and basic security testing. It streamlines routine tasks for help desk and entry-level IT professionals.

## 🔧 Features
- Internet connectivity and DNS resolution check
- Disk usage alert if above 85%
- Optional Wi-Fi service restart
- Recent system error log capture
- ✅ NEW: Security checks:
  - Firewall status
  - SIP (System Integrity Protection) check
  - Login items list
  - Open network ports
  - World-writable file scan (limited output)

## 🧪 How to Run
```bash
chmod +x autofixit_mac_secure.sh
./autofixit_mac_secure.sh
```

All output will be saved to a timestamped log file inside the `/logs` directory.

## 📌 Use Case
This tool simulates real-world help desk diagnostics and basic macOS security auditing. Ideal for students, IT support learners, or entry-level cybersecurity practice.

## 🖥️ Requirements
- macOS Terminal
- zsh shell (default in recent macOS versions)
- Admin privileges for some logs (optional)

## 📄 License
MIT License – you are free to use, share, and improve with attribution.

## 🙋‍♂️ Contributions
Open to PRs or forks. Created for educational and professional development purposes.
