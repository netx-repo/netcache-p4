import socket
import struct
import time
import thread

from nc_config import *

NC_PORT = 8888
CLIENT_IP = "10.0.0.1"
SERVER_IP = "10.0.0.2"
CONTROLLER_IP = "10.0.0.3"
path_reply = "reply.txt"

len_key = 16

counter = 0
def counting():
    last_counter = 0
    while True:
        print (counter - last_counter), counter
        last_counter = counter
        time.sleep(1)
thread.start_new_thread(counting, ())

#f = open(path_reply, "w")
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind((CLIENT_IP, NC_PORT))
while True:
    packet, addr = s.recvfrom(1024)
    counter = counter + 1
    #op = struct.unpack("B", packet[0])
    #key_header = struct.unpack(">I", packet[1:5])[0]
    #f.write(str(op) + ' ')
    #f.write(str(key_header) + '\n')
    #f.flush()
    #print counter
#f.close()    
