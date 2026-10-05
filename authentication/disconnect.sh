#!/bin/bash
. /etc/openvpn/login/config.sh

dt=$(date +'%Y-%m-%d %H:%M:%S')
bytes_received=${bytes_received:-0}
bytes_sent=${bytes_sent:-0}

mysql -u "$USER" -p"$PASS" -D "$DB" -h "$HOST" <<SQL
UPDATE bandwidth_logs
SET bytes_received='$bytes_received', bytes_sent='$bytes_sent', time_out='$dt', status='offline'
WHERE username='$common_name' AND status='online'
ORDER BY id DESC LIMIT 1;

UPDATE users SET
is_connected='0',
login_status='offline',
device_connected='0',
active_address='',
active_address=NULL,
last_active_time='$dt'
WHERE user_name='$common_name';
SQL
