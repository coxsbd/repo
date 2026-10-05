#!/usr/bin/env python3
import socket, threading, thread, select, signal, sys, time
from os import system

# Repo: https://github.com/coxsbd/repo
REPO_URL = 'https://github.com/coxsbd/repo'

system("clear")
#conexao
IP = '0.0.0.0'
try:
   PORT = int(sys.argv[1])
except:
   PORT = 80
