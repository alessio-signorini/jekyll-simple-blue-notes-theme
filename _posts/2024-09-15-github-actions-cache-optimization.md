---
layout: post
title: "Optimizing GitHub Actions with Smart Caching"
date: 2024-09-15 10:15:00
tags: [github, CI/CD, optimization, devops, automation]
---

Our GitHub Actions workflows were taking 15+ minutes to run. After some investigation, I realized we weren't caching dependencies effectively.

Here's the setup that cut our build times by 70%:

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Cache dependencies
        uses: actions/cache@v3
        with:
          path: |
            ~/.npm
            node_modules
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-node-
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
```

The key insights:

• Use `npm ci` instead of `npm install` for deterministic installs
• Cache both `~/.npm` and `node_modules`
• Use `hashFiles()` to invalidate cache when dependencies change
• The `restore-keys` fallback helps with partial cache hits

For Docker builds, we also cache layers:

```yaml
- name: Build Docker image
  uses: docker/build-push-action@v4
  with:
    context: .
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

Now our CI runs in under 5 minutes. Much better developer experience.
