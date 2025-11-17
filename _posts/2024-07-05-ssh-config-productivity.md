---
layout: post
title: "SSH Config Tricks for Developer Productivity"
date: 2024-07-05 09:20:00
tags: [ssh, productivity, devops, linux, configuration]
---

I spent years typing out full SSH commands until I discovered how powerful `~/.ssh/config` really is.

Here's my current setup:

```ssh
# Default settings for all hosts
Host *
  ServerAliveInterval 60
  ServerAliveCountMax 3
  Compression yes
  
# Production server
Host prod
  HostName prod.example.com
  User deploy
  IdentityFile ~/.ssh/prod_rsa
  ForwardAgent yes

# Jump through bastion
Host internal-*
  ProxyJump bastion
  User admin
  
Host bastion
  HostName bastion.example.com
  User jump_user
  IdentityFile ~/.ssh/bastion_key

# Development servers with port forwarding
Host dev
  HostName dev.example.com
  User developer
  LocalForward 5432 localhost:5432
  LocalForward 6379 localhost:6379
```

Now instead of:

```bash
ssh -i ~/.ssh/prod_rsa -A deploy@prod.example.com
```

I just type:

```bash
ssh prod
```

The `ProxyJump` directive is especially useful for accessing servers behind a bastion host. Before, I had to SSH twice. Now it's seamless.

For dynamic port forwarding (SOCKS proxy), add:

```ssh
Host proxy
  HostName proxy.example.com
  DynamicForward 8080
```

Then configure your browser to use `localhost:8080` as a SOCKS proxy, and all your traffic routes through that server.

Another trick: multiplexing connections to speed up repeated SSHs:

```ssh
Host *
  ControlMaster auto
  ControlPath ~/.ssh/control-%r@%h:%p
  ControlPersist 10m
```

The first SSH connection establishes a master, and subsequent ones reuse it. Much faster.

These simple configs save me dozens of keystrokes every day.
