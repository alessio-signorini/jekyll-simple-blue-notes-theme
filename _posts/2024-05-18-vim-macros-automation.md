---
layout: post
title: "Automating Repetitive Edits with Vim Macros"
date: 2024-05-18 11:00:00
tags: [vim, productivity, editor, automation, workflow]
---

I recently had to refactor 50+ files with similar but not identical changes. Vim macros saved me hours of tedious work.

Here's the pattern I use:

1. Position cursor at the start
2. Press `qa` to start recording into register 'a'
3. Make your changes
4. Press `q` to stop recording
5. Replay with `@a`, repeat with `@@`

Example: Converting function declarations to arrow functions:

```javascript
// Before
function handleClick(event) {
  event.preventDefault();
  // ...
}

// After
const handleClick = (event) => {
  event.preventDefault();
  // ...
};
```

The macro:

```vim
qa          " Start recording
^df(        " Delete from start to opening paren
iconst <Esc>" Insert 'const '
f)a =>      " Find closing paren, add arrow
f}a;<Esc>   " Add semicolon after closing brace
j           " Move to next line
q           " Stop recording
```

Then `99@a` applies it to the next 99 functions.

For more complex refactoring, I use the `:g` command:

```vim
" Remove all console.log statements
:g/console\.log/d

" Add 'async' to all function declarations
:g/^function/s/function/async function/
```

Combining macros with visual block mode is powerful:

```vim
" Add comma to end of 10 lines
Ctrl-v      " Enter visual block mode
10j         " Select 10 lines
$           " Go to end
A,<Esc>     " Append comma
```

Pro tip: Save macros between sessions:

```vim
" In .vimrc
let @a = '^df(iconst f)a =>f}a;j'
```

Learning macros made me realize how much time I was wasting on "simple" repetitive edits.
