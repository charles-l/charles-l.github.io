---
layout: post
title:  "TODO Notifier"
date:   2014-06-12 08:19:29
categories: ruby
---

So, I made a new thing. It's called TODONotifier. It parses a TODO file in your home directory, scans for dates and pops up a notification for a task when the time is appropriate.

### Why another TODO program thingy?
I don't like working with most GUI TODO programs, because they force me to stop whatever I'm doing in the terminal to cross off tasks or add new ones. I don't like working with CLI clients, because I forgot they exist and don't use them, and they generate ugly XML files that are hard to edit manually. I like plain text that's easy to edit in VIM. Thus, I usually end up creating raw text files that have no OS X integration. TODONotifier adds the OS X integration.

### Some libraries I used
TODONotifier uses the awesome [terminal-notifier](https://github.com/alloy/terminal-notifier) gem to pop up notifications. Along with terminal-notifiers API, there's a binary executable that can be called from the command line, which is super useful when I need a quick notification so I know when a build is done or a file has downloaded.

One of the coolest libraries that TODONotifier uses is the natural language date parser called [SmarterDates](https://github.com/belt/smarter_dates). It's what makes TODONotifier easy to use. Dates are annoying and hard to work with and SmarterDates made it much more painless for both me as the programmer, and very beneficial to the end user.

### Quick Tutorial
To use TODONotifier:

  1. Install the TODONotifier gem: `gem install todoNotifier`
  2. Create a `.todo` file in your home directory
    1. Lines starting with `-`, `#`, `*` or a tab denote a task.
    2. Lines that are all caps are considered headers and are ignored.
    3. Dates can be parsed in a human readable format, so `Play Portal 2 tomorrow`, or `Fix bug #244 next week` are perfectly valid date formats. You'll get the notification relative to when `todonotifier` is stated.
  3. Start the TODONotifier daemon: `todonotifier start` (if you want start the daemon when you login just add it to your ~/.bashrc file)
  4. If you need to stop the daemon use `todonotifier stop`

So, thanks for reading this rather rambly blog post. I'm pretty proud of this project - which just shows how amateur I am - but I feel like it's pretty useful. If you want to contribute to it, that would be awesome too.
