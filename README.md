# Getting Started

As of this writing (12 May 2018), the project uses XCode 9.4 beta, which requires Apple Developer membership to obtain.

The project uses Carthage for dependency management:

```brew install carthage
```carthage update

# Tests

Test implementation leaves much to be desired. But you can run the test suite via CMD+U in Xcode.

# User Experience

Significant inspiration was found in the [Bear app](http://www.bear-writer.com/). Additional and alternate contributions are welcome.

# The Ghost API

The [Ghost API](https://api.ghost.org/) seems to be a work in progress. Documentation only covers read-only GETs, but not POST, PUT, and DELETE operations necessary to create, update, and delete posts (and tags). The docs are clear that these APIs might change. Implementation herein is based on inspection of the [Ghost Android App codebase](https://github.com/TryGhost/Ghost-Android) and browser inspection of network calls from the web admin app.

Manipulating posts requires use of mobiledoc format, which is new to me/Ray. It's difficult to tell if I got it right.

The process for fetching the client secret at login is a bit vague. Again, this implementation is entirely based on inference.

# To do

See https://trello.com/b/QQJvqV91/ghost-ios
