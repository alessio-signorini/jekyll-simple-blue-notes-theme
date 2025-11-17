# Jekyll Simple Blue Notes Theme

A minimal, clean Jekyll theme inspired by one of Tumblr's old simple themes.

## Features

- Clean, minimal design
- Responsive layout
- Archive page
- Tag support
- RSS feed ready
- Simple navigation

## Setup

1. Install dependencies:
```bash
bundle install
```

2. Run the site locally:
```bash
bundle exec jekyll serve
```

3. Visit `http://localhost:4000` in your browser

## Configuration

Edit `_config.yml` to customize:
- Site title and description
- URL settings

Remember to add `assets/images/favicon.png` and `assets/images/avatar.png`.

## Writing Posts

Create new posts in the `_posts` directory following the naming convention:

```bash
/_posts/YYYY-MM-DD-title-of-post.md
```

Front matter example:
```yaml
---
title: "Your Post Title"
date: 2021-05-15
tags: [tag1, tag2, tag3]
---
```

## Customization

- Modify `assets/css/main.css` for styling changes
- Edit layouts in `_layouts/` directory
- Update navigation in `_layouts/default.html`

## License

Free to use and modify.
