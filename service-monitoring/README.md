
# Service Monitoring Scripts

Scripts to monitor system health and send alerts when issues happen.

##  Scripts

- [`disk-usage-alert.sh`](./disk-usage-alert.sh)

---

##  disk-usage-alert.sh

Monitors disk usage on the root partition and sends an email alert if it exceeds a defined threshold.

### What it does

- Checks `/` disk usage  
- Sends an alert email if usage ≥ threshold (default 85%)  
- Logs each check to `/var/log/disk_alert.log`  

### How it works

- Uses hostname and first IP address for identification  
- Email contains server details and recommended action  
- Helps prevent disk space issues

### Setting Up Email Alerts

1. **Install Postfix and mail utilities**

```bash
sudo apt update
sudo apt install postfix mailutils
````

* During installation, choose **“Internet Site”**
* For **System mail name**, enter server hostname (or leave default)

2. **Test sending email**

```bash
echo "Testing" | mail -s "Test Email" rouis.khawla09@gmail.com
```

* If you receive the test email, the setup is ready

3. **Use in script**

* The `disk-usage-alert.sh` script will now send alerts automatically using Postfix


###  Usage

**Add execute rule to the script**

```bash
chmod +x disk-usage-alert.sh
````

**Using cron job**

Run it daily using cron:

* First open crontab 
```bash
 sudo crontab -e
```
* Then add this line
```bash
0 * * * * /home/ubuntu/disk-usage-alert.sh
```

###  Why this is useful

* Prevents root partition from filling up unnoticed
* Provides early warnings before critical issues
* Keeps a log of usage history for auditing and troubleshooting
