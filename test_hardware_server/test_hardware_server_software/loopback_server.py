# Connects to the loopback server using the UDP protocol and sends/receives packets
# MUST BE RUN USING PYTHON 3

import socket
import time

if (__name__ == "__main__"):
    my_ip_address = "10.1.2.12"
    udp_port = 5005 # Use this port for both my container and the server
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind((my_ip_address, udp_port))

    server_ip_address = "10.100.100.100"
    for i in range(0, 256):
        message = bytes([i])
        start_time = time.time()
        sock.sendto(message, (server_ip_address, udp_port))
        print("Sent message:", message)
        print("Message Value:", i)
        data, addr = sock.recvfrom(1024)
        int_data = int.from_bytes(data, byteorder="big")
        end_time = time.time()
        print(int_data)
        if (int_data == 2 * i):
            print("TEST PASSED")
        else:
            print("TEST FAILED")
        elapsed_time = end_time - start_time
        print("Processing time:", elapsed_time)
        