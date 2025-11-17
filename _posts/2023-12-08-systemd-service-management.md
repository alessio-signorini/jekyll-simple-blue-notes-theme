---
layout: post
title: "Managing Services with Systemd"
date: 2023-12-08 15:45:00
tags: [systemd, linux, devops, services, automation]
---

I used to run Node.js apps with `pm2` or `forever`, but systemd is built into most Linux distros and more reliable for production.

Here's a basic service file for a Node.js app:

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Node.js Application
After=network.target

[Service]
Type=simple
User=nodeapp
WorkingDirectory=/opt/myapp
Environment="NODE_ENV=production"
Environment="PORT=3000"
ExecStart=/usr/bin/node server.js
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Enable and start it:

```bash
sudo systemctl enable myapp.service
sudo systemctl start myapp.service
```

The `Restart=on-failure` directive automatically restarts the app if it crashes. Much better than a cron job checking every minute.

For apps that need dependencies, use ordering:

```ini
[Unit]
Description=My Web App
After=network.target postgresql.service redis.service
Requires=postgresql.service redis.service
```

This ensures the database and Redis are running before starting your app.

View logs with `journalctl`:

```bash
# Follow logs in real-time
sudo journalctl -u myapp.service -f

# View logs from today
sudo journalctl -u myapp.service --since today

# Show last 100 lines
sudo journalctl -u myapp.service -n 100
```

For scheduled tasks, use systemd timers instead of cron:

```ini
# /etc/systemd/system/backup.service
[Unit]
Description=Daily Backup Job

[Service]
Type=oneshot
ExecStart=/opt/scripts/backup.sh
```

```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Run backup daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Enable the timer:

```bash
sudo systemctl enable backup.timer
sudo systemctl start backup.timer
```

Benefits over cron:

• Better logging via journald
• Dependencies between services
• Easy status checking
• Automatic restart on failure

I've converted all my production services to systemd and haven't looked back.
