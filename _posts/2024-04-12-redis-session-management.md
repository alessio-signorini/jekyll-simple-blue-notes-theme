---
layout: post
title: "Using Redis for Scalable Session Management"
date: 2024-04-12 14:20:00
tags: [redis, session, scaling, backend, cache]
---

When our app started hitting scale issues, one bottleneck was session storage. Moving to Redis solved our problems and simplified our architecture.

Here's a basic Node.js setup with `express-session`:

```javascript
const session = require('express-session');
const RedisStore = require('connect-redis').default;
const { createClient } = require('redis');

const redisClient = createClient({
  host: 'localhost',
  port: 6379,
  legacyMode: true
});

redisClient.connect().catch(console.error);

app.use(session({
  store: new RedisStore({ client: redisClient }),
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: true,
    httpOnly: true,
    maxAge: 1000 * 60 * 60 * 24 // 24 hours
  }
}));
```

The beauty of Redis for sessions:

• **Fast**: In-memory reads/writes
• **Automatic expiry**: TTL built-in
• **Scalable**: Multiple app servers can share session state
• **Simple**: No database schema needed

For better performance, I use a connection pool:

```javascript
const redisClient = createClient({
  socket: {
    host: 'localhost',
    port: 6379
  },
  database: 0,
  maxRetriesPerRequest: 3
});
```

Session data structure:

```redis
# Session key format
sess:Fj5sD8k3L...

# Typical session data
{
  "cookie": {"maxAge": 86400000},
  "userId": "12345",
  "roles": ["user", "admin"]
}
```

For added security, I hash session IDs:

```javascript
const crypto = require('crypto');

function generateSessionId() {
  return crypto.randomBytes(32).toString('hex');
}
```

Monitor your Redis instance:

```bash
redis-cli INFO stats
redis-cli MEMORY STATS
```

Since switching, we've scaled to 100k concurrent users with zero session-related issues.
