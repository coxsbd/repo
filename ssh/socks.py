#!/usr/bin/env python3
import socket, threading, select, sys, time, getopt

# Repo: https://github.com/coxsbd/repo
REPO_URL = 'https://github.com/coxsbd/repo'

LISTENING_ADDR = '0.0.0.0'
LISTENING_PORT = 80
PASS = ''
