---
layout: post
title: "Docker Compose Development Workflow"
date: 2024-03-15 14:30:00
tags: [docker, compose, development, containers, devops]
---

I've been using Docker Compose to manage my development environments and it's been a game changer. Here's a simple setup that works great for full-stack applications.

The key is to have a `docker-compose.yml` that includes all your services:

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

With hot reloading enabled, you can make changes and see them reflected immediately. The volume mount ensures your code changes are picked up, while `/app/node_modules` is kept in the container for better performance.

To start everything:

```bash
docker-compose up -d
docker-compose logs -f app
```

And to reset your database:

```bash
docker-compose down -v
docker-compose up -d
```

This setup keeps development consistent across the team and makes onboarding new developers trivial.
