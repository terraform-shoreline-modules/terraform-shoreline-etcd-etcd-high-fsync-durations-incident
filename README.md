
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Etcd high fsync durations incident.
---

The Etcd high fsync durations incident occurs when the fsync duration of the Etcd service exceeds a certain threshold. This can be caused by various factors, such as high load, network issues, or other system errors. When this incident occurs, it can impact the performance and availability of the Etcd service, and it requires immediate attention from the responsible team to diagnose and resolve the underlying issue.

### Parameters
```shell
export TIMEFRAME="PLACEHOLDER"

export ETCD_METRICS_ENDPOINT="PLACEHOLDER"

export ETCD_SERVER_IP="PLACEHOLDER"

export DISK_DEVICE="PLACEHOLDER"

export WAL_SYNC_INTERVAL="PLACEHOLDER"

export PATH_TO_ETCD_CONFIG_FILE="PLACEHOLDER"

export CONCURRENT_COMPACTING_PROCESSES="PLACEHOLDER"
```

## Debug

### Check if Etcd service is running
```shell
systemctl status etcd.service
```

### Check Etcd log for any errors or warnings
```shell
journalctl -u etcd.service --since "${TIMEFRAME}" | grep -iE 'error|warn'
```

### Check Etcd metrics for fsync duration
```shell
curl -s ${ETCD_METRICS_ENDPOINT} | grep etcd_disk_backend_commit_duration_seconds
```

### Check system load and resource usage
```shell
top -n 1
```

### Check network connectivity and latency to Etcd server
```shell
ping ${ETCD_SERVER_IP}

traceroute ${ETCD_SERVER_IP}
```

### Check disk I/O performance
```shell
iostat -xd ${DISK_DEVICE}
```

### High load: If the Etcd service is experiencing high traffic or a sudden spike in requests, it can cause the fsync duration to increase, leading to this incident.
```shell
bash

#!/bin/bash



# Set the threshold for fsync duration

THRESHOLD=0.25



# Fetch the current fsync duration of the Etcd service

ETCD_FSYNC=$(etcdctl check perf | awk '{print $7}')



# Check if the fsync duration is above the threshold

if (( $(echo "$ETCD_FSYNC > $THRESHOLD" | bc -l) )); then

  echo "Etcd high fsync durations detected"

  

  # Check the current load on the Etcd service

  ETCD_LOAD=$(etcdctl check perf | awk '{print $6}')

  

  # If the load is high, take action

  if (( $(echo "$ETCD_LOAD > 1" | bc -l) )); then

    echo "High traffic detected on the Etcd service"

    

    # Restart the Etcd service to reduce the load and fsync duration

    systemctl restart etcd

    

    echo "Etcd service restarted"

  else

    echo "No high traffic detected on the Etcd service"

  fi

else

  echo "Etcd fsync durations are normal"

fi


```

## Repair

### Optimize the Etcd configuration settings, such as the WAL sync interval and the number of concurrent compacting processes, to improve the system performance and reduce the fsync duration.
```shell


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


```