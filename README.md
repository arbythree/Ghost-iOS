# Getting Started

The project uses Carthage for dependency management:

```brew install carthage
```carthage update

Because I/Ray haven't yet figured out how to fetch a token, you have to store your token in a structure like this:

```struct Secrets {
```  static let ghostSecretKey = "<your secret key>"
```}

Add a Secrets.swift file to your project and paste this in and it'll work swimmingly.

# To do

See https://trello.com/b/QQJvqV91/ghost-ios for definitive list

- New posts
- Editor formatting
  - Blockquotes
  - Headings
  - Bullets
  - Numbered lists
  - Insert links
- Other editing facilities
  - Rename post titles
  - Publish / unpublish
  - Post URL
  - Publish date
  - Excerpt
  - Author
  - Metadata
  - Feature this page
  - View post
- Correctly fetch client secret at login
- Deal with refresh tokens
- Layouts and pane management are optimized for iPad at the moment; need phone layout logic
  - Fewer simultaneous panes (more toggling)
  - Editor padding
  - Animate layouts
- Resize windows on keyboard display
- Animate input accessory layout on keyboard display
- Icons for input accessory (bold, italic, etc.)
- Icons for navigation bar (info, preview, settings, etc.)
- Tagging
- Tests!
