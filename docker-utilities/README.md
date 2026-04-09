# Docker Utilities

Scripts to monitor Docker usage and clean up unused resources to keep the system stable and avoid disk space issues.

## Scripts

- [`docker-monitor.sh`](./docker-monitor.sh)
- [`cleanup-docker.sh`](./cleanup-docker.sh)

---

## docker-monitor.sh

Collects Docker container stats regularly and stores them in daily log files.

### What it does

- Captures container CPU and memory usage  
- Logs data every run into date-based files  
- Keeps historical usage for troubleshooting and analysis  
- Automatically deletes logs older than 30 days  

### Logging

Logs are stored in:

```

/var/log/docker-monitor/

```

Format:

```

docker-monitor-YYYY-MM-DD.log

````

### Schedule

Run frequently for better visibility:

```bash
*/10 * * * * /home/ubuntu/docker-utilities/docker-monitor.sh
````

---

##  cleanup-docker.sh

Performs a full cleanup of unused Docker resources.

### What it does

* Removes unused containers, images, networks, and volumes
* Logs disk usage before and after cleanup
* Helps prevent Docker from consuming excessive disk space
* Automatically deletes old logs (>30 days)

### Logging

Logs are stored in:

```
/var/log/docker-cleanup/
```

Format:

```
docker-cleanup-YYYY-MM-DD.log
```

### Recommended Schedule

Run once per week at midnight (low activity time):

```bash
0 0 * * 0 /home/ubuntu/docker-utilities/cleanup-docker.sh
```

---

## Why this is useful

* Keeps Docker environments clean and under control
* Provides visibility into container resource usage
* Helps detect high resource consumption early
* Reduces manual maintenance and production risks
