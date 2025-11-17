---
layout: post
title: "Finding Bugs with Git Bisect"
date: 2024-01-15 10:30:00
tags: [git, debugging, version-control, productivity, tools]
---

A critical bug appeared in production, but no one knew which commit introduced it. Git bisect found the culprit in minutes.

The process is surprisingly simple:

```bash
# Start bisecting
git bisect start

# Mark current commit as bad
git bisect bad

# Mark last known good commit
git bisect good v2.1.0

# Git checks out a commit in the middle
# Test it, then mark as good or bad
git bisect good
# or
git bisect bad

# Repeat until Git finds the culprit
```

Git automatically does binary search, testing ~log₂(n) commits. For 1000 commits, that's only 10 tests!

Even better, you can automate it:

```bash
git bisect start HEAD v2.1.0
git bisect run npm test
```

Git will run your test suite on each commit and automatically find when it started failing.

For manual testing, I use this script:

```bash
#!/bin/bash
# test_bug.sh

npm install --silent
npm run build --silent

# Test the specific bug
if curl -s http://localhost:3000/api/health | grep -q "ok"; then
    exit 0  # Good commit
else
    exit 1  # Bad commit
fi
```

Then:

```bash
git bisect run ./test_bug.sh
```

Real example from last week:

```bash
$ git bisect start
$ git bisect bad
$ git bisect good v3.2.0

Bisecting: 156 revisions left to test after this
[abc123] Add user preferences feature

$ git bisect run npm test

# ... Git tests commits ...

abc456ef is the first bad commit
Author: John Doe <john@example.com>
Date:   Mon Jan 8 14:23:45 2024

    Refactor authentication middleware
```

Found in 8 steps instead of manually checking 156 commits!

Pro tip: Use `git bisect skip` if a commit is untestable (e.g., build fails):

```bash
git bisect skip
```

Since learning bisect, I've saved hours of debugging time. It's now my go-to for regression hunting.
