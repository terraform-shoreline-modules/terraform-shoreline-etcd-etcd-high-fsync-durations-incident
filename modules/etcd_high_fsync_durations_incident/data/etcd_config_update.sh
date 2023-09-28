

#!/bin/bash



# Define the Etcd configuration file path

ETCD_CONFIG_FILE=${PATH_TO_ETCD_CONFIG_FILE}



# Define the WAL sync interval and the number of concurrent compacting processes

WAL_SYNC_INTERVAL=${WAL_SYNC_INTERVAL}

CONCURRENT_COMPACTING_PROCESSES=${CONCURRENT_COMPACTING_PROCESSES}



# Update the Etcd configuration file with the new values

sed -i 's/^WAL_SYNC_INTERVAL=.*/WAL_SYNC_INTERVAL='${WAL_SYNC_INTERVAL}'/' $ETCD_CONFIG_FILE

sed -i 's/^CONCURRENT_COMPACTING_PROCESSES=.*/CONCURRENT_COMPACTING_PROCESSES='${CONCURRENT_COMPACTING_PROCESSES}'/' $ETCD_CONFIG_FILE



# Restart the Etcd service to apply the changes

systemctl restart etcd.service