# Line-Following-Robot
An autonomous line following robot developed using ESP32, Embedded C, and a PID control algorithm to achieve accurate and stable path tracking. The robot continuously reads data from an IR sensor array, calculates the positional error, and dynamically adjusts motor speeds through an L298N motor driver for smooth navigation.
📌 Features
Real-time line detection using IR sensor array
PID-based steering correction
Dynamic motor speed control
Modular Embedded C implementation
High-speed and stable trajectory tracking
Easily configurable PID parameters
🛠️ Hardware Used
ESP32 WROOM
L298N Motor Driver
IR Sensor Array (RLS08)
N20 DC Geared Motors
Li-ion Battery Pack
Robot Chassis
💻 Software & Tools
Embedded C
Arduino IDE
ESP32 Framework
⚙️ Working Principle
IR sensors continuously detect the position of the line.
Sensor readings are converted into a positional error.
A PID controller computes the required correction.
Motor speeds are adjusted independently through the L298N motor driver.
The process repeats in real time, allowing the robot to follow the track smoothly.
📂 Project Structure
line-following-robot-esp32/
│
├── firmware/
├── docs/
├── images/
├── videos/
├── README.md
├── LICENSE
└── .gitignore
🧠 Control Algorithm
Read Sensors
      │
      ▼
Calculate Position Error
      │
      ▼
PID Controller
      │
      ▼
Compute Motor Speeds
      │
      ▼
Drive Motors
      │
      ▼
Repeat
🚀 Future Improvements
Junction detection
Maze solving capability
Wireless PID tuning
Obstacle avoidance integration
OLED/LCD debugging interface
📷 Demo
Add images or a short demo video of the robot in action inside the images/ or videos/ directory.

📈 Learning Outcomes
This project demonstrates practical experience with:

Embedded Systems Programming
Sensor Interfacing
PID Control Systems
Motor Driver Integration
Real-Time Decision Making
ESP32 Firmware Development
⭐ If you found this project interesting, consider giving it a star!
