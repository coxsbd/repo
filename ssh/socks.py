#!/usr/bin/env python3
import socket, threading, select, sys, time, getopt

LISTENING_ADDR = '0.0.0.0'
LISTENING_PORT = 80
PASS = ''
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = '127.0.0.1:442'
RESPONSE = b'HTTP/1.1 101 ssh ws \r\n\r\n'

class Server(threading.Thread):
    def __init__(self, host, port):
        super().__init__(); self.host, self.port = host, port
        self.threads, self.running = [], False
    def run(self):
        self.soc = socket.socket(socket.AF_INET)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.bind((self.host, int(self.port)))
        self.soc.listen(0)
        self.running = True
        while self.running:
            try:
                c, addr = self.soc.accept()
                ConnectionHandler(c, self, addr).start()
            except: pass
    def close(self): self.running = False; self.soc.close()

class ConnectionHandler(threading.Thread):
    def __init__(self, client, server, addr):
        super().__init__(); self.client, self.server = client, server
    def run(self):
        try:
            data = self.client.recv(BUFLEN).decode(errors="ignore")
            hostPort = "127.0.0.1:442"
            self.connect_target(hostPort)
            self.client.sendall(RESPONSE)
            self.exchange_loop()
        except: pass
        finally: self.client.close()
    def connect_target(self, host):
        host, port = host.split(":")
        self.target = socket.socket()
        self.target.connect((host, int(port)))
    def exchange_loop(self):
        socs = [self.client, self.target]
        while True:
            r, _, _ = select.select(socs, [], [], 3)
            if r:
                for s in r:
                    data = s.recv(BUFLEN)
                    if not data: return
                    (self.target if s is self.client else self.client).send(data)

if __name__ == '__main__':
    Server(LISTENING_ADDR, LISTENING_PORT).start()
    while True: time.sleep(100)
