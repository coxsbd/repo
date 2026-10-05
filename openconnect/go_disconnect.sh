#!/bin/bash
source /root/.db-base

# Siguraduhing may laman ang USERNAME na pinasa ng ocserv
if [ -z "$USERNAME" ]; then
    exit 0
fi

# 1. I-update ang status ng user sa database bilang disconnected
MYSQL_PWD=$DB_PASS mysql -u $DB_USER -h $DB_HOST -D $DB_NAME -sse "UPDATE users SET is_connected='0', active_address='', active_date='' WHERE user_name='$USERNAME'"

# 2. Bawasan ng 1 ang online count gamit ang tamang server identifier (TK403)
MYSQL_PWD=$DB_PASS mysql -u $DB_USER -h $DB_HOST -D $DB_NAME -sse "UPDATE server_list SET online=online-1 WHERE server_ip='TK403'"

exit 0
