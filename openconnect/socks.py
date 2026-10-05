#!/usr/bin/env python3
import socket, threading, select, sys, time, getopt

# Repo: https://github.com/coxsbd/repo
REPO_URL = 'https://github.com/coxsbd/repo'

# Listen
LISTENING_ADDR = '0.0.0.0'
if sys.argv[1:]:
    LISTENING_PORT = int(sys.argv[1])
else:
    LISTENING_PORT = 80
