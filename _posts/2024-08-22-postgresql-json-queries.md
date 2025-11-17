---
layout: post
title: "Querying JSONB Data in PostgreSQL Efficiently"
date: 2024-08-22 16:45:00
tags: [postgresql, database, JSON, SQL, performance]
---

PostgreSQL's JSONB support is powerful, but it's easy to write slow queries. Here's what I learned optimizing a reporting system.

First, always use JSONB (not JSON) for better performance:

```sql
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  data JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

For queries, the `->` and `->>` operators are your friends:

```sql
-- -> returns JSONB
-- ->> returns text

SELECT data->'user'->>'email' as email
FROM events
WHERE data->'event_type' ->> 'name' = 'login';
```

The game-changer was adding GIN indexes on commonly queried JSON paths:

```sql
-- Index the entire JSONB column
CREATE INDEX idx_events_data ON events USING GIN (data);

-- Or index specific paths
CREATE INDEX idx_events_user_email 
ON events ((data->'user'->>'email'));
```

For containment queries, use the `@>` operator:

```sql
-- Find events where user.role is "admin"
SELECT * FROM events
WHERE data @> '{"user": {"role": "admin"}}';
```

With proper indexing, these queries went from 30 seconds to under 100ms on millions of rows.

Pro tip: Use `jsonb_path_query` for complex extractions:

```sql
SELECT jsonb_path_query(data, '$.users[*] ? (@.age > 18).name')
FROM events;
```

JSONB gives you schema flexibility without sacrificing query performance.
