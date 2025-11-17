---
layout: post
title: "Setting Up Docker Compose for Local Development"
date: 2024-11-10 14:30:00
tags: [docker, devops, development, containers, compose]
---

I've been using Docker Compose to standardize development environments across my team, and it's been a game changer for onboarding new developers.

The key is to create a `docker-compose.yml` that mirrors production as closely as possible while still being convenient for local dev:

```yaml
version: '3.8'
services:
  web:
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
      POSTGRES_DB: myapp_dev
      POSTGRES_PASSWORD: devpass
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

The trick is mounting the current directory as a volume but excluding `node_modules` so you don't sync massive dependency folders. This gives you hot reload while keeping things fast.

For convenience, I add a `Makefile` with common commands:

```makefile
up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

shell:
	docker-compose exec web sh
```

Now new developers just run `make up` and they're ready to code. No more "works on my machine" issues.
