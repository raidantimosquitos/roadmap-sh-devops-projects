# Server Performance Monitoring

The script `server-stats.sh` that can analyse basic server performance stats, it assumes the server is using Ubuntu/Debian OS. Here is a brief description of the output information:

- **OS Version**, prints the server's OS verson. Output example:
```bash
===== OS Version =====
Ubuntu 22.04.5 LTS
```
- **Total CPU Usage**, prints the server's total CPU usage (in percentile). Output example:
```bash
===== CPU Usage =====
Used: 0.8%
```

- **Total memory usage**, prints the server's memory usage (both in bytes and percentile)
```bash
===== Memory Usage =====
Used: 2.1Gi, Free: 5.2Gi (28.77% used)
```

- **Total disk usage**, prints the server's disk usage (both in bytes and percentile). Output example:
```bash
===== Disk Usage =====
Used: 535G, Free: 1.4T, (99.74% used)
```

- **Top 5 processes by CPU usage**, prints the five most CPU intensive processes currently running in the server. Output example:
```bash
===== Top 5 Processes by CPU Usage =====
    PID COMMAND         %CPU
    815 node             2.1
   1183 node             0.3
    757 node             0.2
    737 node             0.1
  63936 node             0.1
```

- **Top 5 processes by memory usage**, prints the five most memory intensive processes currently running in the server. Output example:
```bash
===== Top 5 Processes by Memory Usage =====
    PID COMMAND         %MEM
   1183 node            13.1
    815 node             3.1
    354 python3.10       1.2
   7217 node             1.2
    737 node             1.1
```

- **Server uptime**, prints how long has the server been running. Output example:
```bash
===== Uptime =====
up 11 hours, 30 minutes
```

- **Load average**, prints the load average in time intervals of the last 1, 5 and 15 minutes respectively. I also added the number of CPU cores to provide better understanding of load average. Output example:
```bash
===== CPU Cores & Load Average =====
NO. CPU CORES: 16
Load Average:   0.36, 0.15, 0.04
Note: A load average near 16 indicates full utilization.
```

- **Logged In Users**, prints the logged in users to the server. Output example:
```bash
===== Logged In Users =====
      1 michael-jackson
```

- **Failed Login Attempts**, prints the failed login attempts. Output example:
```bash
===== Failed Login Attempts =====
Total failed login attempts: 0

```
- **Open ports**, prints the current open ports in the server. Important to know that only the necessary ones are active, avoiding backdoors. Output example:
```bash
===== Open Ports =====
Netid      State       Recv-Q      Send-Q            Local Address:Port             Peer Address:Port      Process
udp        UNCONN      0           0                 127.0.0.53%lo:53                    0.0.0.0:*
udp        UNCONN      0           0                          [::]:111                      [::]:*
tcp        LISTEN      0           4096              127.0.0.53%lo:53                    0.0.0.0:*
tcp        LISTEN      0           511                   127.0.0.1:35707                 0.0.0.0:*

```

- **Running services**, displays the status of critical services for the system. Output example:
```bash
===== Running Services =====
UNIT
console-getty.service
cron.service
dbus.service
getty@tty1.service
```

- **Recent critical logs**, displays recent critical logs raised in the system. Output example:
```bash
===== Recent Critical Logs =====
Nov 21 11:52:13 serverName /sbin/ldconfig.real:
Nov 21 11:52:13 serverName unknown: Failed to connect to bus: No such file or directory
```
  
## Running the script

To run the script, clone the repository and in its directory you can run `./server-stats.sh`. Make sure the user you are running the script with has read rights to the file `/var/log/auth.log` to display login attempts, you can run with `sudo ./server-stats.sh` if it helps.


This is a project from roadmap.sh:
https://roadmap.sh/projects/server-stats
