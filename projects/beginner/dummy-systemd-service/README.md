# Dummy systemd Service

Create a long-running `systemd` service that logs to a file,  this is my implementation of [roadmap.sh](https://roadmap.sh/projects/dummy-systemd-service) project.

## Table of contents
- [Requirements](#requirements)
- [Usage](#usage)

## Requirements
You can run this script on any Linux/Unix system, which supports using the `systemd` system and service manager. Since the provided script `dummy.sh` access the system's log directory `/var/log`, if not root, your user must have `sudo` permissions, check this [link](https://linuxhandbook.com/check-if-user-has-sudo-rights/) for further information.

## Usage
In order to create a `systemd` service you must first create a directory where to store it. The location depends on whether this is a root or a user `systemd` service.

The default location to store the `dummy.service` systemd service file is in `/etc/systemd/system/`.

Here is a preview of my `dummy.service` file, remember to store it in one of the above mentioned directories. Also adapt the value of ExecStart according to where you store your `dummy-systemd-service.sh` script.

```bash
[Unit]
Description=Dummy Service
After=network.target

[Service]
ExecStart=/home/lucash/dev-ops-roadmap/projects/dummy-systemd-service/dummy.sh
Restart=always
StandardOutput=append:/var/log/dummy-service.log
StandardError=append:/var/log/dummy-service.log

[Install]
WantedBy=multi-user.target
```

To tell `systemd` to read our service file, you must issue the following command:

```bash
sudo systemctl daemon-reload
```

Now you can enable the service in order for it to execute on start-up. To do so, use the following command:

```bash
sudo systemctl enable dummy.service
```

Lastly, it only remains to start the `systemd` service, to do so, you can run the next snippet:

```bash
sudo systemctl start dummy.service
```

The service should be now running and enabled so that it runs automatically on start-up, you can check the status of the service running the following command:

```bash
sudo sytemctl status dummy.service
```

Output which indicates the correct status of the service:

```bash
● dummy.service - Dummy Service
     Loaded: loaded (/etc/systemd/system/dummy.service; enabled; ve>
     Active: active (running) since Tue 2025-01-21 17:57:30 CET; 2s>
   Main PID: 5756 (dummy.sh)
      Tasks: 2 (limit: 9330)
     Memory: 592.0K
     CGroup: /system.slice/dummy.service
             ├─5756 /bin/bash /home/lucash/dev-ops-roadmap/projects>
             └─5762 sleep 10

Jan 21 17:57:30 LucasPC systemd[1]: Started Dummy Service.
```

Also, this is how the log file `dummy-service.log` looks like after the service has been running for 1 minute and 40 seconds (a log entry each 10 seconds):

```bash
CLI> sudo cat /var/log/dummy-service.log
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
Dummy service is running...
```

You can at last check by starting up your Linux system again, if the service starts running automatically.
