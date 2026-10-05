#!/bin/bash
# Load database credentials
. /etc/openvpn/login/config.sh

# Detect Server IP
server_ip=$(curl -s https://api.ipify.org)

# Date and Time formatting
datenow=$(date +"%Y-%m-%d %T")
tm=$(date +%s)
dt=$(date +'%Y-%m-%d %H:%M:%S')
timestamp=$(date +%s)

# Check if user already has an 'online' log
bandwidth_check=$(mysql -u $USER -p$PASS -D $DB -h $HOST --skip-column-name -e "SELECT COUNT(*) FROM bandwidth_logs WHERE username='$common_name' AND status='online'")

if [ "$bandwidth_check" -gt 0 ]; then
    # Update existing online log
    mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE bandwidth_logs SET server_ip='$trusted_ip', server_port='$trusted_port', timestamp='$timestamp', ipaddress='$trusted_ip:$trusted_port', username='$common_name', bytes_received='0', bytes_sent='0', status='online' WHERE username='$common_name' AND status='online'"
    
    # Set user as connected in users table
    mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE users SET is_connected='1', device_connected='1', active_address='$server_ip', active_date='$datenow' WHERE user_name='$common_name'"
else
    # Insert new online log
    mysql -u $USER -p$PASS -D $DB -h $HOST -e "INSERT INTO bandwidth_logs (server_ip, server_port, timestamp, ipaddress, since_connected, username, bytes_received, bytes_sent, time_in, status, time_out) VALUES ('$trusted_ip', '$trusted_port', '$timestamp', '$trusted_ip:$trusted_port', '$dt', '$common_name', '0', '0', '$dt', 'online', '0000-00-00 00:00:00')"
    
    # Set user as connected in users table
    mysql -u $USER -p$PASS -D $DB -h $HOST -e "UPDATE users SET is_connected='1', device_connected='1', active_address='$server_ip', active_date='$datenow' WHERE user_name='$common_name'"
fi

exit 0
