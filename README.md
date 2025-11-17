# Jekyll Simple Blue Notes Theme

A minimal, clean Jekyll theme inspired by Tumblr's classic simple themes. Perfect for personal blogs and technical notes.

## Features

- Clean, minimal design with responsive layout
- Archive page with post listing
- Tag support for organizing content
- RSS feed, SEO tags, and sitemap
- Syntax highlighting for code blocks

## Quick Start

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Configure your site:**
   
   Edit `_config.yml`:
   ```yaml
   title: Your Site Title
   description: Your site description
   url: https://yourdomain.com
   google_analytics: ""  # Optional
   ```

3. **Add required files:**
   
   Create `index.md`:
   ```yaml
   ---
   layout: index
   ---
   ```
   
   Create `archive.md`:
   ```yaml
   ---
   layout: archive
   ---
   ```

4. **Add images (optional):**
   - `assets/images/favicon.png`
   - `assets/images/avatar.png`

5. **Run locally:**
   ```bash
   bundle exec jekyll serve
   ```
   
   Visit `http://localhost:4000`

## Writing Posts

Create posts in `_posts/` with the format `YYYY-MM-DD-title.md`:

```yaml
---
title: "Your Post Title"
date: 2024-01-15
tags: [ruby, jekyll, tutorial]
---

Your content here...
```

## Customization

- **Styles:** Edit `assets/css/custom.scss` or `assets/css/main.scss`
- **Layouts:** Modify templates in `_layouts/`
- **Colors/Variables:** Update `_sass/variables.scss`

## License

MIT
