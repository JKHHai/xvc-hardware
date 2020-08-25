# Connects to the loopback server using the UDP protocol and sends/receives packets
# MUST BE RUN USING PYTHON 3

import socket
import time

if (__name__ == "__main__"):
    my_ip_address = "10.1.2.12"
    udp_port = 5005 # Use this port for both my container and the server
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((my_ip_address, udp_port))

    i = 1
    server_ip_address = "10.100.100.100"
    while True:
        message = bytes([i])
        start_time = time.time()
        sock.sendto(message, (server_ip_address, udp_port))
        print("Sent message:", message)
        data, addr = sock.recvfrom(1024)
        end_time = time.time()
        print(data)
        if (data == 2 * i):
            print("TEST PASSED")
        else:
            print("TEST FAILED")
        elapsed_time = end_time - start_time
        print("Processing time:", elapsed_time)
        i += 1
