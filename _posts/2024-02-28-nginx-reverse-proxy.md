---
layout: post
title: "Nginx as a Reverse Proxy for Microservices"
date: 2024-02-28 13:10:00
tags: [nginx, proxy, microservices, devops, infrastructure]
---

Setting up Nginx as a reverse proxy simplified our microservices routing and added a layer of security and performance optimization.

Here's my production config:

```nginx
upstream api_backend {
    least_conn;
    server api1.internal:3000 weight=3;
    server api2.internal:3000 weight=2;
    server api3.internal:3000 weight=1;
}

upstream auth_backend {
    server auth.internal:4000;
}

server {
    listen 80;
    server_name api.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.example.com;
    
    ssl_certificate /etc/ssl/certs/api.crt;
    ssl_certificate_key /etc/ssl/private/api.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    
    # API endpoints
    location /api/ {
        proxy_pass http://api_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Auth service
    location /auth/ {
        proxy_pass http://auth_backend;
        proxy_set_header Host $host;
    }
    
    # Static files with caching
    location /static/ {
        alias /var/www/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

Key features:

• **Load balancing** with weighted round-robin
• **SSL termination** at the proxy layer
• **Header forwarding** to preserve client info
• **Caching** for static assets

For better performance, enable caching:

```nginx
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=api_cache:10m max_size=1g inactive=60m;

location /api/data/ {
    proxy_cache api_cache;
    proxy_cache_valid 200 10m;
    proxy_cache_key "$scheme$request_method$host$request_uri";
    add_header X-Cache-Status $upstream_cache_status;
    
    proxy_pass http://api_backend;
}
```

Rate limiting to prevent abuse:

```nginx
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;

location /api/ {
    limit_req zone=api_limit burst=20 nodelay;
    proxy_pass http://api_backend;
}
```

This setup handles 10k req/s with minimal latency. Nginx is incredibly efficient as a proxy.
