# Overview
This folder contains software scripts that are needed to send packets to the test hardware server

# loopback_server.py
## Description
This python script sends the number 2 to the test_hardware_server (IP 10.100.100.100) from IP address 10.1.2.12. It then listens for a packet sent to its IP address, and checks if it is 4.
## Usage
1. Navigate to this folder
2. Run `python3 loopback_server.py`
