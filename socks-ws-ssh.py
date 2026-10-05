#!/usr/bin/env python3
# encoding: utf-8

import socket, threading, thread, select, signal, sys, time, getopt

# Repo: https://github.com/coxsbd/repo
REPO_URL = 'https://github.com/coxsbd/repo'

# Python Proxy ou Socks

# Porta do Proxy
proxyport = 8001
