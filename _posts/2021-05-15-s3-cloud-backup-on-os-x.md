---
layout: post
title: "S3 Cloud Backup on OS X"
date: 2021-05-15
tags: [backup, cloud, S3, AWS, CLI, rsync, crontab]
---

I recently setup my personal laptop and decided to put together a cheap backup solution to keep a copy of important things (e.g., `Documents`) in the cloud.

I decided to use the [AWS CLI](https://aws.amazon.com/cli/) and `crontab` to do a periodic sync at midnight to an S3 bucket.

After some experimenting, the simplest and most comfortable solution was to create a `.backup` directory in my home folder and put the following executable `sync` script in it:

```bash
/usr/local/bin/aws s3 sync ~/.backup/ s3://BUCKETNAME/BUCKETPATH --profile sync --follow-symlinks --sse AES256 --storage-class INTELLIGENT_TIERING --exclude last.log --delete 2>&1 > ~/.backup/last.log
```

It's important to create/obtain appropriate credentials for the AWS CLI command to work and set them up in `.aws/credentials` with the `sync` profile as in:

```yaml
[sync]
aws_access_key_id = AKIARAUBNPWZYTCHRH8N
aws_secret_access_key = 60b725f10c9c85c70d97880dfe8191b3
```

And then to create a `crontab -e` entry that says when to run it (mine tries every hour):

```bash
0 * * * * ~/.backup/sync
```

Now it is sufficient to create symlinks from the `.backup` directory to anything to backup and that script will pick it up at the next round. My `.backup` directory looks like:

```bash
Apr 11 22:45 .aws -> /Users/alessio/.aws
Apr 11 23:11 .ssh -> /Users/alessio/.ssh
Apr 11 22:41 .zshrc -> /Users/alessio/.zshrc
Apr 11 22:58 Applications -> /Applications
Apr 11 21:17 Documents -> /Users/alessio/Documents
May 27 21:00 last.log
Apr 12 08:41 sync
```

It may take a bit at the first backup but then will be fast as it will only sync the differences.
